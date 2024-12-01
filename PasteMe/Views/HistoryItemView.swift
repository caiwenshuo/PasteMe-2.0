import Defaults
import SwiftUI

struct HistoryItemView: View {
  @Bindable var item: HistoryItemDecorator
  @FocusState.Binding var searchFocused: Bool

  @Environment(AppState.self) private var appState
  @State var rightMouseDownLocation: NSPoint = .zero

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
//    .onAppear(perform: {
//      NSEvent.addLocalMonitorForEvents(matching: [.rightMouseDown]) {
//        rightMouseDownLocation = $0.locationInWindow
//        let loc = NSEvent.mouseLocation
//        print("loc", loc.x, loc.y) // 窗口左下角为原点
//
//        print("relative", rightMouseDownLocation.x, rightMouseDownLocation.y) // 窗口左下角为原点
//        if let window = NSApp.windows.first(where: { $0.isKeyWindow }) {
//                  // 将相对位置转化为屏幕绝对位置
//                  let rect = NSRect(origin: rightMouseDownLocation, size: .zero) // 将 NSPoint 转为 NSRect
//                  let absolutePosition = window.convertToScreen(rect).origin
//          print("Absolute position:", absolutePosition.x, absolutePosition.y) // 屏幕左下角为原点
//          let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: CGPoint(x: loc.x, y: loc.y), mouseButton: .left) // 屏幕左上角为原点
//          moveEvent?.post(tap: .cgSessionEventTap);
//                }
//
//        return $0
//      }
//    })
    .contextMenu(menuItems: {
      ForEach(appState.contextMenu.items){ menuItem in
        ContextItemView(menuItem: menuItem, historyItem: item)
      }
    })
  }
}
