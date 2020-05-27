import UIKit
import SnapKit
import RxSwift

class SettingsViewController: UIViewController {
  enum EMode {
    case main
    case security
  }
  
  struct SettingsItem {
    enum EAdditional {
      case icon(String)
      case text(String)
      case switchControl(Bool)
      case remove
      case none
    }
    
    static let SECURITY_CENTER = 0
    static let COIN_MANAGER = 1
    static let THEME = 2
    static let HOW_IT_WORKS = 3
    static let ABOUT_UDEX = 4
    static let TELL_FRIENDS = 5
    static let TWITTER = 6
    static let TELEGRAM = 7
    static let TELEGRAM_BOT = 8
    static let FRIDAY_TECH = 9
    static let REMOVE_WALLET = 10
    static let WALLET_BACKUP = 11
    static let PASSCODE = 12
    static let EDIT_PASSCODE = 13
    static let BIOMETRIC = 14
    
    let id: Int
    let icon: String
    let template: Bool
    let title: String
    let additional: EAdditional
    
    init(id: Int, icon: String, title: String, additional: EAdditional = .none, template: Bool = true) {
      self.id = id
      self.icon = icon
      self.title = title
      self.template = template
      self.additional = additional
    }
  }
  
  private let mode: EMode
  private let disposeBag = DisposeBag()
  private var tableView: UITableView?
  
  private let options: [[SettingsItem]]
  private let securityOptions: [[SettingsItem]] = [
    [
      SettingsItem(id: SettingsItem.WALLET_BACKUP, icon: "backup", title: "Wallet Backup"),
      SettingsItem(id: SettingsItem.PASSCODE, icon: "passcode", title: "Passcode Enabled", additional: .switchControl(true)),
      SettingsItem(id: SettingsItem.EDIT_PASSCODE, icon: "edit_passcode", title: "Edit Passcode"),
      SettingsItem(id: SettingsItem.BIOMETRIC, icon: "fingerprint", title: "Biometric", additional: .switchControl(true))
    ],
    [
      SettingsItem(id: SettingsItem.REMOVE_WALLET, icon: "trash", title: "Remove Wallet", additional: .remove)
    ]
  ]
  private let mainOptions: [[SettingsItem]] = [
    [
      SettingsItem(id: SettingsItem.SECURITY_CENTER, icon: "security", title: "Security Center"),
      SettingsItem(id: SettingsItem.COIN_MANAGER, icon: "coin_manager", title: "Coin Manager")
    ],
    [
      SettingsItem(id: SettingsItem.THEME, icon: "sun", title: "Color Mode", additional: .icon("color_switch"))
    ],
    [
      SettingsItem(id: SettingsItem.HOW_IT_WORKS, icon: "question", title: "How It Works?"),
      SettingsItem(id: SettingsItem.ABOUT_UDEX, icon: "about", title: "About App"),
      SettingsItem(id: SettingsItem.TELL_FRIENDS, icon: "share", title: "Tell Friends")
    ],
    [
      SettingsItem(id: SettingsItem.TWITTER, icon: "twitter", title: "Twitter", additional: .text("@udexapp"), template: false),
      SettingsItem(id: SettingsItem.TELEGRAM, icon: "telegram", title: "Telegram", additional: .text("@t.me/udexapp"), template: false),
      SettingsItem(id: SettingsItem.TELEGRAM_BOT, icon: "telegram_bot", title: "Telegram Bot", additional: .text("@udex_bot"), template: false)
    ]
  ]
  
  init(mode: EMode) {
    self.mode = mode
    switch mode {
    case .main:
      options = mainOptions
    case .security:
      options = securityOptions
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupTableView()
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    switch mode {
    case .main:
      navigationItem.title = "Settings"
    case .security:
      navigationItem.title = "Security Center"
    }
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupTableView() {
    tableView = UITableView()
    view.addSubview(tableView!)
    tableView?.snp.makeConstraints { (maker) in
      maker.bottom.top.leading.trailing.equalToSuperview()
    }
    tableView?.register(SettingsTVC.self, forCellReuseIdentifier: SettingsTVC.reuseID)
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.separatorInset = UIEdgeInsets.zero
  }
  
  private func applyTheme(_ theme: Theme) {
    view.backgroundColor = theme.mainBackground
    tableView?.backgroundColor = theme.mainBackground
    tableView?.separatorColor = theme.mainBackground

    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = theme.mainBackground
    appearance.titleTextAttributes = [.foregroundColor: theme.navigationItemTitleColor]
    appearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationItemTitleColor]
    appearance.shadowImage = theme.navigationBarLine.image()
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
  }
  
  private func didSelectItem(_ item: SettingsItem) {
    switch item.id {
    case SettingsItem.THEME:
      App.instance.themeManager.nextTheme()
    case SettingsItem.TELL_FRIENDS:
      share()
    case SettingsItem.TWITTER:
      openTwitter()
    case SettingsItem.TELEGRAM:
      openTelegram()
    case SettingsItem.TELEGRAM_BOT:
      openTelegramBot()
    case SettingsItem.SECURITY_CENTER:
      openSecurity()
    case SettingsItem.COIN_MANAGER:
      break
    case SettingsItem.ABOUT_UDEX:
      break
    case SettingsItem.HOW_IT_WORKS:
      break
    case SettingsItem.FRIDAY_TECH:
      break
    case SettingsItem.PASSCODE:
      break
    case SettingsItem.BIOMETRIC:
      break
    case SettingsItem.REMOVE_WALLET:
      break
    case SettingsItem.EDIT_PASSCODE:
      break
    case SettingsItem.WALLET_BACKUP:
      break
    default:
      fatalError()
    }
  }
  
  private func share() {
    let items = [URL(string: "https://udex.app/share")!]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    present(ac, animated: true)
  }
  
  private func openTwitter() {
    let appUrl = URL(string: "twitter://status?id=udexapp")!
    let webUrl = URL(string: "https://twitter.com/udexapp")!
    openUrl(appUrl, webUrl)
  }
  
  private func openTelegram() {
    let appUrl = URL(string: "tg://resolve?domain=udexapp")!
    let webUrl = URL(string: "https://t.me/udexapp")!
    openUrl(appUrl, webUrl)
  }
  
  private func openTelegramBot() {
    let appUrl = URL(string: "tg://resolve?domain=udex_bot")!
    let webUrl = URL(string: "https://t.me/udex_bot")!
    openUrl(appUrl, webUrl)
  }
  
  private func openUrl(_ app: URL, _ web: URL) {
    if UIApplication.shared.canOpenURL(app) {
      UIApplication.shared.open(app, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.open(web, options: [:], completionHandler: nil)
    }
  }
  
  private func openSecurity() {
    show(SettingsViewController.instance(mode: .security), sender: self)
  }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return options.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.reuseID) as? SettingsTVC else {
      fatalError()
    }
    cell.onBind(options[indexPath.section][indexPath.item])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 20
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = options[indexPath.section][indexPath.item]
    didSelectItem(item)
  }
}

extension SettingsViewController {
  static func instance(mode: EMode) -> SettingsViewController {
    return SettingsViewController(mode: mode)
  }
  
  static func instanceInNavigationController() -> UINavigationController {
    let controller = SettingsViewController(mode: .main)
    let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings"), selectedImage: nil)
    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    controller.tabBarItem = tabBarItem
    let navigation = StatusBarNavigationController(rootViewController: controller)
    return navigation
  }
}
