import AppKit.NSRunningApplication
import Defaults
import KeyboardShortcuts
import Observation

@Observable
class Popup {
  let verticalPadding: CGFloat = 5

  var needsResize = false
  var height: CGFloat = 0
  var headerHeight: CGFloat = 0
  var pinnedItemsHeight: CGFloat = 0
  var footerHeight: CGFloat = 0

  init() {
    KeyboardShortcuts.onKeyUp(for: .popup) {
      self.toggle()
    }
  }

  func toggle(at popupPosition: PopupPosition = Defaults[.popupPosition]) {
      print("resize toggle height \(height)")
    AppState.shared.appDelegate?.panel.toggle(height: height, at: popupPosition)
  }

  func open(height: CGFloat, at popupPosition: PopupPosition = Defaults[.popupPosition]) {
    AppState.shared.appDelegate?.panel.open(height: height, at: popupPosition)
  }

  func close() {
    AppState.shared.appDelegate?.panel.close()
  }

  func resize(height: CGFloat) {
    //TODO: 高度总是少了一点，所以临时+10解决，原因不明。另外增加item后，第一次打开popup高度会跳动，待解决。
    self.height = height + headerHeight + pinnedItemsHeight + (verticalPadding * 2) + 10
    print("resize height: \(height), headerHeight: \(headerHeight), pinnedItemsHeight: \(pinnedItemsHeight), footer: \(footerHeight), vertical: \(verticalPadding), self.height: \(self.height)")
    print("resize from popup \(self.height)")
    AppState.shared.appDelegate?.panel.verticallyResize(to: self.height)
    needsResize = false
  }
}
