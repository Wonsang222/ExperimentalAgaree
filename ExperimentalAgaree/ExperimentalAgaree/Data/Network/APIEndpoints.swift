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
            path: gameReqDTO.game,
=======
            path: gameReqDTO.game.rawValue,
            responseDecoder: <#T##any ResponseDecoder#>,
>>>>>>> 30a6ec2b98c5bd30cd5f3cff5bd8e6daf0410c32
            method: .get,
            queryParameter: gameReqDTO,
            bodyParameter: nil)
    }
}
