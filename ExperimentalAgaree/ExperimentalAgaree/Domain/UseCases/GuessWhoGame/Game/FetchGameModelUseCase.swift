//
//  FetchGameModelUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/6/24.
//

import Foundation

protocol FetchGameModelUseCase {
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping (Result<GameModelList, Error>) -> Void
    ) -> Cancellable?
}

struct FetchGameModelUseCaseRequestValue {
    let gameInfo: GameInfo
}

final class DefaultFetchGameModelUseCase: FetchGameModelUseCase {
    
    private let _gameRespository: GamesRepository
    
    init(
        gameRespository: GamesRepository
    ) {
        self._gameRespository = gameRespository
    }
    
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping (Result<GameModelList, Error>) -> Void
    ) -> Cancellable? {
        _gameRespository.fetchCharacterList(query: requestValue.gameInfo,
                                           completion: completion)
    }
}
