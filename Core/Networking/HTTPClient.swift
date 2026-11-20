import Foundation

/// Small, injectable HTTP boundary shared by Reddit API services.
/// Authentication is deliberately kept outside this type.
struct HTTPClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func decode<Response: Decodable>(
        _ responseType: Response.Type,
        from request: URLRequest
    ) async throws -> Response {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            throw HTTPClientError.transport(error.code)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw HTTPClientError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(responseType, from: data)
        } catch {
            throw HTTPClientError.decoding
        }
    }
}
