//
//  DefaultGamesRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/7/24.
//

import Foundation

final class DefaultGamesRepository: GamesRepository {
    
    private let dataTransferService: DataTransferService
    private let executionQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        executionQueue: DataTransferDispatchQueue
    ) {
        self.dataTransferService = dataTransferService
        self.executionQueue = executionQueue
    }
    
    func fetchCharacterList(query: GameInfo,
                            completion: @escaping (Result<GameModelList, any Error>) -> Void
    ) -> (any Cancellable)? {
        let task = RepositoryTask()
        
        let requestDTO = GameRequestDTO(game: query.gamePath, numberOfPlayers: query.numberOfPlayers)
        
        let responseDTO = APIEndpoints.getGames(with: requestDTO)
        
        task.networkTask = dataTransferService.request(with: responseDTO,
                                                       on: executionQueue,
                                                       completion: { [executionQueue] result in
            switch result {
            case .success(let responseDTO):
                let domain = responseDTO.toDomain()
                executionQueue.asyncExecute {
                    completion(.success(domain))
                }
            case .failure(let error):
                executionQueue.asyncExecute {
                    completion(.failure(error))
                }
            }
        })
        return task
        
    }
}
