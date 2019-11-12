//
//  Collection.swift
//  hw9
//
//  Created by nate.taylor_macbook on 12/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol CollectionControllerProtocol {
    func deleteCell(at index: Int)
}

class CollectionSupport: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let queue = DispatchQueue(label: "addCell.queue", attributes: .concurrent)
    var controller: CollectionControllerProtocol!
    
    init(with contoller: CollectionControllerProtocol) {
        super.init()
        
        self.controller = contoller
    }
    
    func addNewData() {
        queue.async(flags: .barrier) {
            var number = 0
            if let last = self.data.last {
                number = last + 1
            }
            
            self.data.append(number)
        }
    }
    
    func deleteData(at index: Int) {
        queue.async(flags: .barrier) {
            self.data.remove(at: index)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomCollectionViewCell
        
        cell.label.text = String(data[indexPath.item])
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.alpha = 0.5
        
        //self.deleteData(at: indexPath.item)
        //можно было сразу вызывать deleteData отсюда, но завернул в контроллер для единообразия
        self.controller.deleteCell(at: indexPath.item)
    }
}
