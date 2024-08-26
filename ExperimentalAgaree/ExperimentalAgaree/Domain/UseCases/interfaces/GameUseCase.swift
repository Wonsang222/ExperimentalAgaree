//
//  UseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//

import Foundation


protocol GameUseCase {
    func start(info: GameInfo) -> Cancellable?
    func judge() -> Bool
}
