import SwiftUI

struct SettingsItemView: View {
  var icon: String
  var title: String
  var titleColor = Color("T1")
  
  var body: some View {
    HStack {
      Image(icon)
        .padding(.leading, 20)
        .frame(width: 18, height: 18)
      Text(title)
        .padding(.leading, 16)
        .foregroundColor(titleColor)
      Spacer()
    }
  .frame(height: 50)
  .background(Color("secondary_background"))
  }
}
