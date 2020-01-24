import Foundation

protocol IWordsManager {
  func generateWords() throws -> [String]
  func validate(words: [String]) throws
}
