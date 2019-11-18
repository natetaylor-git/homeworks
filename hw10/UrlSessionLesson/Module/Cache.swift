//
//  Cache.swift
//  UrlSessionLesson
//
//  Created by nate.taylor_macbook on 18/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class ThreadSafeCache {
    private let queue = DispatchQueue(label: "com.cacheQueue", attributes: .concurrent)
    private var cache = [Int: UIImage]()
    
    public var keys: Dictionary<Int, UIImage>.Keys {
        var keys = Dictionary<Int, UIImage>().keys
        self.queue.sync {
            keys = cache.keys
        }
        return keys
    }
    
    public func removeAll(){
        self.queue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
    
    public subscript(key: Int) -> UIImage? {
        get {
            var item: UIImage?
            // так как есть return, надо дождаться получения item, чтобы не было crash
            self.queue.sync {
                item = self.cache[key]
            }
            return item
        }
        
        set (value) {
            queue.async(flags: .barrier) {
                self.cache[key] = value
            }
        }
    }
}
