import Foundation
import RxSwift

class MainViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var isLoggedIn: Bool
  @Published var isPinEnabled: Bool
  
  var ordersViewModel: OrdersViewModel?
  var restoreViewModel: RestoreViewModel?
  private let cleanupManager: ICleanupManager
  private let wordsManager: IWordsManager
  private let authManager: IAuthManager
  private let lockManager: ILockManager
  
  init(
    wordsManager: IWordsManager,
    authManager: IAuthManager,
    cleanupManager: ICleanupManager,
    lockManager: ILockManager
  ) {
    self.cleanupManager = cleanupManager
    self.wordsManager = wordsManager
    self.authManager = authManager
    self.lockManager = lockManager
    isLoggedIn = authManager.isLoggedIn
    isPinEnabled = lockManager.isLocked
    if authManager.isLoggedIn {
      try! authManager.safeLoad()
      self.ordersViewModel = OrdersViewModel(relayerAdapter: App.instance.relayerAdapterManager.mainRelayer!)
    }
    
    lockManager.lockStateUpdatedSignal.subscribe(onNext: {
      self.isPinEnabled = self.lockManager.isLocked 
    }).disposed(by: disposeBag)
    
    restoreViewModel = RestoreViewModel(wordsManager: wordsManager, authManager: authManager)
    restoreViewModel?.onAuth.subscribe(onNext: {
      self.ordersViewModel = OrdersViewModel(relayerAdapter: App.instance.relayerAdapterManager.mainRelayer!)
      self.isLoggedIn = true
    }).disposed(by: disposeBag)
    
    App.instance.securityCenterViewModel.logoutSubject.subscribe(onNext: {
      self.isLoggedIn = false
    }).disposed(by: disposeBag)
  }
  
  func createWallet() {
    let words = try! wordsManager.generateWords()
    try! authManager.login(words: words)
    ordersViewModel = OrdersViewModel(relayerAdapter: App.instance.relayerAdapterManager.mainRelayer!)
    isLoggedIn = true
  }
  
  func height(for bottomState: MainView.BottomViewsState) -> CGFloat {
    switch bottomState {
    case .NONE:
      return 0
    case .RECEIVE:
      return 400
    case .UNWRAP, .WRAP, .SEND:
      return UIScreen.main.bounds.height - 100
    }
  }
  
  func send(
    _ config: SendConfirmConfig,
    onTransaction: @escaping (String) -> Void,
    onError: @escaping (String) -> Void
  ) {
    let adapter = App.instance.adapterManager.sendAdapter(for: config.coin)!
    adapter.send(amount: config.sendAmount, address: config.receiveAddress, feePriority: .MEDIUM).observeOn(MainScheduler.instance).subscribe(onSuccess: { (txHash) in
      onTransaction(txHash!)
    }, onError: { err in
      onError(err.localizedDescription)
    }).disposed(by: disposeBag)
  }
  
  func convert(
    _ config: ConvertConfirmConfig,
    onTransaction: @escaping (String) -> Void,
    onError: @escaping (String) -> Void
  ) {
    let wethWrapper = App.instance.zrxKitManager.zrxKit().getWethWrapperInstance()
    switch config.type {
    case .WRAP:
      wethWrapper.deposit(config.value.toEth(), onReceipt: { (ethTransactionReceipt) in
        
      }, onDeposit: { eventResponse in
        
      }).observeOn(MainScheduler.instance).subscribe(onNext: { (ethData) in
        onTransaction(ethData.hex())
      }, onError: { err in
        onError("Something went wrong")
      }).disposed(by: disposeBag)
    case .UNWRAP:
      wethWrapper.withdraw(config.value.toEth(), onReceipt: { (ethTransactionReceipt) in
        
      }, onWithdrawal: { eventResponse in
        
      }).observeOn(MainScheduler.instance).subscribe(onNext: { (ethData) in
        onTransaction(ethData.hex())
      }, onError: { err in
        onError("Something went wrong")
      }).disposed(by: disposeBag)
    case .NONE:
      fatalError()
    }
  }
  
  func onValidate() {
    lockManager.onUnlock()
    isPinEnabled = false
  }
}
