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
    
    private enum DataTransferErrorMock: Error {
        case someError
    }
}
