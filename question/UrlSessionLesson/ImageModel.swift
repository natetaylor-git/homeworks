//
//  ImageModel.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

struct ImageLoadedModel {
    let image: UIImage?
    let searchString: String
}

struct ImageModel {
	let path: String
	let description: String
    let searchString: String
}

struct ImageViewModel {
	var description: String
	var image: UIImage
}

class ThreadSafeImageModelCollection {
    private let queue = DispatchQueue(label: "com.image.collection.Queue", attributes: .concurrent)
    private var collection = [ImageModel]()
    
//    public init(with collection: [ImageModel] = []) {
//        self.queue.async(flags: .barrier) {
//            self.collection = collection
//        }
//    }
    
    public func append(contentsOf sequence: [ImageModel]) {
        self.queue.async(flags: .barrier) {
            self.collection.append(contentsOf: sequence)
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
    
    public subscript(index: Int) -> ImageModel {
        get {
            var item: ImageModel!
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
