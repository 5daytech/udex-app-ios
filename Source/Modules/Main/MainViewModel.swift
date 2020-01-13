import Foundation

class MainViewModel: ObservableObject {
  
  @Published var isWordsSaved: Bool
  
  init() {
    if let words = UserDefaults.standard.string(forKey: "words") {
      isWordsSaved = true
      App.reinit(words: words.split(separator: " ").map(String.init))
    } else {
      isWordsSaved = false
    }
  }
  
  func inputWords(words: String) {
    let separated = words.split(separator: " ").map(String.init)
    if separated.count == 12 {
      UserDefaults.standard.set(words, forKey: "words")
      App.reinit(words: separated)
      isWordsSaved = true
    }
  }
  
  func logout() {
    UserDefaults.standard.removeObject(forKey: "words")
    isWordsSaved = false
  }
}
