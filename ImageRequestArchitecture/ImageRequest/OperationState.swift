//
//  OperationState.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - OperationState

enum OperationState {
    case Ready, Executing, Finished
    
    // MARK: Key Paths
    
    func keyPath() -> String {
        switch self {
        case .Ready:
            return "isReady"
        case .Executing:
            return "isExecuting"
        case .Finished:
            return "isFinished"
        }
    }
}
