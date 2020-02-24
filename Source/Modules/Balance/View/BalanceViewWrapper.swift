import SwiftUI

struct BalanceViewWrapper: UIViewControllerRepresentable {
  
  class Coordinator: BalanceVCDelegate {
    let parent: BalanceViewWrapper
    
    init(_ parent: BalanceViewWrapper) {
      self.parent = parent
    }
    
    func onWrap() {
      parent.onWrap()
    }
    
    func onUnwrap() {
      parent.onUnwrap()
    }
    
    func onReceive(_ coin: Coin) {
      parent.onReceive(coin)
    }
    
    func onSend(_ coin: Coin) {
      parent.onSend(coin)
    }
    
    func onTransactions() {
      parent.onTransactions()
    }
  }
  
  let onWrap: () -> Void
  let onUnwrap: () -> Void
  let onSend: (Coin) -> Void
  let onReceive: (Coin) -> Void
  let onTransactions: () -> Void
  
  func makeCoordinator() -> BalanceViewWrapper.Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<BalanceViewWrapper>) -> BalanceVC {    
    let balanceVC = BalanceVC()
    balanceVC.delegate = context.coordinator
    return balanceVC
  }
  
  func updateUIViewController(_ uiViewController: BalanceVC, context: UIViewControllerRepresentableContext<BalanceViewWrapper>) {
    
  }
}
