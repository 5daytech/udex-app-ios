import Foundation

class PinManager {
  private let securedStorage: ISecuredStorage
  
  init(securedStorage: ISecuredStorage) {
    self.securedStorage = securedStorage
  }
}

extension PinManager: IPinManager {
  var isPinSet: Bool {
    !securedStorage.pinIsEmpty()
  }
  
  func store(pin: String) {
    securedStorage.savePin(pin: pin)
  }
  
  func validate(pin: String) -> Bool {
    securedStorage.savedPin == pin
  }
  
  func clear() {
    securedStorage.removePin()
  }
}
