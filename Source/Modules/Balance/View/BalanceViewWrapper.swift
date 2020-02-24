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
    
    func onSend() {
      parent.onSend()
    }
    
    func onTransactions() {
      parent.onTransactions()
    }
  }
  
  init(
    onWrap: @escaping () -> Void,
    onUnwrap: @escaping () -> Void,
    onSend: @escaping () -> Void,
    onReceive: @escaping (Coin) -> Void,
    onTransactions: @escaping () -> Void
  ) {
    self.onWrap = onWrap
    self.onUnwrap = onUnwrap
    self.onSend = onSend
    self.onReceive = onReceive
    self.onTransactions = onTransactions
  }
  
  private let onWrap: () -> Void
  private let onUnwrap: () -> Void
  private let onSend: () -> Void
  private let onReceive: (Coin) -> Void
  private let onTransactions: () -> Void
  
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
