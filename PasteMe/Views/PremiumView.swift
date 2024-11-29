//
//  PremiumView.swift
//  PasteMe
//
//  Created by cswenshuo on 2024/10/27.
//  Copyright © 2024 p0deje. All rights reserved.
//

import SwiftUI

struct PremiumView: View {
    @ObservedObject var store = Store.shared
    var termsOfUse = "https://dazzling-list-03d.notion.site/TERMS-OF-SERVICE-c6336e4c5a7a480dbecb3adfd2620cf1?pvs=4"
    var privacyPolicy = "https://dazzling-list-03d.notion.site/PRIVACY-POLICY-8a976966bc51449cbf2f3268f97a48bd?pvs=4"
    @State var restoreText = NSLocalizedString("Restore",comment: "")

    var body: some View {
        VStack(alignment: .center, spacing: 5){
            if store.recipe?.isLocked == false {
                Image("PremiumIcon").resizable().frame(width: 100, height: 100).padding(.top, 20)
                Text("PasteMe Pro").font(Font.title)
                VStack(alignment: .leading, spacing: 5){
                    Text("Use shortcuts to paste near the cursor instantly")
                    Text("View different content in different styles")
                    Text("Pin important information")
                    Text("Easily find what you copied by searching")
                }.padding(.vertical, 20)
                Text("You are using Eye Monitor Pro now.").font(.system(.headline))
            }else{
                Image("PremiumIcon").resizable().frame(width: 150, height: 140).padding().padding(.top, 40)
                Text("PasteMe Pro").font(.system(size: 22, design: .serif)).bold()
                Text("Become Pro user to use without limitation.").padding(.vertical, 20)
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text("Use shortcuts to paste near the cursor instantly").fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text("✔️")
                    }
                    HStack(alignment: .top){
                        Text("View different content in different styles").fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text("✔️")
                    }
                    HStack(alignment: .top){
                        Text("Pin important information").fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text("✔️")
                    }
                    HStack(alignment: .top){
                        Text("Easily find what you copied by searching").fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Text("✔️")
                    }
                    HStack{
                        Text("Support future development")
                        Spacer()
                        Text("❤️")
                    }
                }.padding(.vertical, 25).padding(.horizontal, 32)
                if let price = store.recipe?.price{
                    HStack(spacing:0){
                        Text("Only")
                            Text(" \(price) ")
                        Text("for life time")
                    }.font(Font.headline)
                }else{
                    HStack(spacing:0){
                        Text("Only")
                        Text("--").font(Font.headline)
                        Text("for life time")
                    }
                    Text("No commitment. Cancel any time.")
                }
                VStack(spacing: 7){
                  Text("Continue").padding(.horizontal, 7).padding(.vertical, 11).frame(width: 300).background(Color(NSColor(named: "Premium")!)).foregroundColor(.white).cornerRadius(7)
                        .onTapGesture {
                        store.purchaseProduct()
                    }
                  Text("Skip and use the free version for 12 hours").multilineTextAlignment(.center).padding(.horizontal, 7).padding(.vertical, 11).frame(width: 300).background(
                        RoundedRectangle(cornerRadius: 7)
                          .stroke(Color(NSColor(named: "Premium")!), lineWidth: 2)
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                      RateSubscribeHelper.shared.closePremiumWindow()
                    }
                    Text(restoreText).font(.subheadline).opacity(0.7).onTapGesture {
                        restoreText = NSLocalizedString("Connecting...", comment: "")
                        store.restoreProduct{
                            //TODO: 恢复成功提醒
                            restoreText = NSLocalizedString("Restore", comment: "")
                        } restoreFailedHandler: {
                            restoreText = NSLocalizedString("Restore failed. Try again later.", comment: "")
                            print("restore failed")
                        }
                    }
                }
                
                Spacer()
                HStack{
                    Text("Terms of Use").opacity(0.7).font(.system(.footnote)).onTapGesture {
                        if let url = URL(string: termsOfUse) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    Spacer()
                    Text("Privacy Policy").opacity(0.7).font(.system(.footnote)).onTapGesture {
                        if let url = URL(string: privacyPolicy) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                }.padding().padding(.horizontal, 40)
            }
        }.frame(width: 450, height: 700).background(Color(NSColor.windowBackgroundColor)).environment(\.colorScheme, .light)
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}
