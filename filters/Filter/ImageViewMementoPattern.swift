//
//  ImageViewMementoPattern.swift
//  Filter
//
//  Created by nate.taylor_macbook on 26/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CareTaker {
    private lazy var mementos = [Memento]()
    private var creator: ImageViewCreator
    
    init(creator: ImageViewCreator) {
        self.creator = creator
    }
    
    func backup() {
        mementos.append(creator.save())
    }
    
    func undo() {
        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()

        creator.restore(memento: removedMemento)
    }
}

class ImageViewCreator {
    private let imageView: UIImageView
    
    init(_ imageView: UIImageView) {
        self.imageView = imageView
    }
    
    func setNewSize(size: CGSize) {
        self.imageView.frame.size = size
    }
    
    func save() -> Memento {
        return ImageViewMemento(size: self.imageView.frame.size)
    }
    
    func restore(memento: Memento) {
        guard let memento = memento as? ImageViewMemento else { return }
        self.imageView.frame.size = memento.size
    }
}

protocol Memento {
    var size: CGSize { get }
}

// imageview fields for snapshot
class ImageViewMemento: Memento {
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
}
