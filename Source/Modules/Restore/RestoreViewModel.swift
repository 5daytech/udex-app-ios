import Foundation
import RxSwift

class RestoreViewModel {
  private let wordsManager: IWordsManager
  private let authManager: IAuthManager
  let onAuth = PublishSubject<Void>()
  
  init(wordsManager: IWordsManager, authManager: IAuthManager) {
    self.wordsManager = wordsManager
    self.authManager = authManager
  }
  
  func onRestore(text: String) {
    let words = text.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    
    do {
      try wordsManager.validate(words: words)
      try authManager.login(words: words)
      onAuth.onNext(())
    } catch {
      //TODO: Show error "Invalid mnemonic"
    }
  }
}
