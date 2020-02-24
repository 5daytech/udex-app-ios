import SwiftUI

struct SendConfirmView: View {
  var config: SendConfirmConfig
  var onConfirm: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Confirm")
      
      HStack {
        Spacer()
        VStack(alignment: .center, spacing: 10) {
          Text("\(config.sendAmount.toDisplayFormat()) \(config.coin.code)")
          Text("$\(config.sendAmountInFiat.toDisplayFormat(2))")
          Text("#\(config.receiveAddress)")
        }
        Spacer()
      }
      
      HStack {
        Text("Estimated Fee:")
          .foregroundColor(Color("T2"))
        Spacer()
        Text("~\(config.estimatedFee.toDisplayFormat()) ETH")
      }
      
      Rectangle()
        .background(Color("confirm_separator"))
        .frame(height: 1)
      
      HStack {
        Text("Processing Time:")
          .foregroundColor(Color("T2"))
        Spacer()
        Text("~\(config.processingTime) s")
      }
      
      Rectangle()
        .background(Color("confirm_separator"))
        .frame(height: 1)
      
      HStack {
        Text("Total:")
          .foregroundColor(Color("T3"))
        Spacer()
        Text("$\(config.totalFiat.toDisplayFormat(2))")
      }
      
      Button(action: {
        self.onConfirm()
      }) {
        Spacer()
        Text("CONFIRM")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
      .cornerRadius(5)
    }
  .padding(16)
    .background(Color("secondary_background"))
  }
}
