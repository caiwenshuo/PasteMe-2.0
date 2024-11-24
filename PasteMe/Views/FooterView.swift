import Defaults
import SwiftUI

struct FooterView: View {
  @Bindable var footer: Footer

  @Environment(AppState.self) private var appState
  @Environment(ModifierFlags.self) private var modifierFlags
  @Default(.showFooter) private var showFooter
  @State private var clearOpacity: Double = 1
  @State private var clearAllOpacity: Double = 0

  var body: some View {
    VStack(spacing: 0) {
      ForEach(footer.items) { item in
        FooterItemView(item: item)
      }
    }
    .background {
      GeometryReader { geo in
        Color.clear
          .task(id: geo.size.height) {
            appState.popup.footerHeight = geo.size.height
          }
      }
    }
    .opacity(showFooter ? 1 : 0)
    .frame(height: showFooter ? .infinity : 0)
  }
}
