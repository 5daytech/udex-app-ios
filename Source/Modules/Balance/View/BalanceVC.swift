import UIKit
import SnapKit
import RxSwift

protocol BalanceVCDelegate {
  func onWrap()
  func onUnwrap()
  func onReceive(_ coin: Coin)
  func onSend(_ coin: Coin)
  func onTransactions(_ coin: Coin)
}

class BalanceVC: UIViewController {
  
  private let disposeBag = DisposeBag()
  private var tableView: UITableView!
  
  private let viewModel = BalanceViewModel()
  
  private var items = [BalanceViewItem]()
  
  private var totalFiatLabel: UILabel?
  private var totalLabel: UILabel?
  
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
    tableView.estimatedRowHeight = 70
    tableView.register(UINib(nibName: BalanceTVC.reuseID, bundle: nil), forCellReuseIdentifier: BalanceTVC.reuseID)
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
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return items[indexPath.row].expanded ? BalanceTVC.expandedHeight : BalanceTVC.height
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    (cell as? BalanceTVC)?.setupCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor(named: "background")
    
    totalFiatLabel = UILabel()
    totalFiatLabel?.text = viewModel.totalBalance.fiatBalanceStr
    totalFiatLabel?.textColor = UIColor(named: "T1")
    totalFiatLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    view.addSubview(totalFiatLabel!)
    totalFiatLabel?.snp.makeConstraints({ (maker) in
      maker.leading.top.equalToSuperview().offset(16)
    })
    
    totalLabel = UILabel()
    totalLabel?.text = viewModel.totalBalance.balanceStr
    totalLabel?.textColor = UIColor(named: "T2")
    totalLabel?.font = UIFont.systemFont(ofSize: 20)
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
