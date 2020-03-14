import UIKit
import SnapKit

class BalanceTVC: UITableViewCell {
  static let reuseID = "\(BalanceTVC.self)"
  static let height: CGFloat = 65
  static let expandedHeight: CGFloat = 135
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var pricePerToken: UILabel!
  @IBOutlet weak var amountInCoin: UILabel!
  @IBOutlet weak var amountInFiat: UILabel!
  
  private var buttonsStackView: UIStackView?
  private var wrapBtn: UIButton?
  private var receiveBtn: UIButton?
  private var sendBtn: UIButton?
  private var transactionsBtn: UIButton?
  private var onReceiveAction: ((Coin) -> Void)?
  private var onSendAction: ((Coin) -> Void)?
  private var onTransactionsAction: ((Coin) -> Void)?
  private var onWrapAction: (() -> Void)?
  private var item: BalanceViewItem?
  
  func onBind(_ item: BalanceViewItem, onReceive: @escaping (Coin) -> Void, onSend: @escaping (Coin) -> Void, onTransactions: @escaping (Coin) -> Void, onWrap: (() -> Void)?) {
    self.item = item
    onReceiveAction = onReceive
    onSendAction = onSend
    onTransactionsAction = onTransactions
    onWrapAction = onWrap
    icon.image = UIImage(named: item.balance.coin.code)
    title.text = item.balance.coin.title
    pricePerToken.text = "$\(item.balance.pricePerToken.toDisplayFormat()) per \(item.balance.coin.code)"
    amountInCoin.text = "\(item.balance.balance.toDisplayFormat()) \(item.balance.coin.code)"
    amountInFiat.text = "$\(item.balance.fiatBalance.toDisplayFormat(2))"
  }
  
  func setupCell() {
    if buttonsStackView == nil {
      buttonsStackView = setupButtonsStack()
    }
    
    if receiveBtn == nil {
      receiveBtn = setupReceiveButton()
      buttonsStackView?.addArrangedSubview(receiveBtn!)
    }

    if sendBtn == nil {
      sendBtn = setupSendButton()
      buttonsStackView?.addArrangedSubview(sendBtn!)
    }

    if transactionsBtn == nil {
      transactionsBtn = setupTransactionsButton()
      buttonsStackView?.addArrangedSubview(transactionsBtn!)
    }
    
    if item!.wrap != nil {
      if wrapBtn != nil {
        wrapBtn?.setTitle(item?.wrap, for: .normal)
        setupWrapIcon()
      } else {
        wrapBtn = setupWrapButton(item!.wrap!)
        buttonsStackView?.addArrangedSubview(wrapBtn!)
      }
    } else {
      wrapBtn?.removeFromSuperview()
      wrapBtn = nil
    }
  }
  
  private func setupButtonsStack() -> UIStackView {
    let stackView = UIStackView()
    stackView.distribution = .fill
    stackView.spacing = 40
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints { (maker) in
      maker.top.equalTo(pricePerToken.snp.bottom).offset(18)
      maker.centerX.equalToSuperview()
      maker.height.equalTo(40)
    }
    return stackView
  }
  
  private func setupWrapIcon() {
    guard let wrapBtn = wrapBtn else { return }
    let titleSize = wrapBtn.titleLabel!.intrinsicContentSize
    let imageSize = wrapBtn.imageView!.intrinsicContentSize
    wrapBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageSize.width + (titleSize.width - imageSize.width) / 2, bottom: 20, right: 0)
  }
  
  private func setupWrapButton(_ title: String) -> UIButton {
    return setupButton(title, "wrap", "T1", action: #selector(onWrap(_:)))
  }
  
  private func setupTransactionsButton() -> UIButton {
    return setupButton("Transactions", "transactions", "T1", action: #selector(onTransactions(_:)))
  }
  
  private func setupSendButton() -> UIButton {
    return setupButton("Send", "send", "T1", action: #selector(onSend(_:)))
  }
  
  private func setupReceiveButton() -> UIButton {
    return setupButton("Receive", "receive", "main", action: #selector(onReceive(_:)))
  }
  
  private func setupButton(_ title: String, _ image: String, _ color: String, action: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor(named: color), for: .normal)
    button.titleLabel?.font = UIFont(name: Constants.Fonts.bold, size: 10)  
    button.setImage(UIImage(named: image), for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
    button.tintColor = UIColor(named: color)
    let titleSize = button.titleLabel!.intrinsicContentSize
    let imageSize = button.imageView!.intrinsicContentSize
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageSize.width + (titleSize.width - imageSize.width) / 2, bottom: 20, right: 0)
    button.titleEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    return button
  }
  
  @objc func onReceive(_ sender: Any) {
    onReceiveAction?(item!.balance.coin)
  }
  
  @objc func onSend(_ sender: Any) {
    onSendAction?(item!.balance.coin)
  }
  
  @objc func onTransactions(_ sender: Any) {
    onTransactionsAction?(item!.balance.coin)
  }
  
  @objc func onWrap(_ sender: Any) {
    onWrapAction?()
  }
}
