import SwiftUI
import RxSwift

struct SettingsItemView: View {
  private let disposeBag = DisposeBag()
  var icon: String
  var title: String
  var titleColor = Color("T1")
  
  @ObservedObject private var themeManager = App.instance.themeManager
  
  var body: some View {
    HStack {
      Image(icon)
        .padding(.leading, 20)
        .frame(width: 18, height: 18)
      Text(title)
        .padding(.leading, 16)
        .foregroundColor(Color(themeManager.currentTheme.mainTextColor))
        .font(.custom(Constants.Fonts.regular, size: 14))
      Spacer()
    }
    .frame(height: 50)
    .background(Color(themeManager.currentTheme.secondaryBackground))
  }
}
