//
//  NetworkServiceTest.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 9/9/24.
//

import Foundation
@testable import ExperimentalAgaree
import XCTest

final class NetworkServiceTest: XCTestCase {
    
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
             bodyEncoder: ExperimentalAgaree.BodyEncoder = DefaultBodyEncoder()
        ) {
            self.path = path
            self.method = method
            self.headerParameters = headerParameters
            self.queryParameter = queryParameter
            self.bodyParameter = bodyParameter
            self.bodyEncoder = bodyEncoder
        }
    }
    
    private var config: NetworkConfigurableMock!
    private var count: Int!
    
    override func setUp() {
        config = NetworkConfigurableMock()
        count = 0
    }
    
    func test_whenCancelErrorReturned_shouldReturnCancelledError() {
        //given
        
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let canceleedError = NSError(domain: "network", code: NSURLErrorCancelled)
        
        let sut = DefaultNetworkService(config: config, session: NetworkSessionManagerMock(response: nil, data: nil, error: canceleedError))
        let gameReqDTO = GameRequestDTO(game: .guessWho, numberOfPlayers: 2)
        let endPoint = EndpointMock(queryParameter: gameReqDTO)
        // when
        
        _ = sut.request(endpoint: endPoint, completion: { result in
            do {
                _ = try result.get()
                XCTFail("오류")
            } catch (let err) {
                if case NetworkError.cancelled = err {
                    // then
                    completionCallsCount += 1
                    XCTAssertEqual(completionCallsCount, 1)
                } else {
                    XCTFail("오류2")
                    return
                }
            }
        })
    }
    
    func test_whenErrorWithNoConnectedWithInternet_shouldReturnNotConnectedError() {
        // given
        let causedError = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet)
        let session = NetworkSessionManagerMock(response: nil, data: nil, error: causedError)
        let sut = DefaultNetworkService(config: config, session: session)
        let gameReqDTO = GameRequestDTO(game: .guessWho, numberOfPlayers: 2)
        let endPoint = EndpointMock(queryParameter: gameReqDTO)
        
        // when
        _ = sut.request(endpoint: endPoint, completion: { [weak self] result in
            do {
                _ = try result.get()
                XCTFail("Should Not Happen")
            } catch (let error) {
                if case NetworkError.notConnected = error {
                    self?.count = 1
                } else {
                    XCTFail("Wrong Error")
                }
            }
        })
        // then
        
        XCTAssertEqual(count, 1)
        
    }
}
