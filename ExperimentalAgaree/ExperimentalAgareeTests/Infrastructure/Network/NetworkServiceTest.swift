//
//  NetworkServiceTest.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 9/9/24.
//

import Foundation
@testable import ExperimentalAgaree
import XCTest

class NetworkServiceTest: XCTestCase {
    
    private enum NetworkMockError: Error {
        case mockError
    }
    
   private struct EndpointMock: Requestable {
        var path: String?
        var method: ExperimentalAgaree.HttpMethod
        var headerParameters: [String : String]
        var queryParameter: Encodable
        var bodyParameter: Encodable?
        var bodyEncoder: ExperimentalAgaree.BodyEncoder
        
        init(path: String? = nil,
             method: ExperimentalAgaree.HttpMethod = .get,
             headerParameters: [String : String] = [:],
             queryParameter: Encodable,
             bodyParameter: Encodable? = nil,
             bodyEncoder: ExperimentalAgaree.BodyEncoder
        ) {
            self.path = path
            self.method = method
            self.headerParameters = headerParameters
            self.queryParameter = queryParameter
            self.bodyParameter = bodyParameter
            self.bodyEncoder = bodyEncoder
        }
    }
    
    func test_whenDeviceInternetIsNotAvailable_shouldReturnCancelledError() {
        //given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled)
        let session = NetworkSessionManagerMock(response: nil, data: nil, error: cancelledError)
        
        let endPoint = EndpointMock(queryParameter: <#T##Encodable#>, bodyEncoder: <#T##BodyEncoder#>)
        
        let sut = DefaultNetworkService(config: config, session: session)
        //when
        
        _ = sut.request(endpoint: <#T##Requestable#>, completion: <#T##DefaultNetworkService.Completion##DefaultNetworkService.Completion##(Result<Data?, NetworkError>) -> Void#>)
        
        //then
    }
}
