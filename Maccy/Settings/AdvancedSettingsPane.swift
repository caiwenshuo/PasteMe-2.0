import SwiftUI
import Defaults

struct AdvancedSettingsPane: View {
  var body: some View {
    VStack(alignment: .leading) {
      Defaults.Toggle(key: .ignoreEvents) {
        Text("TurnOff", tableName: "AdvancedSettings")
      }
      Text("TurnOffDescription", tableName: "AdvancedSettings")
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(.gray)
        .controlSize(.small)

      Divider()

      Defaults.Toggle(key: .clearOnQuit) {
        Text("ClearHistoryOnQuit", tableName: "AdvancedSettings")
      }.help(Text("ClearHistoryOnQuitTooltip", tableName: "AdvancedSettings"))

      Defaults.Toggle(key: .clearSystemClipboard) {
        Text("ClearSystemClipboard", tableName: "AdvancedSettings")
      }.help(Text("ClearSystemClipboardTooltip", tableName: "AdvancedSettings"))
    }
    .frame(minWidth: 350, maxWidth: 450)
    .padding()
  }
}

#Preview {
  AdvancedSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
