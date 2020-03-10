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
        Section {
          ForEach(viewModel.enabledViewItems) { coinViewItem in
            CoinManagerRow(viewItem: coinViewItem)
              .listRowInsets(EdgeInsets())
              .onTapGesture {
                self.viewModel.onTapCoin(coinViewItem.coin)
              }
          }
          .onMove { (indexSet, index) in
            self.viewModel.move(indexSet, index)
          }
        }
        Spacer(minLength: 6)
        Section {
          ForEach(viewModel.disabledViewItems) { coinViewItem in
            CoinManagerRow(viewItem: coinViewItem)
              .listRowInsets(EdgeInsets())
              .onTapGesture {
                self.viewModel.onTapCoin(coinViewItem.coin)
              }
          }
        }
        

        
      }
      .environment(\.editMode, $isEditMode)
    }
    .navigationBarTitle("Coin Manager")
  }
}
