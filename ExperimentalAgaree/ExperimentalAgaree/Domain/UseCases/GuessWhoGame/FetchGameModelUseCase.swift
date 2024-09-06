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
        completion: @escaping (GameModelList) -> Void
    ) -> Cancellable?
}

struct FetchGameModelUseCaseRequestValue {
    let gameInfo: GameInfo
}


final class DefaultFetchGameModelUseCase: FetchGameModelUseCase {
    
    let gameRespository: GamesRepository
    
    init(
        gameRespository: GamesRepository
    ) {
        self.gameRespository = gameRespository
    }
    
    func fetch(
        requestValue: FetchGameModelUseCaseRequestValue,
        completion: @escaping (GameModelList) -> Void
    ) -> Cancellable? {
        gameRespository.fetchCharacterList(query: requestValue.gameInfo) { result in
            switch result {
            case .success(let gameModelList):
                print(123)
            case .failure(let error):
                print(123)
            }
        }
    }
    
    private func fetch
        
    
}
