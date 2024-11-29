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
    
    
    private func testing() {
        
    }
    
    private func checkDomainRule() {
        
    }
    
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping (Result<GameModelList, Error>) -> Void
    ) -> Cancellable? {
        _gameRespository.fetchCharacterList(query: requestValue.gameInfo) { domainModel in
            switch domainModel {
            case .success(let list):
                
                Task {
                    let photoURLs = list.models.map { $0.photoUrl }
                    #warning("순서가 맞는다는 보장이 읎다")
                }
                
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
