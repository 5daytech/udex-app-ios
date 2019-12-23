protocol IAppConfigProvider {
    var ipfsId: String { get }
    var ipfsGateways: [String] { get }

    var companyWebPageLink: String { get }
    var appWebPageLink: String { get }
    var reportEmail: String { get }
    var reportTelegramGroup: String { get }

    var reachabilityHost: String { get }
    var testMode: Bool { get }
    var officeMode: Bool { get }
    var infuraCredentials: (id: String, secret: String?) { get }
    var btcCoreRpcUrl: String { get }
    var etherscanKey: String { get }
    var currencies: [Currency] { get }

    func defaultWords(count: Int) -> [String]
    var defaultEosCredentials: (String, String) { get }
    var disablePinLock: Bool { get }

    var featuredCoins: [Coin] { get }
    var coins: [Coin] { get }
}
