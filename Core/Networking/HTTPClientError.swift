import Foundation

enum HTTPClientError: Error, Equatable, LocalizedError {
    case transport(URLError.Code)
    case invalidResponse
    case httpStatus(Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .transport:
            return "The network request could not be completed."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpStatus(let statusCode):
            return "The server returned HTTP status \(statusCode)."
        case .decoding:
            return "The server response could not be decoded."
        }
    }
}
