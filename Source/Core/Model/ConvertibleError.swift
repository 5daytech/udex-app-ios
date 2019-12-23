import EthereumKit

protocol ConvertibleError: Error {
    var convertedError: Error { get }
}

extension Error {

    var convertedError: Error {
        if let error = self as? ConvertibleError {
            return error.convertedError
        }
        return self
    }

}

extension Error {

    var localizedDescription: String {
        if let localizedError = self as? LocalizedError, let errorDescription = localizedError.errorDescription {
            return errorDescription
        } else {
            return "\("alert.unknown_error") \(String(reflecting: self))" // TODO: Localization
        }
    }

}

extension EthereumKit.NetworkError: ConvertibleError {

    var convertedError: Error {
        switch self {
        case .noConnection: return ConnectionError.noConnection
        default: return self
        }
    }

}
