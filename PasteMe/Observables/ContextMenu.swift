import Defaults
import SwiftUI

@Observable
class ContextMenu {
  var items: [ContextMenuItem] = []

  init() { // swiftlint:disable:this function_body_length
    items = [
      ContextMenuItem(
        title: "Preview"
      ) {_ in
        Task { @MainActor in
          AppState.shared.history.showPreview.toggle()
        }
      },
      ContextMenuItem(
        title: "Paste"
      ) {item in
        Task { @MainActor in
          AppState.shared.history.copy(item)
        }
      },
      ContextMenuItem(
        title: "Paste without formatting"
      ) {item in
        Task { @MainActor in
          AppState.shared.history.pasteWithoutFormatting(item)
        }
      },
      ContextMenuItem(
        title: "Pin/Unpin"
      ) {item in
        Task{ @MainActor in
          AppState.shared.history.togglePin(item)
        }
      },
      ContextMenuItem(
        title: "Delete"
      ) {item in
        Task { @MainActor in
          AppState.shared.highlightNext()
          AppState.shared.history.delete(item)
        }
      }
    ]
  }
}
