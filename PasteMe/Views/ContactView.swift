import SwiftUI

struct ContactView: View {
    var body: some View {
      VStack(alignment: .center, spacing: 10){
            Image("Avatar").resizable().frame(width: 70, height: 70).cornerRadius(100)
            Text("Mason Cai").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
            Text("Mail: cswenshuo@gmail.com")
            HStack(spacing: 0){
                Text("Twitter: ")
                Link(destination: URL(string: "https://x.com/masoncaiws")!){
                    Text("masoncaiws").foregroundStyle(Color(NSColor.linkColor))
                }
            }

            if Locale.current.identifier == "zh_CN"{
                VStack{
                    Text("WeChat:")
                    Image("WeChat").resizable().frame(width: 100, height: 100)
                }
            }
          Text("Feel free to contact me if you have any suggestions or feedback🙏").multilineTextAlignment(.center).padding(.vertical)
        }.textSelection(.enabled)
        .font(.system(.headline,design: .serif)).padding(30).frame(width: 500, height: 400, alignment: .center)
    }
}

#Preview {
    ContactView()
}
