import SwiftUI

struct SearchFieldView: View {
    var placeholder: LocalizedStringKey
    @Binding var query: String

    @Environment(AppState.self) private var appState
    @State private var inputText: String = ""
    @FocusState.Binding var searchFocused: Bool
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var panelState: PanelState

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.secondary)
                .opacity(0.1)
                .frame(height: 23)

            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: 11, height: 11)
                    .padding(.leading, 5)
                    .opacity(0.8)

                TextField(placeholder, text: $inputText, onCommit: {
                    query = inputText
                    searchFocused = false
                })
                .onChange(of: searchFocused, { oldValue, newValue in
                  panelState.searchFocused = newValue
                })
                .onChange(of: inputText, { oldValue, newValue in
                  if newValue.isEmpty {
                    query = ""
                  }
                })
                .onChange(of: panelState.searchFocused, { oldValue, newValue in
                  searchFocused = newValue
                })
                .disableAutocorrection(true)
                .lineLimit(1)
                .textFieldStyle(.plain)

                if !inputText.isEmpty {
                    Button {
                        inputText = ""
                        query = ""
                        searchFocused = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(width: 11, height: 11)
                            .padding(.trailing, 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(inputText.isEmpty ? 0 : 0.9)
                }
            }
        }
        .onChange(of: scenePhase) {
          if scenePhase == .background && (!query.isEmpty || !inputText.isEmpty) {
            inputText = ""
            query = ""
          }
        }
    }
}

//#Preview {
//    return List {
//        SearchFieldView(placeholder: "search_placeholder", query: .constant(""))
//        SearchFieldView(placeholder: "search_placeholder", query: .constant("search"))
//    }
//    .frame(width: 300)
//    .environment(\.locale, .init(identifier: "en"))
//}
