import UIKit
import SnapKit
import RxSwift

protocol BalanceVCDelegate {
  func onWrap()
  func onUnwrap()
  func onReceive(_ coin: Coin)
  func onSend(_ coin: Coin)
  func onTransactions(_ coin: Coin)
  func onOpenCoinManager()
}

class BalanceVC: UIViewController {
  
  private let disposeBag = DisposeBag()
  private var tableView: UITableView!
  
  private let viewModel = BalanceViewModel()
  
  private var items = [BalanceViewItem]()
  
  private var totalFiatLabel: UILabel?
  private var totalLabel: UILabel?
  private var titleLabel: UILabel?
  
  var delegate: BalanceVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    viewModel.refresh()
    viewModel.balancesSubject.asObservable().subscribe(onNext: {
      self.refresh()
    }).disposed(by: disposeBag)
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 65
    tableView.register(UINib(nibName: BalanceTVC.reuseID, bundle: nil), forCellReuseIdentifier: BalanceTVC.reuseID)
    tableView.register(UINib(nibName: AddCoinTVC.reuseID, bundle: nil), forCellReuseIdentifier: AddCoinTVC.reuseID)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
    }
  }
  
  private func refresh() {
    totalFiatLabel?.text = viewModel.totalBalance.fiatBalanceStr
    totalLabel?.text = viewModel.totalBalance.balanceStr
    var newCoins = [BalanceViewItem]()
    viewModel.balances.enumerated().forEach { index, balance in
      let filtered = items.filter { $0.balance == balance }.first
      var wrap: String? = nil
      if filtered?.balance.coin.code == "ETH" {
        wrap = "Wrap"
      } else if filtered?.balance.coin.code == "WETH" {
        wrap = "Unwrap"
      }
      newCoins.append(BalanceViewItem(balance: balance, expanded: filtered?.expanded ?? false, wrap: filtered?.wrap ?? wrap))
    }
    items = newCoins
    self.tableView.reloadData()
  }
}

extension BalanceVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == items.count {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCoinTVC.reuseID) as? AddCoinTVC else {
        fatalError()
      }
      cell.onBind {
        self.delegate?.onOpenCoinManager()
      }
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BalanceTVC.reuseID) as? BalanceTVC else {
        fatalError()
      }
      let item = items[indexPath.row]
      var wrap: (() -> Void)? = nil
      
      if item.balance.coin.code == "ETH" {
        wrap = {
          self.delegate?.onWrap()
        }
      } else if item.balance.coin.code == "WETH" {
        wrap = {
          self.delegate?.onUnwrap()
        }
      }
      
      cell.onBind(
        items[indexPath.row],
        onReceive: { coin in
          self.delegate?.onReceive(coin)
        }, onSend: { coin in
          self.delegate?.onSend(coin)
        }, onTransactions: { coin in
          self.delegate?.onTransactions(coin)
        }, onWrap: wrap
      )
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == items.count { return 50 }
    return items[indexPath.row].expanded ? BalanceTVC.expandedHeight : BalanceTVC.height
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    (cell as? BalanceTVC)?.setupCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor(named: "background")
    
    titleLabel = UILabel()
    titleLabel?.text = "Wallet"
    titleLabel?.textColor = UIColor(named: "T1")
    titleLabel?.font = UIFont(name: Constants.Fonts.bold, size: 24)
    view.addSubview(titleLabel!)
    titleLabel?.snp.makeConstraints({ (maker) in
      maker.top.leading.equalToSuperview().offset(16)
    })
    
    totalFiatLabel = UILabel()
    totalFiatLabel?.text = viewModel.totalBalance.fiatBalanceStr
    totalFiatLabel?.textColor = UIColor(named: "T1")
    totalFiatLabel?.font = UIFont(name: Constants.Fonts.bold, size: 30)
    view.addSubview(totalFiatLabel!)
    totalFiatLabel?.snp.makeConstraints({ (maker) in
      maker.leading.equalToSuperview().offset(16)
      maker.top.equalTo(titleLabel!.snp.bottom).offset(8)
    })
    
    totalLabel = UILabel()
    totalLabel?.text = viewModel.totalBalance.balanceStr
    totalLabel?.textColor = UIColor(named: "T2")
    totalLabel?.font = UIFont(name: Constants.Fonts.regular, size: 18)
    view.addSubview(totalLabel!)
    totalLabel?.snp.makeConstraints({ (maker) in
      maker.top.equalTo(totalFiatLabel!.snp.bottom).offset(4)
      maker.leading.equalToSuperview().offset(16)
      maker.bottom.equalToSuperview().offset(-16)
    })
    
    return view
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if indexPath.row == items.count {
      delegate?.onOpenCoinManager()
      return
    }
    let expandedCoin = items.enumerated().filter { $1.expanded }.first?.offset
    var reloadRows = [indexPath]
    if expandedCoin == indexPath.row {
      items[indexPath.row].expanded = !items[indexPath.row].expanded
    } else {
      items[indexPath.row].expanded = true
      if expandedCoin != nil {
        reloadRows.append(IndexPath(row: expandedCoin!, section: 0))
        items[expandedCoin!].expanded = false
      }
    }
    tableView.reloadRows(at: reloadRows, with: .automatic)
  }
}
