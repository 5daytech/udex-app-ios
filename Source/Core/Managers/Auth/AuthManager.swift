import Foundation
import RxSwift

class AuthManager: IAuthManager {  
  var adapterManager: IAdapterManager?
  
  var relayerAdapterManager: IRelayerAdapterManager?
  
  var authData: AuthData? {
    securedStorage.authData
  }
  
  var isLoggedIn: Bool {
    !securedStorage.noAuthData()
  }
  
  var authDataSubject: Observable<Void> {
    return subject.asObservable()
  }
  
  private let subject = PublishSubject<Void>()
  private let securedStorage: ISecuredStorage
  private let coinManager: ICoinManager
  
  init(securedStorage: ISecuredStorage, coinManager: ICoinManager) {
    self.coinManager = coinManager
    self.securedStorage = securedStorage
  }
  
  func safeLoad() throws {
    if authData != nil {
      subject.onNext(())
    }
  }
  
  func login(words: [String]) throws {
    let authData = AuthData(words: words)
    securedStorage.saveAuthData(authData: authData)
    coinManager.enableDefaultCoins()
    subject.onNext(())
  }
  
  func logout() throws {
    coinManager.clear()
    adapterManager?.stopKits()
    relayerAdapterManager?.clearRelayers()
    
    try EthereumAdapter.clear(except: [])
    try Erc20Adapter.clear(except: [])
    
    securedStorage.removeAuthData()
  }
}
