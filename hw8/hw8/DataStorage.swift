//
//  DataStorage.swift
//  hw8
//
//  Created by nate.taylor_macbook on 07/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

struct Data {
    let section1 = ["s3 row1", "s3 row2"]
    let section2 = ["s2 row1", "s2 row2"]
    let section3 = ["s1 row1", "s1 row2", "s1 row3", "s1 row4", "s1 row5", "s1 row6", "s1 row7", "s1 row8", "s1 row9", "s1 row10", "s1 row11"]
    let section4 = ["s4 row1", "s4 row2"]
    let section5 = ["s5 row1", "s5 row2"]
    let section6 = ["s6 row1", "s6 row2"]
    let section7 = ["s7 row1", "s7 row2"]
    var allInfo = [[String]]()
    
    init() {
        allInfo = [section1, section2, section3, section4, section5, section6, section7]
    }
}
