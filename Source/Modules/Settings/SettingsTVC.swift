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
    addArrowIcon()
    setupSelectedColors()
  }
  
  private func setupSelectedColors() {
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor().colorFromHexString("#DDDDDD")
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
    arrowView.contentMode = .scaleAspectFit
    arrowView.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
    addSubview(arrowView)
    arrowView.snp.makeConstraints { (maker) in
      maker.width.height.equalTo(20)
      maker.trailing.equalToSuperview().offset(-16)
      maker.centerY.equalToSuperview()
    }
  }
  
  private func addAdditionIcon(_ icon: String) {
    arrowView.snp.updateConstraints { (maker) in
      maker.width.equalTo(62)
      maker.height.equalTo(14)
    }
    arrowView.image = UIImage(named: icon)
  }
  
  private func applyTheme(_ theme: Theme) {
    iconView.tintColor = theme.mainColor
    titleLabel.textColor = theme.mainTextColor
    arrowView.tintColor = theme.arrowIcon
    backgroundColor = theme.secondaryBackground
  }
  
  public func onBind(_ item: SettingsViewController.SettingsItem) {
    iconView.image = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 0.96
    titleLabel.attributedText = NSMutableAttributedString(string: item.title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    if let additional = item.additional {
      addAdditionIcon(additional)
    }
  }
}
