import Foundation
import RxSwift

class MainViewModel: ObservableObject {
  private let disposeBag = DisposeBag()
  @Published var isLoggedIn: Bool
  
  var ordersViewModel: OrdersViewModel?
  var restoreViewModel: RestoreViewModel?
  private let cleanupManager: ICleanupManager
  
  init(wordsManager: IWordsManager, authManager: IAuthManager, cleanupManager: ICleanupManager) {
    self.cleanupManager = cleanupManager
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
  
  func logout() {
    cleanupManager.logout()
    isLoggedIn = false
  }
}
