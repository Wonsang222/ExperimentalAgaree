

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

extension NetworkError {
    public var description: String {
        switch self {
        case .urlGeneration:
            return "잘못된 url 입니다."
        default:
            return "네트워크 에러입니다."
        }
    }
}
