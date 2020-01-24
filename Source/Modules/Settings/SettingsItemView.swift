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

struct SettingsItemView_Previews: PreviewProvider {
  static var width: CGFloat = 360
  static var height: CGFloat = 50
  
  static var previews: some View {
    Group {
      SettingsItemView(icon: "security", title: "Security center")
        .previewLayout(.fixed(width: width, height: height))
      SettingsItemView(icon: "security", title: "Security center")
        .previewLayout(.fixed(width: width, height: height))
        .environment(\.colorScheme, .dark)
    }
  }
}
