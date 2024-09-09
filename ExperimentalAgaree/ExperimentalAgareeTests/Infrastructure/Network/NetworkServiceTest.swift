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
    }
}
