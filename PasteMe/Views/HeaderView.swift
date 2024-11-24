import Defaults
import SwiftUI

struct HeaderView: View {
  @FocusState.Binding var searchFocused: Bool
  @Binding var searchQuery: String

  @Environment(AppState.self) private var appState
  @Environment(\.scenePhase) private var scenePhase
  
  //避免关闭Panel后下次打开，popover依然打开的问题
  @EnvironmentObject private var panelState: PanelState

  var body: some View {
    HStack {
      SearchFieldView(placeholder: "search_placeholder", query: $searchQuery)
        .focused($searchFocused)
        .frame(maxWidth: .infinity)
        .onChange(of: scenePhase) {
          if scenePhase == .background && !searchQuery.isEmpty {
            searchQuery = ""
          }
        }
      Image(systemName: "ellipsis").resizable().aspectRatio(contentMode: .fit).frame(width: 15, height: 15).contentShape(Rectangle()).onTapGesture {
        panelState.showMenu.toggle()
      }.popover(isPresented: $panelState.showMenu) {
        FooterView(footer: appState.footer)
      }
    }
    .frame(height: appState.searchVisible ? 25 : 0)
    .opacity(appState.searchVisible ? 1 : 0)
    .padding(.horizontal, 10)
    // 2px is needed to prevent items from showing behind top pinned items during scrolling
    // https://github.com/p0deje/Maccy/issues/832
    .padding(.bottom, appState.searchVisible ? 5 : 2)
    .background {
      GeometryReader { geo in
        Color.clear
          .task(id: geo.size.height) {
            appState.popup.headerHeight = geo.size.height
          }
      }
    }
  }
}
