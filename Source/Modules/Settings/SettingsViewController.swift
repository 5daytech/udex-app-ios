import UIKit
import SnapKit
import RxSwift

class SettingsViewController: UIViewController {
  struct SettingsItem {
    let icon: String
    let title: String
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return App.instance.themeManager.currentTheme.statusBarStyle
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
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
    tableView = UITableView()
    view.addSubview(tableView!)
    tableView?.snp.makeConstraints { (maker) in
      maker.bottom.top.leading.trailing.equalToSuperview()
    }
    tableView?.register(SettingsTVC.self, forCellReuseIdentifier: SettingsTVC.reuseID)
    tableView?.delegate = self
    tableView?.dataSource = self
    title = "Settings"
    
    
  }
  
  private func applyTheme(_ theme: Theme) {
    view.backgroundColor = theme.secondaryBackground
    tableView?.backgroundColor = theme.secondaryBackground
    print(theme)
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
