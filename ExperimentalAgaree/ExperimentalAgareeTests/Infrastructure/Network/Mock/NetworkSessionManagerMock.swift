//
//  NetworkSessionManagerMock.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 9/9/24.
//

import Foundation
@testable import ExperimentalAgaree

struct NetworkSessionManagerMock: NetworkSessionManager {
    
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(req: URLRequest,
                 config: URLSessionConfiguration,
                 completion: @escaping Completion
    ) -> ExperimentalAgaree.NetworkCancellable {
            completion(data, response, error)
        return URLSessionDataTask()
    }
}
