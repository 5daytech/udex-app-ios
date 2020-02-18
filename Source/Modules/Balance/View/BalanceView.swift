import SwiftUI

struct BalanceView: View {  
  @State public var showRefreshView: Bool = false
  @State public var pullStatus: CGFloat = 0
  
  var body: some View {
    VStack {
      BalanceViewWrapper()
    }
  }
}
