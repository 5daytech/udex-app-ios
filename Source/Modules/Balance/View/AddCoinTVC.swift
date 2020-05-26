import UIKit
import RxSwift

class AddCoinTVC: UITableViewCell {
  private let disposeBag = DisposeBag()
  static let reuseID = "\(AddCoinTVC.self)"
  
  @IBOutlet weak var addCoinsBtn: UIButton!
  private var onAddCoinAction: (() -> Void)?
  
  func onBind(onAddCoin: @escaping () -> Void) {
    self.onAddCoinAction = onAddCoin
  }
  
  @IBAction func onAddCoin(_ sender: UIButton) {
    onAddCoinAction?()
  }
}
