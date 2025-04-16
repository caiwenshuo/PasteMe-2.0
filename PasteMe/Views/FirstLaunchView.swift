//
//  FirstLaunchView.swift
//  PasteMe
//
//  Created by cswenshuo on 2025/4/16.
//  Copyright © 2025 p0deje. All rights reserved.
//

import SwiftUI
import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import Settings

struct FirstLaunchView: View {
    @State var state : viewState = .first
    var restTresholdDefaultText = "45"
    var restIntervalDefaultText = "10"
    var notificationDefaultText = "10"
    let appDelegate = NSApplication.shared.delegate as? AppDelegate
    let opacity = 0.8
    let textWidth = 450 as CGFloat
    let heightOfText = 45 as CGFloat
    let widthOfWindow = 550 as CGFloat
    let heightOfWindow = 700 as CGFloat
    @Default(.windowPosition) private var windowPosition
    @Default(.popupPosition) private var popupAt
    @Default(.popupScreen) private var popupScreen
    @State private var screens = NSScreen.screens
    @Default(.size) private var size
    private let sizeFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.minimum = 1
      formatter.maximum = 999
      return formatter
    }()
    var body: some View {
        Group{
            switch state {
            case .first:
                VStack(spacing: 10){
                    Spacer()
                    Image("PremiumIcon").resizable().scaledToFit().frame(width: 200, height: 200, alignment: .center)
                    VStack(spacing: 7) {
                        Text("An Easy Way to Copy and Paste").font(.title).bold()
                        Text("PasteMe keeps a history of everything you copy, so you can quickly find and reuse it at any time.").multilineTextAlignment(.center).frame(width: textWidth, height: heightOfText, alignment: .top).opacity(opacity)
                    }
                    Text("Get Start").foregroundColor(Color.white).font(.headline).padding(.horizontal, 50).padding(.vertical, 10).background(Color(NSColor.controlAccentColor)).cornerRadius(10.0).onTapGesture {
                        self.state = .second
                    }
                    Spacer()
                }.padding().frame(width: widthOfWindow, height: heightOfWindow)
            case .second:
                VStack(spacing: 10){
                    Spacer()
                    Image("PremiumIcon").resizable().scaledToFit().frame(width: 100, height: 100, alignment: .center)
                    VStack(spacing: 7) {
                        Text("Quick Start").font(.title).bold()
                        Text("Set up and strat using PasteMe.").multilineTextAlignment(.center).frame(width: textWidth, height: heightOfText, alignment: .top).opacity(opacity)
                    }
                    VStack(spacing: 12) {
                        LaunchAtLogin.Toggle {
                            Text("LaunchAtLogin", tableName: "GeneralSettings").frame(maxWidth: .infinity, alignment: .leading)
                        }.toggleStyle(SwitchToggleStyle())
                        
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Activation shortcut", tableName: "GeneralSettings")
                                Text("Instantly access PasteMe in any app").foregroundStyle(Color(NSColor.secondaryLabelColor))
                            }
                            Spacer()
                            KeyboardShortcuts.Recorder(for: .popup)
                                .help(Text("OpenTooltip", tableName: "GeneralSettings"))
                        }
                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Clipboard history", tableName: "StorageSettings")
                                Text("Maximum number of copied items to keep").foregroundStyle(Color(NSColor.secondaryLabelColor))
                            }
                            Spacer()
                            TextField("", value: $size, formatter: sizeFormatter)
                                  .frame(width: 130, height: 10)
                                  .textFieldStyle(.roundedBorder)
                              .multilineTextAlignment(.center)
                              .help(Text("SizeTooltip", tableName: "StorageSettings"))
                        }
                        
                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Popup Position", tableName: "AppearanceSettings")
                                Text("Position where PasteMe appears").foregroundStyle(Color(NSColor.secondaryLabelColor))
                            }
                            Spacer()
                            Picker("", selection: $popupAt) {
                              ForEach(PopupPosition.allCases) { position in
                                if position == .center {
                                  if screens.count > 1 {
                                    Picker(position.description, selection: $popupScreen) {
                                      Text("ActiveScreen", tableName: "AppearanceSettings")
                                        .tag(0)

                                      ForEach(Array(screens.enumerated()), id: \.element) { index, screen in
                                        Text(screen.localizedName)
                                          .tag(index + 1)
                                      }
                                    }
                                    .onChange(of: popupScreen) {
                                      popupAt = position
                                    }
                                  } else {
                                    Text(position.description)
                                  }
                                } else {
                                  Text(position.description)
                                }
                              }
                            }
                            .labelsHidden()
                            .frame(width: 130)
                            .help(Text("PopupAtTooltip", tableName: "AppearanceSettings"))
                        }.onReceive(NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)) { _ in
                            screens = NSScreen.screens
                          }
                    }.padding(20).frame(width: 450).background(Color(NSColor.quaternaryLabelColor)).cornerRadius(20).padding(.bottom, 10)
                    Text("Continue").foregroundColor(Color.white).font(.headline).padding(.horizontal, 50).padding(.vertical, 10).background(Color(NSColor.controlAccentColor)).cornerRadius(10.0).onTapGesture {
                        self.state = .finished
                    }
                    Spacer()
                }.padding().frame(width: widthOfWindow, height: heightOfWindow)
            case .configue:
                VStack(spacing: 30){
                    Image("newUserSetting").resizable().scaledToFit().frame(width: 300, height: 300, alignment: .center).padding(.top, 40)
                    Text("You can customize the fatigue settings, reminder style, notification interval, etc., later in the Settings.").multilineTextAlignment(.center).frame(width: textWidth, height: heightOfText, alignment: .top).opacity(opacity)
                    Text("Start").foregroundColor(Color.white).font(.headline).padding(.horizontal, 50).padding(.vertical, 10).background(Color(NSColor.controlAccentColor)).cornerRadius(10.0).onTapGesture {
                        UserDefaults.standard.setValue(false, forKey: "isNewUser")
                        self.state = .finished
                    }
                    Spacer()
                }.padding().frame(width: widthOfWindow, height: heightOfWindow)
            case .finished:
                PremiumView().onAppear{
                    print("appear ")
                    Defaults[.isFirtLaunch] = false
                }
            }
        }.background(Color(NSColor.windowBackgroundColor))
    }
}

enum viewState {
    case first
    case second
    case configue
    case finished
}

#Preview {
    FirstLaunchView()
}
