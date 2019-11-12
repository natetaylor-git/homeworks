//
//  ViewController.swift
//  hw9
//
//  Created by nate.taylor_macbook on 11/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CollectionControllerProtocol {

    var collection: UICollectionView!
    var collectionSourceAndDelegate: CollectionSupport!
//    var numberOfAdded: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionSourceAndDelegate = CollectionSupport(with: self)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.collection = UICollectionView.init(frame: UIScreen.main.bounds,
                                                collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.dataSource = collectionSourceAndDelegate
        collection.delegate = collectionSourceAndDelegate
        collection.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        self.createAddButton()
//        self.createUpdateButton()
        
        self.view.addSubview(collection)
    }
    
    func createAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressedAddButton))
//        self.navigationItem.title = String("Added: 0")
    }
    
//    func createUpdateButton() {
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(updateUI))
//    }
    
    @objc func pressedAddButton() {
//        self.numberOfAdded += 1
//        self.navigationItem.title = "Added: " + String(numberOfAdded)
        self.addCell()
    }
    
//    @objc func updateUI() {
//        self.numberOfAdded = 0
//        self.navigationItem.title = String("Added: 0")
//        collection.reloadData()
//    }
    
    func addCell() {
        collectionSourceAndDelegate.addNewData()
    }
    
    func deleteCell(at index: Int) {
        collectionSourceAndDelegate.deleteData(at: index)
    }
    
}

