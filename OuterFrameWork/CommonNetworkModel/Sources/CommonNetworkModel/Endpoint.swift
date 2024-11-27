//
//  File.swift
//  
//
//  Created by WISA Mobile on 11/22/24.
//

import Foundation

public enum RequestError: Error {
    case urlComponent
}

public enum NetworkServiceType: Int {
    case responsive = 6
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol BodyEncoder {
    func encode(parameters: [String:Any]) -> Data?
}

public protocol Requestable {
    var path: String?  { get }
    var method: HttpMethod { get }
    var headerParameters: [String : String] { get }
    var queryParameter: Encodable? { get }
    var bodyParameter: Encodable? { get }
    var bodyEncoder: BodyEncoder { get }
    
    func urlRequest(with: NetworkConfigurable) throws -> URLRequest
}

public extension Requestable {
    
   func urlConfiguration(with config: NetworkConfigurable) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let serviceType = UInt(config.networkServiceType.rawValue)
        configuration.networkServiceType = NSURLRequest.NetworkServiceType(rawValue: serviceType) ?? .responsiveData
        configuration.httpAdditionalHeaders = config.baseHeaders
        return configuration
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try url(with: config)
        var req = URLRequest(url: url)
        let httpMethod = method.rawValue
        req.httpMethod = httpMethod
        if httpMethod == "POST",
            let bodyParameter = bodyParameter,
           let httpBody = try bodyParameter.toDic() {
            req.httpBody = bodyEncoder.encode(parameters: httpBody)
        }
        headerParameters.forEach { req.setValue($1, forHTTPHeaderField: $0) }
        return req
    }
    
    func url(with config: NetworkConfigurable) throws -> URL {
        
        if config.baseURL.absoluteString == " " {
            
            let url = URL(string: path ?? "")
            guard let url = url else {
                throw RequestError.urlComponent
            }
            return url
        }
        
        var stringURL = config.baseURL.absoluteString.last == "/"
        ? config.baseURL.absoluteString
        : config.baseURL.absoluteString + "/"
        
        if let path = path {
            stringURL += path
        }
        
        guard var urlComponent = URLComponents(string: stringURL) else { throw RequestError.urlComponent}
        
        var query = [URLQueryItem]()
        
        try queryParameter?
            .toDic()?
            .forEach { query.append(URLQueryItem(name: $0, value: "\($1)")) }
        
        if !query.isEmpty {
            urlComponent.queryItems = query
        }
        
        guard let url = urlComponent.url else {
            throw RequestError.urlComponent
        }
        return url
    }
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

public final class Endpoint<T>: ResponseRequestable {
    public typealias Response = T
    
    public let path: String?
    public let responseDecoder: ResponseDecoder
    public let method: HttpMethod
    public let headerParameters: [String : String]
    public let queryParameter: Encodable?
    public let bodyParameter: Encodable?
    public var bodyEncoder: BodyEncoder = DefaultBodyEncoder()
    
    public init(
        path: String?,
        responseDecoder: ResponseDecoder,
         method: HttpMethod,
        headerParameters: [String : String] = [:],
         queryParameter: Encodable?,
         bodyParameter: Encodable?
    ) {
        self.path = path
        self.responseDecoder = responseDecoder
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameter = queryParameter
        self.bodyParameter = bodyParameter
    }
}

fileprivate final class DefaultBodyEncoder: BodyEncoder {
    func encode(parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

fileprivate extension Encodable {
    func toDic() throws -> [String:Any]? {
        let data = try JSONEncoder().encode(self)
        let dic = try JSONSerialization.jsonObject(with: data)
        return dic as? [String:Any]
    }
}
