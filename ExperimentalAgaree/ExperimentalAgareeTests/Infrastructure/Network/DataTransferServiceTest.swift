//
//  DataTransferServiceTest.swift
//  ExperimentalAgareeTests
//
//  Created by Wonsang Hwang on 11/5/24.
//

import Foundation
@testable import ExperimentalAgaree
import XCTest

fileprivate struct MockModel: Decodable {
    let name: String
    let url: String
}

final class DataTransferDispatchQueueMock: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        work()
    }
}

final class DataTransferServiceTest: XCTestCase {
    
    private var count: Int!
    private var config: NetworkConfigurableMock!
    private var queueMock: DataTransferDispatchQueue!
    
    override func setUp() {
        count = 0
        config = NetworkConfigurableMock()
        queueMock = DataTransferDispatchQueueMock()
    }
    
    private enum DataTransferErrorMock: Error {
        case someError
    }
    
    func test_whenReceivedInvalidResponse_ShouldReturnDecodingError() {
        // given
        
        let responsedData = #"{"손흥민":"null", "민지":"https://www.naver.com"}"#.data(using: .utf8)
        let sessionManager = NetworkSessionManagerMock(response: nil, data: responsedData, error: nil)
        let netService = DefaultNetworkService(config: config, session: sessionManager)
        let sut = DefaultDataTransferService(networkService: netService)
        let gameReqDTO = GameRequestDTO(game: .guessWho, numberOfPlayers: 2)
        let endPoint = APIEndpoints.getGames(with: gameReqDTO)
        // then
        
        _ = sut.request(with: endPoint, on: queueMock, completion: { result in
            
        })
        //when
    }
    
    func test_whenReceivedValidResponse_ShouldReturnDecodingError() {
        
    }
}
