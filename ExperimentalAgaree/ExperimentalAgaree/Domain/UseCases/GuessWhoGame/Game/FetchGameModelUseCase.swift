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
    private let _asyncRepository: GameModelImageRepository
    
    init(
        gameRespository: GamesRepository,
        _asyncRepository: GameModelImageRepository
    ) {
        self._gameRespository = gameRespository
        self._asyncRepository = _asyncRepository
    }
        
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping (Result<GameModelList, Error>) -> Void
    ) -> Cancellable? {
        _gameRespository.fetchCharacterList(query: requestValue.gameInfo) { [weak self] domainModel in
            switch domainModel {
            case .success(let list):
                guard let strongSelf = self else { return }
                Task {
                    await strongSelf._asyncRepository.fetchImages(paths: list) { result in
                        completion(.success(result))
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
