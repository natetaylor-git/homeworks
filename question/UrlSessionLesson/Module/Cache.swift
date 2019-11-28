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
    private var cache = [Int: ImageViewModel]()
    
    public var keys: Dictionary<Int, ImageViewModel>.Keys {
        var keys = Dictionary<Int, ImageViewModel>().keys
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
    
    public subscript(key: Int) -> ImageViewModel? {
        get {
            var item: ImageViewModel?
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
