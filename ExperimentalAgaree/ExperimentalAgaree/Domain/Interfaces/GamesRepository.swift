//
//  GaemsRepository.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/24/24.
//

import Foundation

protocol GamesRepository {
    func fetchCharacterList(
        query: GameInfo,
        completion: @escaping ([GameModel]) -> Void
    ) -> Cancellable?
    
    func fetchCharacters(
        query: [GameModel],
        completion: @escaping ([GuessWhoGameList]) -> Void
    ) -> Cancellable?
}
