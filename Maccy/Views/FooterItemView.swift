import SwiftUI

struct FooterItemView: View {
  @Bindable var item: FooterItem

  var body: some View {
    ConfirmationView(item: item) {
      HStack{
        Text(LocalizedStringKey(item.title))
        Spacer()
      }.padding().frame(width: 120, height: 30)
    }
  }
}
