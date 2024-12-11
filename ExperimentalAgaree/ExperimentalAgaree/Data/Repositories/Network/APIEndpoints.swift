//
//  APIEndpoints.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation
import CommonNetworkModel


struct APIEndpoints {
    
    static func getGames(
        with gameReqDTO: GameRequestDTO
    ) -> Endpoint<GameResponseDTO> {
        
        return Endpoint(
            path: gameReqDTO.game.rawValue,
            responseDecoder: DefaultResponseDecoder(),
            method: .get,
            queryParameter: gameReqDTO,
            bodyParameter: nil)
    }
    
    static func getImage(with path: String) -> Endpoint<Data> {
        let lastPath = (path as NSString).lastPathComponent
        return Endpoint(path: lastPath,
                        responseDecoder: RawDataResponseDecoder(),
                        method: .get,
                        queryParameter: nil,
                        bodyParameter: nil)
    }
}
