import SwiftUI

struct CoinManagerView: View {
  @ObservedObject var viewModel = CoinManagerViewModel()
  
  @State var isEditMode: EditMode = .active
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    ZStack(alignment: .bottom) {
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
      Button(action: {
        self.viewModel.saveCoins()
        self.presentationMode.wrappedValue.dismiss()
      }) {
        Image("done").renderingMode(.original)
      }
    }
    .navigationBarTitle("Coin Manager")
  }
}
