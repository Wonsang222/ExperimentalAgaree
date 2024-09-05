//
//  Endpoint.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/21/24.
//

import Foundation

enum RequestError: Error {
    case urlComponent
}

enum NetworkServiceType: Int {
    case responsive = 6
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol BodyEncoder {
    func encode(parameters: [String:Any]) -> Data?
}

protocol Requestable {
    var path: String?  { get }
    var method: HttpMethod { get }
    var headerParameters: [String : String] { get }
    var queryParameter: Encodable { get }
    var bodyParameter: Encodable? { get }
    var bodyEncoder: BodyEncoder { get }
    
    func urlRequest(with: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    
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
            var bodyParameter = bodyParameter,
           let httpBody = try bodyParameter.toDic() {
            req.httpBody = bodyEncoder.encode(parameters: httpBody)
        }
        headerParameters.forEach { req.setValue($1, forHTTPHeaderField: $0) }
        return req
    }
    
    func url(with config: NetworkConfigurable) throws -> URL {
        var stringURL = config.baseURL.absoluteString.last == "/"
        ? config.baseURL.absoluteString
        : config.baseURL.absoluteString + "/"
        
        if let path = path {
            stringURL += path
        }
        
        guard var urlComponent = URLComponents(string: stringURL) else { throw RequestError.urlComponent}
        
        var query = [URLQueryItem]()
        
        try queryParameter.toDic()?
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

protocol ResponseDecoder {
    func decode<T>(_ data: Data) throws -> [T] where T: Decodable, T: GameModelUsable
}

final class DefaultResponseDecoder: ResponseDecoder {
    func decode<T>(_ data: Data) throws -> [T] where T : Decodable, T: GameModelUsable {
        let dic = try JSONSerialization.jsonObject(with: data)
        
        if let dic = dic as? [String:String] {
            return dic.map { GameResponseDTO(name: $0, url: $1) as! T }
        } else {
            throw DatatransferError.noResponse
        }
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

final class Endpoint<T>: ResponseRequestable {
        typealias Response = T
    
        let path: String?
       let responseDecoder: ResponseDecoder
       let method: HttpMethod
       let headerParameters: [String : String]
       let queryParameter: Encodable
       let bodyParameter: Encodable?
       let bodyEncoder: BodyEncoder
    
    init(
        path: String?,
        responseDecoder: ResponseDecoder = DefaultResponseDecoder(),
         method: HttpMethod,
        headerParameters: [String : String] = [:],
         queryParameter: Encodable,
         bodyParameter: Encodable?,
         bodyEncoder: BodyEncoder = DefaultBodyEncoder()
    ) {
        self.path = path
        self.responseDecoder = responseDecoder
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameter = queryParameter
        self.bodyParameter = bodyParameter
        self.bodyEncoder = bodyEncoder
    }
}

final class DefaultBodyEncoder: BodyEncoder {
    func encode(parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}


extension Encodable {
    func toDic() throws -> [String:Any]? {
        let data = try JSONEncoder().encode(self)
        let dic = try JSONSerialization.jsonObject(with: data)
        return dic as? [String:Any]
    }
}
