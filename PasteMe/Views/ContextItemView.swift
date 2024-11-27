//
//  ContextItemView.swift
//  PasteMe
//
//  Created by cswenshuo on 2024/11/26.
//  Copyright © 2024 p0deje. All rights reserved.
//

import SwiftUI

struct ContextItemView: View {
    @Environment(ModifierFlags.self) private var modifierFlags
    let menuItem: ContextMenuItem
    let historyItem: HistoryItemDecorator
    var body: some View {
        Button {
          menuItem.action(historyItem)
        } label: {
          if menuItem.title == "Preview" {
            Text(AppState.shared.history.showPreview ? "Hide preview" : "Preview")
          } else {
            Text(menuItem.title)
          }
        }
    }
}
