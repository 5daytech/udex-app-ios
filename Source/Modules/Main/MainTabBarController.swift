import UIKit
import SwiftUI
import RxSwift

class MainTabBarController: UITabBarController {
  let disposeBag = DisposeBag()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return App.instance.themeManager.currentTheme.statusBarStyle
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
    applyTheme(App.instance.themeManager.currentTheme)
    
    let balanceVC = BalanceVC()
    balanceVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "balance"), selectedImage: nil)
    
    let settings = settingsView()
    viewControllers = [balanceVC, settings]
  }
  
  private func applyTheme(_ theme: Theme) {
    tabBar.backgroundImage = theme.mainBackground.image()
    tabBar.tintColor = theme.mainColor
  }
  
  private func settingsView() -> UIViewController {
    let settingsView = SettingsView()
    let newSet = settingsView.background(Color.red)
    
    let controller = SettingsViewController()
//    controller.view.backgroundColor = App.instance.themeManager.currentTheme.secondaryBackground
    
    controller.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings"), selectedImage: nil)
    
    let navigation = UINavigationController(rootViewController: controller)
    navigation.navigationBar.prefersLargeTitles = true
    navigation.isNavigationBarHidden = false
    return navigation
  }
}
