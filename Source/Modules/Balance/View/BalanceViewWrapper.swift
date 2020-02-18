import SwiftUI

struct BalanceViewWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<BalanceViewWrapper>) -> BalanceVC {    
    let balanceVC = BalanceVC()
    return balanceVC
  }
  
  func updateUIViewController(_ uiViewController: BalanceVC, context: UIViewControllerRepresentableContext<BalanceViewWrapper>) {
    
  }
}
