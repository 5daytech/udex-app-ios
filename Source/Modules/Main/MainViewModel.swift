import Foundation
import RxSwift

class MainViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var isLoggedIn: Bool
  
  var ordersViewModel: OrdersViewModel?
  var restoreViewModel: RestoreViewModel?
  private let cleanupManager: ICleanupManager
  private let wordsManager: IWordsManager
  private let authManager: IAuthManager
  
  init(wordsManager: IWordsManager, authManager: IAuthManager, cleanupManager: ICleanupManager) {
    self.cleanupManager = cleanupManager
    self.wordsManager = wordsManager
    self.authManager = authManager
    isLoggedIn = authManager.isLoggedIn
    
    if authManager.isLoggedIn {
      try! authManager.safeLoad()
      self.ordersViewModel = OrdersViewModel(relayerAdapter: App.instance.relayerAdapterManager.mainRelayer!)
    }
    
    restoreViewModel = RestoreViewModel(wordsManager: wordsManager, authManager: authManager)
    restoreViewModel?.onAuth.subscribe(onNext: {
      self.ordersViewModel = OrdersViewModel(relayerAdapter: App.instance.relayerAdapterManager.mainRelayer!)
      self.isLoggedIn = true
    }).disposed(by: disposeBag)
  }
  
  func createWallet() {
    let words = try! wordsManager.generateWords()
    try! authManager.login(words: words)
    isLoggedIn = true
  }
  
  func logout() {
    cleanupManager.logout()
    isLoggedIn = false
  }
}
