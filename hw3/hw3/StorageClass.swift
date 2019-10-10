//
//  StorageClass.swift
//  hw3
//
//  Created by nate.taylor_macbook on 10/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

public class MyStorage <T: Codable> {
    
    var storage: UserDefaults
    
    init() {
        self.storage = UserDefaults.standard
    }
    
    func writeData(_ key: String, _ val: T) {
        self.storage.set(val, forKey: key)
    }
    
    func getData(_ key: String) -> Result<T, StorageError> {
        let val = self.storage.value(forKey: key) as? T
        if val != nil {
            return .success(val!)
        } else {
            let err = StorageError.noKeyFound("key \"\(key)\" doesn't exist")
            return .failure(err)
        }
    }
    
    func removeData(_ key: String) -> Result<T, StorageError> {
        let resultData = self.getData(key)
        self.storage.removeObject(forKey: key)
        return resultData
    }
    
    func printStorage(){
        for (key, value) in self.storage.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    
}
