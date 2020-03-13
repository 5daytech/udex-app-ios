import SwiftUI

struct SettingsItemToggleView: View {
  var icon: String
  var title: String
  @Binding var isToggleOn: Bool
  
  var body: some View {
    HStack {
      Image(icon)
        .padding(.leading, 20)
        .frame(width: 18, height: 18)
      Text(title)
        .padding(.leading, 16)
        .foregroundColor(Color("T1"))
      Spacer()
      Toggle(isOn: $isToggleOn) {
        Text("")
      }
      .padding(.trailing, 8)
    }
    .frame(height: 50)
    .background(Color("secondary_background"))
  }
}
