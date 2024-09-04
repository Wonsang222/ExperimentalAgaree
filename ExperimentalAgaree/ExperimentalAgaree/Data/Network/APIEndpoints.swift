//
//  APIEndpoints.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation


struct APIEndpoints {
    static func getGames(
        with gameReqDTO: GameRequestDTO
    ) -> Endpoint<GameResponseDTO> {
        
        
        
        return Endpoint(
            path: gameReqDTO.game.rawValue,
            responseDecoder: <#T##any ResponseDecoder#>,
            method: .get,
            queryParameter: <#T##any Encodable#>,
            bodyParameter: <#T##any Encodable#>,
            bodyEncoder: <#T##any BodyEncoder#>)
    }
}
