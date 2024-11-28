import Defaults
import SwiftUI

struct HistoryItemView: View {
  @Bindable var item: HistoryItemDecorator
  @FocusState.Binding var searchFocused: Bool

  @Environment(AppState.self) private var appState

  var body: some View {
    ListItemView(
      id: item.id,
      image: item.thumbnailImage ?? ColorImage.from(item.title),
      attributedTitle: item.attributedTitle,
      shortcuts: item.shortcuts,
      isSelected: item.isSelected,
      searchFocused: $searchFocused
    ) {
      Text(verbatim: item.text)
    }
    .onTapGesture {
      appState.history.select(item)
    }
    .popover(isPresented: $item.showPreview, arrowEdge: .trailing) {
      PreviewItemView(item: item)
    }
    .contextMenu(menuItems: {
      ForEach(appState.contextMenu.items){ menuItem in
        ContextItemView(menuItem: menuItem, historyItem: item)
      }
    })
  }
}
