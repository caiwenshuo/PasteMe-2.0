import Defaults
import SwiftUI

struct HeaderView: View {
  @FocusState.Binding var searchFocused: Bool
  @Binding var searchQuery: String

  @Environment(AppState.self) private var appState
  @Environment(\.scenePhase) private var scenePhase
  @State var fakeQuery = ""
  
  //避免关闭Panel后下次打开，popover依然打开的问题
  @EnvironmentObject private var panelState: PanelState
  @FocusState private var inverseFocusState: Bool


  var body: some View {
    HStack {
      SearchFieldView(placeholder: "search_placeholder", query: $searchQuery, searchFocused: $searchFocused)
        .focused($searchFocused)
        .frame(maxWidth: .infinity)

      //不可见的SearchView以获取焦点，才可以触发space等快捷键
      SearchFieldView(placeholder: "search_placeholder", query: $fakeQuery, searchFocused: $inverseFocusState)
        .focused($inverseFocusState)
        .frame(width: 0, height: 0).opacity(0).onChange(of: searchFocused) { newValue in
          inverseFocusState = !newValue
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
