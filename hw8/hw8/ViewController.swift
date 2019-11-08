//
//  ViewController.swift
//  hw8
//
//  Created by nate.taylor_macbook on 04/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardsCollectionDelegate {
    
    let cardsCollection = CardsCollection()
    var cardsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Task Board"
        self.view.backgroundColor = .white
        self.cardsCollection.delegate = self

        self.cardsCollectionView = cardsCollection.cardsCollectionView
        self.view.addSubview(cardsCollectionView)
    }

    func createDoneButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTextEditing))
    }
    
    @objc func doneTextEditing() {
        self.navigationItem.rightBarButtonItem = nil
        self.cardsCollection.finishedCellEditing()
    }
}

