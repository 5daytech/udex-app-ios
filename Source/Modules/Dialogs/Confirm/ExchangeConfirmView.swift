import SwiftUI

struct ExchangeConfirmView: View {
  
  @ObservedObject var viewModel: ExchangeConfirmViewModel
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        // Head
        HStack {
          Text("Trade")
          .foregroundColor(Color("T1"))
          .font(.system(size: 18, weight: .bold))
          Spacer()
          HStack(spacing: 10) {
            Image(self.viewModel.info.sendCoin)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            Image("exchange")
              .renderingMode(.template)
              .foregroundColor(Color("main"))
            Image(self.viewModel.info.receiveCoin)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
          }
          Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
        
        HStack(spacing: 0) {
          VStack(alignment: .leading) {
            Text("Sell \(self.viewModel.info.sendCoin)")
              .foregroundColor(Color.red)
              .font(.system(size: 14))
              .padding(.leading, 16)
            Text(self.viewModel.sellAmount)
              .foregroundColor(Color("T1"))
              .font(.system(size: 18, weight: .bold))
              .padding(.leading, 16)
          }
          .frame(width: (geometry.size.width - 40) / 2, height: 50, alignment: .leading)
          .background(Color("confirm_sell_back"))
          
          VStack(alignment: .trailing) {
            Text("Buy \(self.viewModel.info.receiveCoin)")
            .foregroundColor(Color.green)
            .font(.system(size: 14))
            .padding(.trailing, 16)
            Text(self.viewModel.buyAmount)
            .foregroundColor(Color("T1"))
            .font(.system(size: 18, weight: .bold))
            .padding(.trailing, 16)
          }
          .frame(width: (geometry.size.width - 40) / 2, height: 50, alignment: .trailing)
          .background(Color("confirm_buy_back"))
        }
        
        VStack {
          HStack {
            Text("Price Per Token:")
            .font(.system(size: 16))
            .foregroundColor(Color("T3"))
            Spacer()
            Text(self.viewModel.priceAmount)
          }
          Rectangle()
          .frame(height: 1)
          .background(Color("confirm_separator"))
          
          if (self.viewModel.feeAmount != nil) {
            HStack {
              Text("Estimated Fee:")
              .font(.system(size: 16))
              .foregroundColor(Color("T3"))
              Spacer()
              Text(self.viewModel.feeAmount ?? "")
            }
            Rectangle()
            .frame(height: 1)
            .background(Color("confirm_separator"))
          }
          
          HStack {
            Text("Processing Time:")
            .font(.system(size: 16))
            .foregroundColor(Color("T3"))
            Spacer()
            Text(self.viewModel.processingTime)
          }
        }
        .padding([.leading, .trailing, .bottom], 16)
        
        if self.viewModel.info.showLifeTimeInfo {
        
          VStack(alignment: .center) {
            Text("Order will be live next 24 hours.")
              .font(.system(size: 14))
              .foregroundColor(Color("main"))
              .padding([.bottom], 16)
          }
        }
        
        Button(action: {
          self.viewModel.onConfirm()
        }) {
          Spacer()
          Text("CONFIRM")
          Spacer()
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(Color("main"))
        .foregroundColor(Color("background"))
      }
      .frame(width: geometry.size.width - 40)
      .background(Color("secondary_background"))
      .clipped()
      .shadow(radius: 5)
    }
  }
}

struct ExchangeConfirmView_Previews: PreviewProvider {
  static var previews: some View {
    ExchangeConfirmView(
      viewModel: ExchangeConfirmViewModel(
        info: ExchangeConfirmInfo(
          sendCoin: "WETH",
          receiveCoin: "ZRX",
          sendAmount: 0.7,
          receiveAmount: 450,
          fee: 0.0064,
          showLifeTimeInfo: true,
          onConfirm: {}
        )
      )
    )
  }
}
