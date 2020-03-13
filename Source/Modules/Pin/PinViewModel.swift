import SwiftUI

class PinViewModel: ObservableObject {
  
  @Published var numbers: [String?]
  
  var firstPin: String?
  
  var oldPinConfirmed: Bool?
  
  private let pinManager: IPinManager
  
  @Published var title: String?
  
  init(_ isForEdit: Bool) {
    numbers = [String?](repeating: nil, count: 6)
    pinManager = App.instance.pinManager
    oldPinConfirmed = false
  }
  
  init() {
    numbers = [String?](repeating: nil, count: 6)
    pinManager = App.instance.pinManager
    oldPinConfirmed = nil
  }
  
  func inputNumber(_ number: String, _ onValidate: (() -> Void)?, onSuccessPasscode: @escaping () -> Void, onFail: @escaping () -> Void) {
    if number == "d" {
      if let index = numbers.firstIndex(of: nil) {
        if index != 0 {
          numbers[index - 1] = nil
        }
      } else {
        numbers[numbers.count - 1] = nil
      }
      return
    }
    
    if let index = numbers.firstIndex(of: nil) {
      numbers[index] = number
      if index == numbers.count - 1 {
        checkPin(onValidate, onSuccessPasscode, onFail)
      }
    } else {
      checkPin(onValidate, onSuccessPasscode, onFail)
    }
  }
  
  func checkPin(_ onValidate: (() -> Void)?, _ onSuccessPasscode: @escaping () -> Void, _ onFail: @escaping () -> Void) {
    let pin: String = numbers.reduce("") { (res, str) -> String in
      "\(res)\(str ?? "")"
    }
    
    if oldPinConfirmed != nil {
      if oldPinConfirmed! {
        if firstPin == nil {
          firstPin = pin
          numbers = [String?](repeating: nil, count: 6)
          title = "Repeat passcode"
        } else {
          if firstPin == pin {
            pinManager.store(pin: pin)
            onSuccessPasscode()
          } else {
            onFail()
            numbers = [String?](repeating: nil, count: 6)
            title = "Enter new passcode"
            firstPin = nil
          }
        }
      } else {
        if pinManager.validate(pin: pin) {
          numbers = [String?](repeating: nil, count: 6)
          title = "Enter new passcode"
          oldPinConfirmed = true
        } else {
          numbers = [String?](repeating: nil, count: 6)
          onFail()
        }
      }
    } else {
      if onValidate != nil {
        if pinManager.validate(pin: pin) {
          onValidate?()
          onSuccessPasscode()
        } else {
          numbers = [String?](repeating: nil, count: 6)
          onFail()
        }
      } else {
        if firstPin == nil {
          firstPin = pin
          numbers = [String?](repeating: nil, count: 6)
          title = "Repeat passcode"
        } else {
          if firstPin == pin {
            pinManager.store(pin: pin)
            onSuccessPasscode()
          } else {
            onFail()
            numbers = [String?](repeating: nil, count: 6)
            title = "Enter new passcode"
            firstPin = nil
          }
        }
      }
    }
  }
}
