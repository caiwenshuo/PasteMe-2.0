import Defaults
import SwiftUI

struct HistoryListView: View {
  @Binding var searchQuery: String
  @FocusState.Binding var searchFocused: Bool

  @Environment(AppState.self) private var appState
  @Environment(ModifierFlags.self) private var modifierFlags
  @Environment(\.scenePhase) private var scenePhase

  @Default(.pinTo) private var pinTo
  @Default(.previewDelay) private var previewDelay

  var body: some View {
    if pinTo == .top {
      LazyVStack(spacing: 8) {
        ForEach(appState.history.pinnedItems.filter(\.isVisible)) { item in
          HistoryItemView(item: item, searchFocused: $searchFocused)
        }
      }
      .background {
        GeometryReader { geo in
          Color.clear
            .task(id: geo.size.height) {
              appState.popup.pinnedItemsHeight = geo.size.height
            }
        }
      }
      .padding(.bottom, 8)
    }

    ScrollView(showsIndicators: false) {
      ScrollViewReader { proxy in
        LazyVStack(spacing: 8) {
          ForEach(appState.history.unpinnedItems) { item in
            HistoryItemView(item: item, searchFocused: $searchFocused)
          }
        }
        .task(id: appState.scrollTarget) {
          guard appState.scrollTarget != nil else { return }

          try? await Task.sleep(for: .milliseconds(10))
          guard !Task.isCancelled else { return }

          if let selection = appState.scrollTarget {
            proxy.scrollTo(selection)
            appState.scrollTarget = nil
          }
        }
        .onChange(of: scenePhase) {
          if scenePhase == .active {
            searchFocused = false
            appState.selection = appState.history.unpinnedItems.first?.id
          } else {
            modifierFlags.flags = []
          }
        }
        // Calculate the total height inside a scroll view.
        .background {
          GeometryReader { geo in
            Color.clear
              .task(id: appState.popup.needsResize) {
                try? await Task.sleep(for: .milliseconds(10))
                guard !Task.isCancelled else { return }

                if appState.popup.needsResize {
                  appState.popup.resize(height: geo.size.height)
                }
              }
          }
        }
      }
      .contentMargins(.leading, 10, for: .scrollIndicators)
    }

    if pinTo == .bottom {
      LazyVStack(spacing: 8) {
        ForEach(appState.history.pinnedItems.filter(\.isVisible)) { item in
          HistoryItemView(item: item, searchFocused: $searchFocused)
        }
      }
      .background {
        GeometryReader { geo in
          Color.clear
            .task(id: geo.size.height) {
              appState.popup.pinnedItemsHeight = geo.size.height
            }
        }
      }
    }
  }
}
