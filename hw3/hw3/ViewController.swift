//
//  ViewController.swift
//  hw3
//
//  Created by nate.taylor_macbook on 10/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataStorage = MyStorage<Int>()
        dataStorage.writeData("test1", 123)
        
        //dataStorage.printStorage()
        
        let retrievedData = dataStorage.getData("test2")
        switch retrievedData {
        case .success(let data): print(data)
        case .failure(let error): print(error.localizedDescription)
        }
        
        //dataStorage.printStorage()
        
        let result = dataStorage.removeData("test1")
        switch result {
        case .success(let data): print(data)
        case .failure(let error): print(error.localizedDescription)
        }
        
        //dataStorage.printStorage()
    }
}

