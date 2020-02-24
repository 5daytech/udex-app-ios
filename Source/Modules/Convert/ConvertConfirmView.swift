import SwiftUI

struct ConvertConfirmView: View {
  var config: ConvertConfirmConfig
  var onConfirm: () -> Void
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text(config.type == .WRAP ? "Wrap" : "Unwrap")
        Spacer()
        Image(config.type == .WRAP ? "ETH" : "WETH")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        Image("wrap_right")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        Image(config.type == .WRAP ? "WETH" : "ETH")
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
      }
      Text(config.value.toDisplayFormat())
      +
      Text(config.type == .WRAP ? "ETH" : "WETH")
      .foregroundColor(Color("main"))
      
      Text("to")
      .foregroundColor(Color("T2"))
      
      Text(config.value.toDisplayFormat())
      +
      Text(config.type == .WRAP ? "WETH" : "ETH")
      .foregroundColor(Color("main"))
      
      HStack {
        Text("Estimated Fee:")
        .foregroundColor(Color("T2"))
        Spacer()
        Text("~\(config.estimatedFee.toDisplayFormat()) ETH")
      }
      HStack {
        Text("Processing Time:")
        .foregroundColor(Color("T2"))
        Spacer()
        Text("~\(config.processingTime) s")
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
    .background(Color("secondary_background"))
  }
}
