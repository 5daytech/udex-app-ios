import Foundation
import RxSwift

protocol IAuthManager {
  var adapterManager: IAdapterManager? { get set }
  var relayerAdapterManager: IRelayerAdapterManager? { get set }
  var authData: AuthData? { get }
  var isLoggedIn: Bool { get }
  var authDataSubject: Observable<Void> { get }
  
  func safeLoad() throws
  func login(words: [String]) throws
  func logout() throws
}
