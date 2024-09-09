//
//  NetworkConfigurableMock.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 9/9/24.
//

import Foundation
@testable import ExperimentalAgaree

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL
    var baseHeaders: [String : String]
    var queryParameter: [String : String]
    var networkServiceType: ExperimentalAgaree.NetworkServiceType
    
    init() {
        
        let pList = Bundle.main.url(forResource: "AppInfo", withExtension: "plist")!
        let data = try! Data(contentsOf: pList)
        
        let dic = try! JSONSerialization.jsonObject(with: data) as! [String : String]
        
        self.baseURL = URL(string: dic["AppRootBundle"]! )!
        self.baseHeaders = ["Authorization":dic["AppRootUUID"]!, "User-Agent": dic["AppRootBundle"]!]
        self.queryParameter = [:]
        self.networkServiceType = .responsive
    }
}
