import SwiftUI

struct CoinManagerView: View {
  @ObservedObject var viewModel = CoinManagerViewModel()
  
  @State var isEditMode: EditMode = .active
  
  @State var isEnabled = false
  
  var isEnabledBindable: Binding<Bool> { Binding(
    get: { true }, set: {_ in}) }
  
  var body: some View {
    VStack {
      List {
        ForEach(viewModel.enabledCoins, id: \.code) { coin in
          CoinManagerRow(isEnabled: Binding(
            get: {
              print("asd")
              return self.viewModel.isEnabled(coin)
              
          },
            set: {_ in}), coin: coin)
            .listRowInsets(EdgeInsets())
            .onTapGesture {
              self.viewModel.onTapCoin(coin)
            }
        }
        .onMove { (indexSet, index) in
          self.viewModel.move(indexSet, index)
        }
        Spacer(minLength: 6)
        ForEach(viewModel.disabledCoins, id: \.code) { coin in
          CoinManagerRow(isEnabled: Binding(
          get: { self.viewModel.isEnabled(coin) },
          set: {_ in})
            , coin: coin)
            .listRowInsets(EdgeInsets())
            .onTapGesture {
              self.viewModel.onTapCoin(coin)
            }
        }
      }
      .environment(\.editMode, $isEditMode)
    }
    .navigationBarTitle("Coin Manager")
  }
}
