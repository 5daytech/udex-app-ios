import Foundation
import HSHDWalletKit

class WordsManager: IWordsManager {
  func validate(words: [String]) throws {
    try Mnemonic.validate(words: words)
  }
}
