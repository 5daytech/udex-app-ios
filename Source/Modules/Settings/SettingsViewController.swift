import UIKit
import SnapKit
import RxSwift

class SettingsViewController: UIViewController {
  struct SettingsItem {
    let icon: String
    let title: String
  }
  
  private let disposeBag = DisposeBag()
  var tableView: UITableView?
  
  let options: [SettingsItem] = [
    SettingsItem(icon: "security", title: "Security Center"),
    SettingsItem(icon: "security", title: "Security Center"),
    SettingsItem(icon: "security", title: "Security Center"),
    SettingsItem(icon: "security", title: "Security Center"),
    SettingsItem(icon: "security", title: "Security Center"),
    SettingsItem(icon: "security", title: "Security Center")
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
  }
  
  private func applyTheme(_ theme: Theme) {
    view.backgroundColor = theme.mainBackground
    tableView?.backgroundColor = theme.mainBackground

    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = theme.mainBackground
    appearance.titleTextAttributes = [.foregroundColor: theme.navigationItemTitleColor]
    appearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationItemTitleColor]
    appearance.shadowImage = UIColor().colorFromHexString("#EDEEEF").image()
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
  }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.reuseID) as? SettingsTVC else {
      fatalError()
    }
    cell.onBind(options[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
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
