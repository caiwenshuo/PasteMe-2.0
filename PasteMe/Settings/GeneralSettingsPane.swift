import SwiftUI
import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import Settings

struct GeneralSettingsPane: View {
  private let notificationsURL = URL(
    string: "x-apple.systempreferences:com.apple.preference.notifications?id=\(Bundle.main.bundleIdentifier ?? "")"
  )

  @State private var copyModifier = HistoryItemAction.copy.modifierFlags.description
  @State private var pasteModifier = HistoryItemAction.paste.modifierFlags.description
  @State private var pasteWithoutFormatting = HistoryItemAction.pasteWithoutFormatting.modifierFlags.description

  @Default(.pasteTarget) private var pasteTarget
  @State private var previewPlaceHolder = "Space"
  
  var body: some View {
    Settings.Container(contentWidth: 450) {
      Settings.Section(title: "", bottomDivider: true) {
        LaunchAtLogin.Toggle {
          Text("LaunchAtLogin", tableName: "GeneralSettings")
        }
      }

      Settings.Section(label: { Text("Open", tableName: "GeneralSettings") }) {
        KeyboardShortcuts.Recorder(for: .popup)
          .help(Text("OpenTooltip", tableName: "GeneralSettings"))
      }
      Settings.Section(label: { Text("Pin", tableName: "GeneralSettings") }) {
        KeyboardShortcuts.Recorder(for: .pin)
          .help(Text("PinTooltip", tableName: "GeneralSettings"))
      }
      Settings.Section(
        label: { Text("Delete", tableName: "GeneralSettings") }
      ) {
        KeyboardShortcuts.Recorder(for: .delete)
          .help(Text("DeleteTooltip", tableName: "GeneralSettings"))
      }
      Settings.Section(
        bottomDivider: true,
        label: { Text("Preview", tableName: "GeneralSettings") }
      ) {
        TextField("Space", text: $previewPlaceHolder).textFieldStyle(.roundedBorder).frame(width: 130).multilineTextAlignment(.center).disabled(true)
      }
      

      Settings.Section(
        bottomDivider: true,
        label: { Text("Behavior", tableName: "GeneralSettings") }
      ) {
        Picker("", selection: $pasteTarget) {
          ForEach(PasteTarget.allCases) { target in
            VStack(alignment: .leading, spacing: 4) {
              Text(target.description)
              Text(target == .activeApp ? 
                "Paste selected items directly to the application you are currently using." :
                "Copy selected items to the system clipboard to paste manually later.", tableName: "GeneralSettings")
                .foregroundStyle(.gray)
                .font(.system(size: 11))
                .fixedSize(horizontal: false, vertical: true)
            }
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
        .frame(width: 300, alignment: .leading)
        .onChange(of: pasteTarget) { oldValue, newValue in
          //原有代码是使用.pasteByDefault使用，为了避免大幅修改原有代码，故做了pasteTarget到.pasteByDefault的映射
          Defaults[.pasteByDefault] = (newValue == .activeApp)
          refreshModifiers(newValue)
        }

        Defaults.Toggle(key: .removeFormattingByDefault) {
          Text("PasteWithoutFormatting", tableName: "GeneralSettings")
        }
        .onChange(refreshModifiers)
        .fixedSize()

        Text(String(
          format: NSLocalizedString("Modifiers", tableName: "GeneralSettings", comment: ""),
          copyModifier, pasteModifier, pasteWithoutFormatting
        ))
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(.gray)
        .controlSize(.small)
      }
    }
  }

  private func refreshModifiers(_ sender: Sendable) {
    copyModifier = HistoryItemAction.copy.modifierFlags.description
    pasteModifier = HistoryItemAction.paste.modifierFlags.description
    pasteWithoutFormatting = HistoryItemAction.pasteWithoutFormatting.modifierFlags.description
  }
}

#Preview {
  GeneralSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
