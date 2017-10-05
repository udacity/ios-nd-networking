//
//  OperationState.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - OperationState

enum OperationState {
    case notReady, ready, executing, finished
    
    // MARK: Key Paths
    
    func keyPath() -> String {
        switch self {
        case .notReady:
            return "notReady"
        case .ready:
            return "isReady"
        case .executing:
            return "isExecuting"
        case .finished:
            return "isFinished"
        }
    }
}
