//
//  ThreadSafeCache.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 22/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

/// Collection of ImageViewModel objets implemetned against private queue using barrier tasks for typical operations
class ThreadSafeImageViewCollection {
    private let queue = DispatchQueue(label: "com.cacheQueue", attributes: .concurrent)
    private var collection = [ImageViewModel]()
    
    public init(with collection: [ImageViewModel] = []) {
        self.queue.async(flags: .barrier) {
            self.collection = collection
        }
    }
    
    public func append(_ element: ImageViewModel) {
        self.queue.async(flags: .barrier) {
            self.collection.append(element)
        }
    }
    
    public func removeAll(){
        self.queue.async(flags: .barrier) {
            self.collection.removeAll()
        }
    }
    
    public var count: Int {
        var count = 0
        
        self.queue.sync {
            count = self.collection.count
        }
        
        return count
    }
    
    public subscript(index: Int) -> ImageViewModel {
        get {
            var item: ImageViewModel!
            self.queue.sync {
                item = self.collection[index]
            }
            return item
        }
        
        set (newModel) {
            queue.async(flags: .barrier) {
                self.collection[index] = newModel
            }
        }
    }
}
