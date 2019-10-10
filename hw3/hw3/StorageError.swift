//
//  StorageError.swift
//  hw3
//
//  Created by nate.taylor_macbook on 10/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case noKeyFound(_ comment: String)
}

extension StorageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noKeyFound(let comment): return "[Error] noKeyFound: " + comment
        }
    }
}
