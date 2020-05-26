import UIKit
import SwiftUI
import RxSwift

class MainTabBarController: UITabBarController {
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
    applyTheme(App.instance.themeManager.currentTheme)
  }
  
  private func applyTheme(_ theme: Theme) {
    tabBar.backgroundImage = theme.secondaryBackground.image()
    tabBar.tintColor = theme.mainColor
  }
  
  private func setupViewControllers() {
    viewControllers = [SettingsViewController.instanceInNavigationController()]
  }
}
