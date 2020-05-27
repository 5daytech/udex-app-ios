import UIKit
import SnapKit
import RxSwift

class SettingsTVC: UITableViewCell {
  private var disposeBag = DisposeBag()
  static let reuseID = "\(SettingsTVC.self)"
  var titleLabel: UILabel!
  var iconView: UIImageView!
  var arrowView: UIImageView?
  var additionalText: UILabel?
  
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
    setupSelectedColors()
  }
  
  private func setupSelectedColors() {
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor().colorFromHexString("#DDDDDD").withAlphaComponent(0.5)
  }
  
  private func addTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = UIFont(name: Constants.Fonts.text_regular, size: 14)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints({ (maker) in
      maker.bottom.top.trailing.equalToSuperview()
      maker.leading.equalTo(iconView.snp.trailing).offset(21)
    })
  }
  
  private func addIconView() {
    iconView = UIImageView()
    iconView.contentMode = .scaleAspectFit
    addSubview(iconView)
    iconView.snp.makeConstraints({ (maker) in
      maker.leading.equalToSuperview().offset(16)
      maker.centerY.equalToSuperview()
      maker.height.equalTo(18)
      maker.width.equalTo(18)
    })
  }
  
  private func addArrowIcon() {
    arrowView = UIImageView()
    arrowView?.contentMode = .scaleAspectFit
    arrowView?.tintColor = App.instance.themeManager.currentTheme.arrowIcon
    arrowView?.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
    addSubview(arrowView!)
    arrowView?.snp.makeConstraints { (maker) in
      maker.width.height.equalTo(20)
      maker.trailing.equalToSuperview().offset(-16)
      maker.centerY.equalToSuperview()
    }
  }
  
  private func addAdditionIcon(_ icon: String) {
    let addIcon = UIImageView()
    addIcon.contentMode = .scaleAspectFit
    addIcon.image = UIImage(named: icon)
    addSubview(addIcon)
    addIcon.snp.makeConstraints { (maker) in
      maker.width.equalTo(62)
      maker.height.equalTo(14)
      maker.trailing.equalToSuperview().offset(-16)
      maker.centerY.equalToSuperview()
    }
  }
  
  private func addAdditionText(_ text: String) {
    additionalText = UILabel()
    additionalText?.textColor = App.instance.themeManager.currentTheme.socialsUsername
    additionalText?.font = UIFont(name: Constants.Fonts.text_light, size: 12)
    addSubview(additionalText!)
    additionalText?.snp.makeConstraints({ (maker) in
      maker.trailing.equalToSuperview().offset(-16)
      maker.centerY.equalToSuperview()
    })
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.12
    additionalText?.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
  }
  
  private func addAdditionSwitch(_ isOn: Bool) {
    let switchControl = UISwitch()
    switchControl.isOn = isOn
    switchControl.onTintColor = App.instance.themeManager.currentTheme.mainColor
    switchControl.addTarget(self, action: #selector(onToggle), for: .valueChanged)
    addSubview(switchControl)
    switchControl.snp.makeConstraints { (maker) in
      maker.trailing.equalToSuperview().offset(-16)
      maker.centerY.equalToSuperview()
    }
    selectionStyle = .none
  }
  
  private func onRemove() {
    iconView.tintColor = App.instance.themeManager.currentTheme.removeWallet
    titleLabel.textColor = App.instance.themeManager.currentTheme.removeWallet
    arrowView?.tintColor = App.instance.themeManager.currentTheme.removeWallet
  }
  
  private func applyTheme(_ theme: Theme) {
    iconView.tintColor = theme.mainColor
    titleLabel.textColor = theme.mainTextColor
    arrowView?.tintColor = theme.arrowIcon
    additionalText?.textColor = theme.socialsUsername
    backgroundColor = theme.secondaryBackground
  }
  
  public func onBind(_ item: SettingsViewController.SettingsItem) {
    if item.template {
      iconView.image = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)
    } else {
      iconView.image = UIImage(named: item.icon)
    }
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 0.96
    titleLabel.attributedText = NSMutableAttributedString(string: item.title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    switch item.additional {
    case .icon(let icon):
      addAdditionIcon(icon)
    case .text(let text):
      addAdditionText(text)
    case .switchControl(let isOn):
      addAdditionSwitch(isOn)
    case .remove:
      addArrowIcon()
      onRemove()
    case .none:
      addArrowIcon()
    }
  }
  
  @objc private func onToggle() {
    print("TEST TEST TEST")
  }
}
