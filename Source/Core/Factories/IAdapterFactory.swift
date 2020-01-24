protocol IAdapterFactory {
  func adapter(coin: Coin, authData: AuthData) -> IAdapter?
}
