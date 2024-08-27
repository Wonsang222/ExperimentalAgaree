//
//  UseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/26/24.
//

import Foundation


protocol GameUseCase {
    @discardableResult
    func fetch() -> Cancellable?
    func start()
    func judge() -> Bool
}
