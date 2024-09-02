//
//  RepositoryTask.swift
//  ExperimentalAgaree
//
//  Created by 황원상 on 9/2/24.
//

import Foundation

class RepositoryTask: Cancellable {
    
    var task: NetworkCancellable?
    var isCancelled: Bool = false
    
    init(
        task: NetworkCancellable
        ) {
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
        isCancelled = true
    }
}
