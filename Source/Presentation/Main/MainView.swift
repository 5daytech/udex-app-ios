//
//  MainView.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/19/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        NavigationView {
          OrdersList(viewModel: OrdersViewModel(relayerManager: App.instance.zrxkit.relayerManager))
          .navigationBarTitle(Text("Order book"))
        }
        .tabItem({
          Text("Order book")
        })
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
