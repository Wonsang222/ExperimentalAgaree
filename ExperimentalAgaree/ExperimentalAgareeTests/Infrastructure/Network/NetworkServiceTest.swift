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
    
    struct EndpointMock: Requestable {
        var path: String?
        var method: ExperimentalAgaree.HttpMethod
        var headerParameters: [String : String]
        var queryParameter: Encodable
        var bodyParameter: Encodable?
        var bodyEncoder: ExperimentalAgaree.BodyEncoder
        
        init(path: String? = nil, method: ExperimentalAgaree.HttpMethod, headerParameters: [String : String], queryParameter: Encodable, bodyParameter: Encodable? = nil, bodyEncoder: ExperimentalAgaree.BodyEncoder) {
            self.path = path
            self.method = method
            self.headerParameters = headerParameters
            self.queryParameter = queryParameter
            self.bodyParameter = bodyParameter
            self.bodyEncoder = bodyEncoder
        }
    }
}
