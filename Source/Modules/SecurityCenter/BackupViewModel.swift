import Foundation
import UIKit

class BackupViewModel: ObservableObject {
  
  @Published var words: [String] = []
  
  private let authManager = App.instance.authManager
  
  init() {
    words = authManager.authData?.words ?? []
  }
  
  func onCopyClick() {
    UIPasteboard.general.string = words.joined(separator: " ")
  }
}
