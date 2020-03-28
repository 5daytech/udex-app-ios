import UIKit
import RxSwift

class AddCoinTVC: UITableViewCell {
  private let disposeBag = DisposeBag()
  static let reuseID = "\(AddCoinTVC.self)"
  
  @IBOutlet weak var addCoinsBtn: UIButton!
  private var onAddCoinAction: (() -> Void)?
  
  func onBind(onAddCoin: @escaping () -> Void) {
    self.onAddCoinAction = onAddCoin
    applyTheme(App.instance.themeManager.currentTheme)
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.applyTheme(theme)
    }).disposed(by: disposeBag)
  }
  
  private func applyTheme(_ theme: Theme) {
    backgroundColor = theme.mainBackground
    addCoinsBtn.tintColor = theme.mainColor
    addCoinsBtn.titleLabel?.textColor = theme.mainColor
  }
  
  @IBAction func onAddCoin(_ sender: UIButton) {
    onAddCoinAction?()
  }
}
