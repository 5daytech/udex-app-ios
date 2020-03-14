import Foundation
import LocalAuthentication

protocol IBiometricManager {
  func validate(onValidate: @escaping () -> Void, onFailToValidate: @escaping () -> Void)
}

class BiometricManager {
  
}

extension BiometricManager: IBiometricManager {
  
  func validate(onValidate: @escaping () -> Void, onFailToValidate: @escaping () -> Void) {
    let localAuthenticationContext = LAContext()
    localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock wallet") { success, error in
      DispatchQueue.main.async {
        if success {
          onValidate()
        } else {
          onFailToValidate()
        }
      }
    }
  }
  
}
