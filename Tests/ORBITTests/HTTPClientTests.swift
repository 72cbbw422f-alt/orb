import Foundation
import XCTest
@testable import ORBIT

final class HTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        StubURLProtocol.handler = nil
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func testDecodesSuccessfulJSONResponse() async throws {
        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.url?.path, "/posts")
            let response = HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, Data(#"{"id":7,"title":"Hello"}"#.utf8))
        }

        let client = makeClient()
        let result = try await client.decode(TestPayload.self, from: makeRequest())

        XCTAssertEqual(result.id, 7)
        XCTAssertEqual(result.title, "Hello")
    }

    func testMapsNonSuccessStatusToHTTPError() async {
        StubURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 429,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        do {
            _ = try await makeClient().decode(TestPayload.self, from: makeRequest())
            XCTFail("Expected an HTTP status error.")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .httpStatus(429))
        }
    }

    func testMapsMalformedJSONToDecodingError() async {
        StubURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("not-json".utf8))
        }

        do {
            _ = try await makeClient().decode(TestPayload.self, from: makeRequest())
            XCTFail("Expected a decoding error.")
        } catch {
            XCTAssertEqual(error as? HTTPClientError, .decoding)
        }
    }

    func testMapsTransportFailureToTypedError() async {
        StubURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            _ = try await makeClient().decode(TestPayload.self, from: makeRequest())
            XCTFail("Expected a transport error.")
        } catch {
            XCTAssertEqual(
                error as? HTTPClientError,
                .transport(.notConnectedToInternet)
            )
        }
    }

    private func makeClient() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return HTTPClient(session: URLSession(configuration: configuration))
    }

    private func makeRequest() -> URLRequest {
        URLRequest(url: URL(string: "https://example.invalid/posts")!)
    }
}

private struct TestPayload: Decodable {
    let id: Int
    let title: String
}

private final class StubURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
