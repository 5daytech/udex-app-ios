import Foundation
import zrxkit
import EthereumKit
import RxSwift

class RelayerAdapterManager: IRelayerAdapterManager {
  let disposeBag = DisposeBag()
  var mainRelayer: IRelayerAdapter?
  let coinManager: ICoinManager
  let ethereumKitManager: IEthereumKitManager
  let appConfiguration: IAppConfigProvider
  let authManager: IAuthManager
  let zrxKitManager: IZrxKitManager
  let ratesConverter: RatesConverter
  
  var mainRelayerUpdatedSignal: Observable<Void> {
    subject.asObservable()
  }
  
  private let subject = PublishSubject<Void>()
  
  init(
    zrxKitManager: IZrxKitManager,
    ethereumKitManager: IEthereumKitManager,
    coinManager: ICoinManager,
    ratesConverter: RatesConverter,
    appConfiguration: IAppConfigProvider,
    authManager: IAuthManager
  ) {
    self.coinManager = coinManager
    self.zrxKitManager = zrxKitManager
    self.ethereumKitManager = ethereumKitManager
    self.ratesConverter = ratesConverter
    self.appConfiguration = appConfiguration
    self.authManager = authManager
    
    authManager.authDataSubject.subscribe(onNext: {
      self.initRelayer()
    }).disposed(by: disposeBag)
  }
  
  private func initRelayer() {
    if let data = authManager.authData {
      let ethereumKit = try! ethereumKitManager.ethereumKit(authData: data)
      let zrxKit = zrxKitManager.zrxKit()
      let allowanceChecker = AllowanceChecker(zrxKit: zrxKit, ethereumKit: ethereumKit)
      
      let exchangeInteractor = ExchangeInteractor(
        appConfiguration: appConfiguration,
        coinManager: coinManager,
        allowanceChecker: allowanceChecker,
        exchangeWrapper: zrxKit.getExchangeInstance(),
        ethereumKit: ethereumKit,
        zrxKit: zrxKit
      )
      
      mainRelayer = BaseRelayerAdapter(
        zrxkit: zrxKit,
        ethereumKit: ethereumKit,
        coinManager: coinManager,
        ratesConverter: ratesConverter,
        exchangeInteractor: exchangeInteractor,
        refreshInterval: 10_000_000,
        relayerId: 0
      )
    } else {
      clearRelayers()
    }
    subject.onNext(())
  }
  
  func clearRelayers() {
    ethereumKitManager.unlink()
    mainRelayer = nil
  }
}
