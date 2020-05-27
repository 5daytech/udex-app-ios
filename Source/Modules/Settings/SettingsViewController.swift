import UIKit
import SnapKit
import RxSwift

class SettingsViewController: UIViewController {
  struct SettingsItem {
    let id: Int
    let icon: String
    let title: String
    let additional: String?
    
    init(id: Int, icon: String, title: String, additional: String? = nil) {
      self.id = id
      self.icon = icon
      self.title = title
      self.additional = additional
    }
  }
  
  private let disposeBag = DisposeBag()
  var tableView: UITableView?
  
  let options: [[SettingsItem]] = [
    [
      SettingsItem(id: 0, icon: "security", title: "Security Center"),
      SettingsItem(id: 1, icon: "security", title: "Security Center")
    ],
    [
      SettingsItem(id: 2, icon: "sun", title: "Color Mode", additional: "color_switch")
    ],
    [
      SettingsItem(id: 3, icon: "security", title: "Security Center"),
      SettingsItem(id: 4, icon: "security", title: "Security Center"),
      SettingsItem(id: 5, icon: "share", title: "Tell Friends")
    ],
    [
      SettingsItem(id: 6, icon: "security", title: "Security Center"),
      SettingsItem(id: 7, icon: "security", title: "Security Center"),
      SettingsItem(id: 8, icon: "security", title: "Security Center")
    ]
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupTableView()
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    navigationItem.title = "Settings"
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
    case 2:
      App.instance.themeManager.nextTheme()
    case 5:
      share()
    default:
      break
    }
  }
  
  private func share() {
    let items = [URL(string: "https://udex.app/share")!]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    present(ac, animated: true)
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
  static func instanceInNavigationController() -> UINavigationController {
    let controller = SettingsViewController()
    let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings"), selectedImage: nil)
    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    controller.tabBarItem = tabBarItem
    let navigation = StatusBarNavigationController(rootViewController: controller)
    return navigation
  }
}
