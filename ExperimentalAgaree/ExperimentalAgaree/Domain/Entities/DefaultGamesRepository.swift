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
        completion: @escaping (Result<[GameModel], any Error>) -> Void
    ) -> (any Cancellable)? {
        let task = RepositoryTask()
        
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
