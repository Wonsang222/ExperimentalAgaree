//
//  GuessWhoGameUseCase.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/19/24.
//

import Foundation

// fetch
// gameStart

protocol CommonGameUseCase: GameUseCase {
    func fetch()
    func start()
    
}

final class GuessWhoGameUseCase: CommonGameUseCase {
    
    private let fetchUseCase: FetchGameModelUseCase
    private let timerUseCase: GameTimerUseCase
    private let sttUseCase: STTUseCase
    
    // fetch model List
    // ready?
    // go!
    // right? -> next
    // no next? -> clear
    // timeOut -> fail
    
    init(
        fetchUseCase: FetchGameModelUseCase,
        timerUseCase: GameTimerUseCase,
        sttUseCase: STTUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.timerUseCase = timerUseCase
        self.sttUseCase = sttUseCase
    }
    
    func fetch() {
        
    }
    
    func start() {
        
    }
    
    func right() {
        
    }
    
    func wrong() {
        
    }
    
    func judge() -> Bool {
        return true
    }
}
