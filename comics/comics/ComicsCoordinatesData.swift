//
//  ComicsCoordinatesData.swift
//  comics
//
//  Created by nate.taylor_macbook on 26/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

struct ComicsPicturesRects {
    let pic1 = CGRect(x: 10, y: 10, width: 548, height: 756)
    let pic2 = CGRect(x: 580, y: 10, width: 538, height: 756)
    let pic3 = CGRect(x: 1140, y: 10, width: 551, height: 756)
    let pic4 = CGRect(x: 12, y: 788, width: 825, height: 937)
    let pic5 = CGRect(x: 866, y: 788, width: 827, height: 754)
    let pic6 = CGRect(x: 12, y: 1751, width: 833, height: 576)
    let pic7 = CGRect(x: 873, y: 1567, width: 820, height: 756)
    let allPictures: [CGRect]
    
    init() {
        self.allPictures = [pic1, pic2, pic3, pic4, pic5, pic6, pic7]
    }
}
