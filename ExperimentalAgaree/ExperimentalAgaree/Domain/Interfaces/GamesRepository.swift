//
//  GaemsRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import Foundation

protocol GamesRepository {
    @discardableResult
    func fetchCharacterList(
        query: GameInfo,
        completion: @escaping (Result<GameModelList, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchCharacters(
        query: [GameModel],
        completion: @escaping (Result<[GuessWhoGameList], Error>) -> Void
    ) -> Cancellable?
}
