import SwiftUI

@Observable
class ContextMenuItem: Identifiable {

  let id = UUID()

  var title: String
  var shortcuts: [KeyShortcut] = []
  var action: (HistoryItemDecorator) -> Void

  init(
    title: String,
    shortcuts: [KeyShortcut] = [],
    action: @escaping (HistoryItemDecorator) -> Void
  ) {
    self.title = title
    self.shortcuts = shortcuts
    self.action = action
  }
}
