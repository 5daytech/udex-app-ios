import UIKit
import SnapKit
import RxSwift

class SettingsTVC: UITableViewCell {
  private var disposeBag = DisposeBag()
  static let reuseID = "\(SettingsTVC.self)"
  var titleLabel: UILabel!
  var iconView: UIImageView!
  var arrowView: UIImageView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addIconView()
    addTitleLabel()
  }
  
  private func addTitleLabel() {
    titleLabel = UILabel()
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints({ (maker) in
      maker.bottom.top.trailing.equalToSuperview()
      maker.leading.equalTo(iconView.snp.trailing).offset(8)
    })
  }
  
  private func addIconView() {
    iconView = UIImageView()
    addSubview(iconView)
    iconView.snp.makeConstraints({ (maker) in
      maker.leading.equalToSuperview().offset(8)
      maker.centerY.equalToSuperview()
      maker.height.equalTo(20)
      maker.width.equalTo(16)
    })
  }
  
  private func applyTheme(_ theme: Theme) {
    iconView.tintColor = theme.mainColor
    titleLabel.textColor = theme.mainTextColor
    backgroundColor = theme.secondaryBackground
  }
  
  public func onBind(_ item: SettingsViewController.SettingsItem) {
    iconView.image = UIImage(named: item.icon)
    titleLabel.text = item.title
  }
}
