import UIKit
import RxSwift
import SwiftUI

enum Theme: Int {
  case light
  case dark
  case blue
  
  var mainColor: UIColor {
    switch self {
    case .blue:
      return UIColor().colorFromHexString("#3F40FF")
    case .dark:
      return UIColor().colorFromHexString("#FFD600")
    case .light:
      return UIColor().colorFromHexString("#304CFF")
    }
  }
  
  var mainTextColor: UIColor {
    switch self {
    case .light:
      return UIColor().colorFromHexString("#1E1E24")
    case .blue:
      return UIColor().colorFromHexString("#E1E9FF")
    case .dark:
      return UIColor().colorFromHexString("#FFFFFF")
    }
  }
  
  var secondaryTextColor: UIColor {
    switch self {
    case .dark:
      return UIColor().colorFromHexString("#595C66")
    case .blue:
      return UIColor().colorFromHexString("#7F8DAD")
    case .light:
      return UIColor().colorFromHexString("#B9BCC2")
    }
  }
  
  var mainBackground: UIColor {
    switch self {
    case .light:
      return UIColor().colorFromHexString("#FBFBFB")
    case .blue:
      return UIColor().colorFromHexString("#1F1F25")
    case .dark:
      return UIColor().colorFromHexString("#000000")
    }
  }
  
  var navigationItemTitleColor: UIColor {
    switch self {
    case .light:
      return UIColor().colorFromHexString("#1E1E24")
    case .blue:
      return UIColor().colorFromHexString("#FFFFFF")
    case .dark:
      return UIColor().colorFromHexString("#FFFFFF")
    }
  }
  
  var secondaryBackground: UIColor {
    switch self {
    case .dark:
      return UIColor().colorFromHexString("#0F1115")
    case .blue:
      return UIColor().colorFromHexString("#21222C")
    case .light:
      return UIColor().colorFromHexString("#FFFFFF")
    }
  }
  
  var barStyle: UIBarStyle {
    switch self {
    case .blue, .dark:
      return .default
    case .light:
      return .black
    }
  }
  
  var statusBarStyle: UIStatusBarStyle {
    switch self {
    case .blue, .dark:
      return .lightContent
    case .light:
      return .darkContent
    }
  }
  
  var arrowIcon: UIColor {
    switch self {
    case .light:
      return UIColor().colorFromHexString("#D8DCE3")
    case .blue, .dark:
      return UIColor().colorFromHexString("#4B4E56")
    }
  }
  
  var navigationBarLine: UIColor {
    switch self {
    case .dark:
      return UIColor().colorFromHexString("#202020")
    case .blue:
      return UIColor().colorFromHexString("#30313B")
    case .light:
      return UIColor().colorFromHexString("#EBECED")
    }
  }
}

class ThemeManager: ObservableObject {
  private let THEME_KEY = "theme_key"
  
  var currentThemeSubject: BehaviorSubject<Theme>
  
  @Published var currentTheme: Theme
  
  init() {
    var theme = Theme.light
    if let storedTheme = UserDefaults.standard.value(forKey: THEME_KEY) as? Int {
      theme = Theme(rawValue: storedTheme)!
    }
    currentTheme = theme
    currentThemeSubject = BehaviorSubject(value: theme)
    applyTheme(theme)
  }
  
  func applyTheme(_ theme: Theme) {
    UserDefaults.standard.set(theme.rawValue, forKey: THEME_KEY)
    currentTheme = theme
    currentThemeSubject.onNext(theme)
  }
  
  func nextTheme() {
    switch currentTheme {
    case .blue:
      applyTheme(.dark)
    case .dark:
      applyTheme(.light)
    case .light:
      applyTheme(.blue)
    }
  }
}
