//
//  Observable.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 8/27/24.
//

import Foundation

final class Observable<T> {
    
    private var observers = [Observer<T>]()
    private var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func addObserver(_ observer: Observer<T>) {
        observers.append(observer)
        observer.block(value)
    }
    
    func removeObserver(_ observer: Observer<T>) {
        observers = observers.filter { $0.target !== observer.target }
    }
    
    func setValue(_ newValue: T) {
        value = newValue
        onChange()
    }
    
    private func onChange() {
        observers.forEach { $0.block(value) }
    }
    
}


final class Observer<T> {
    let block: (T) -> Void
    weak var target: AnyObject?
    
    init(
        block: @escaping (T) -> Void,
        target: AnyObject?
    ) {
        self.block = block
        self.target = target
    }
}
