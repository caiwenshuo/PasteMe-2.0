//
//  LikeOrNoteView.swift
//  DesktopNote
//
//  Created by cswenshuo on 2023/10/22.
//  Copyright © 2023 cswenshuo. All rights reserved.
//

import SwiftUI
import Defaults

struct ReviewView: View {
    var body: some View {
        VStack{
            Text("Enjoying PasteMe?").font(.system(size: 22, design: .serif)).bold().padding(.bottom, 20).multilineTextAlignment(.center)
            Text("Your App Store review will help more people know PasteMe").font(.system(size: 13, design: .serif)).multilineTextAlignment(.center).padding(.bottom, 30)
            Image("RateUsIll").resizable().frame(width: 150, height: 140)
            Spacer()
            Text("Rate us").padding(7).frame(width: 260, height: 40).background(Color.black).foregroundColor(.white).cornerRadius(7)
                .onTapGesture {
                guard let writeReviewURL = URL(string: "macappstore://apps.apple.com/app/id6664068453?action=write-review")
                else { fatalError("Expected a valid URL") }
                NSWorkspace.shared.open(writeReviewURL)
                RateSubscribeHelper.shared.hasRate()
            }
            Text("Already rated").padding(7).frame(width: 260, height: 40).foregroundColor(.black).cornerRadius(7)
                .onTapGesture {
                Defaults[.hasRate] = true
                RateSubscribeHelper.shared.closeReviewWindow()
            }
        }.padding(.vertical, 50).padding(.horizontal, 30).frame(width: 350, height: 500).background(Color("RateUs")).environment(\.colorScheme, .light)
    }
}

#Preview {
  ReviewView()
}
