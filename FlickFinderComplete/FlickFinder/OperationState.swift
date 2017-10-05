//
//  OperationState.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - OperationState

enum OperationState {
    case pending, ready, executing, finished
    
    // MARK: Key Paths
    
    func keyPath() -> String {
        switch self {
        case .pending:
            return "isPending"
        case .ready:
            return "isReady"
        case .executing:
            return "isExecuting"
        case .finished:
            return "isFinished"
        }
    }
}
