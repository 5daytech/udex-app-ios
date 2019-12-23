protocol IAdapterFactory {
  func adapter(coin: Coin, words: [String]) -> IAdapter?
}
