//
//  NetworkConfigurableMock.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 9/9/24.
//

import Foundation
@testable import ExperimentalAgaree

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "")!
    var baseHeaders: [String : String] = ["DSafa":"adsfasdf", "Asdfads": "dsafasdf"]
    var queryParameter: [String : String] = [:]
    var networkServiceType: ExperimentalAgaree.NetworkServiceType = ExperimentalAgaree.NetworkServiceType.responsive
}
