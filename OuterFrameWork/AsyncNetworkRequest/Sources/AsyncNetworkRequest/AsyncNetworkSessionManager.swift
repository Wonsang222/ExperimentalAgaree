import Foundation

public protocol AsyncSessionManager {
    func request(
        req: URLRequest,
        config: URLSessionConfiguration
    ) async throws -> (Data, URLResponse)
}

public final class AsyncNetworkSessionManager: AsyncSessionManager {
    
    public init() {}
    public func request(
        req: URLRequest,
        config: URLSessionConfiguration
    ) async throws -> (Data, URLResponse) {
        return try await URLSession(configuration: config).data(for: req)
    }
}
