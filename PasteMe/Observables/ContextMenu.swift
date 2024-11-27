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
          AppState.shared.history.select(item)
        }
      },
      ContextMenuItem(
        title: "Paste without formatting"
      ) {_ in
        Task { @MainActor in
          AppState.shared.openPreferences()
        }
      },
      ContextMenuItem(
        title: "Pin"
      ) {_ in
        AppState.shared.openContactWindow()
      },
      ContextMenuItem(
        title: "Delete"
      ) {_ in
        AppState.shared.quit()
      }
    ]
  }
}
