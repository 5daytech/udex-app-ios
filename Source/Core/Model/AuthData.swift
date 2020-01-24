import Foundation
import HSHDWalletKit

class AuthData {
  let words: [String]
  let walletId: String
  let seed: Data
  let privateKey: Data
  
  private let version: Int
  private let partsSeparator: Character = "|"
  private let wordsSeparator: Character = " "
  
  init(words: [String], walletId: String = UUID().uuidString) {
    self.words = words
    self.walletId = walletId
    
    seed = Mnemonic.seed(mnemonic: words)
    let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: 0, xPubKey: 0)
    privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
    
    version = 1
  }
  
  init(serialized: String) {
    if serialized.contains(partsSeparator) {
      let separated = serialized.split(separator: partsSeparator).map(String.init)
      version = Int(separated[0], radix: 10)!
      words = separated[1].split(separator: wordsSeparator).map(String.init)
      walletId = separated[2]
      print(separated[3].hexToBytes())
      seed = Data(hex: separated[3])
    } else {
      version = 1
      let wordsAndWalletId = serialized.split(separator: wordsSeparator).map(String.init)
      words = Array(wordsAndWalletId[0...11])
      if wordsAndWalletId.count >= 13 {
        walletId = wordsAndWalletId[12]
      } else {
        walletId = ""
      }
      seed = Mnemonic.seed(mnemonic: words)
    }
    let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: 0, xPubKey: 0)
    privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external).raw
  }
}

extension AuthData: CustomStringConvertible {
  var description: String {
    print("\(seed.makeBytes())")
    return ["\(version)", words.joined(separator: String(wordsSeparator)), walletId, seed.toRawHexString()].joined(separator: String(partsSeparator))
  }
}
