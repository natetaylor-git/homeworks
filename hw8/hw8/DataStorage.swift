//
//  DataStorage.swift
//  hw8
//
//  Created by nate.taylor_macbook on 07/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

struct Data {
    let section1 = ["Section1", "s1 row2"]
    let section2 = ["Section2", "s2 row2"]
    let section3 = ["Section3", "s3 row2", "s3 row3", "s3 row4", "s3 row5", "s3 row6", "s3 row7", "s3 row8", "s3 row9", "s3 row10", "s3 row11"]
    let section4 = ["Section4", "s4 row2"]
    let section5 = ["Section5", "s5 row2"]
    let section6 = ["Section6", "s6 row2"]
    let section7 = ["Section7", "s7 row2"]
    var allInfo = [[String]]()
    
    init() {
        allInfo = [section1, section2, section3, section4, section5, section6, section7]
    }
}
