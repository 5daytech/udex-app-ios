import UIKit

class AddCoinTVC: UITableViewCell {
  static let reuseID = "\(AddCoinTVC.self)"
  
  private var onAddCoinAction: (() -> Void)?
  
  func onBind(onAddCoin: @escaping () -> Void) {
    self.onAddCoinAction = onAddCoin
  }
  
  @IBAction func onAddCoin(_ sender: UIButton) {
    onAddCoinAction?()
  }
}
