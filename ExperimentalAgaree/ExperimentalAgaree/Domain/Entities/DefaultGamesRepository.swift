//
//  DefaultGamesRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

final class DefaultGamesRepository: GamesRepository {
    
    private let dataTransferService: DataTransferService
    private let completionQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        completionQueue: DataTransferDispatchQueue
        ) {
        self.dataTransferService = dataTransferService
        self.completionQueue = completionQueue
    }
    
    func fetchCharacterList(
        query: GameInfo,
        completion: @escaping (Result<GameModelList, any Error>) -> Void
    ) -> (any Cancellable)? {
        let task = RepositoryTask()
        
        let requestDTO = GameRequestDTO(game: query.gamePath, numberOfPlayers: query.numberOfPlayers)
        let endPoint = APIEndpoints.getGames(with: requestDTO)
        task.networkTask = dataTransferService.request(with: endPoint, on: completionQueue) { [ weak self] result in
            switch result {
            case .success(let response):
                self?.completionQueue.asyncExecute {
                    completion(.success(response.toDomain()))
                }
            case .failure(let dataError):
                self?.completionQueue.asyncExecute {
                    completion(.failure(dataError))
                }
            }
        }
        return task
        }
    
    func fetchCharacters(
        query: [GameModel],
        completion: @escaping (Result<[GuessWhoGameList], any Error>) -> Void
    ) -> (any Cancellable)? {
        let task = RepositoryTask()
        
        return task
    }
}
