import Foundation

public final class AsyncNetworkSessionManager {
    
    public init() {}
    public func request(
        req: URLRequest,
        config: URLSessionConfiguration
    ) async throws -> (Data, URLResponse) {
        return try await URLSession(configuration: config).data(for: req)
    }
}
