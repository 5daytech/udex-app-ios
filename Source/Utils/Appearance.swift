import UIKit

class Appearance {
  static func setupAppearance() {
    let theme = App.instance.themeManager.currentTheme
    
    UITableView.appearance().separatorColor = .clear
    UITableView.appearance().backgroundColor = theme.mainBackground
    UISwitch.appearance().onTintColor = theme.mainColor
    
    UITabBar.appearance().barStyle = theme.barStyle
    UITabBar.appearance().backgroundImage = theme.mainBackground.image()
  }
  
  
}
