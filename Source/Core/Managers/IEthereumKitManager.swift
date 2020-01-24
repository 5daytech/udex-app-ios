import Foundation
import EthereumKit

protocol IEthereumKitManager {
  func ethereumKit(authData: AuthData) throws -> EthereumKit.Kit
  func refresh()
  func unlink()
}
