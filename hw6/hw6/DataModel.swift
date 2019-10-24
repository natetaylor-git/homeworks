//
//  TableDataModel.swift
//  hw6
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class cellData: NSObject {
    let imageName: String
    var text: String
    var subText: String?
    
    init(_ imageName: String, _ text: String, _ subText: String? = nil) {
        self.imageName = imageName
        self.text = text
        self.subText = subText
    }
}

class Store {
    var data : [[cellData]]
    let section0 = [cellData("account", "Sign in to your IPhone", "Setup iCloud, the App Store, and more.")]
    let section1 = [cellData("general", "General"),
                   cellData("privacy", "Privacy")]
    let section2 = [cellData("security", "Passwords & Accounts")]
    let section3 = [cellData("maps", "Maps"),
                    cellData("safari", "Safari"),
                    cellData("news", "News"),
                    cellData("siri", "Siri"),
                    cellData("photos", "Photos"),
                    cellData("game", "Game Center")]
    let section4 = [cellData("developer", "Developer")]
    
// use it to check if cell reuse is correct
    let section5 = [cellData("maps", "Maps"),
                    cellData("safari", "Safari"),
                    cellData("news", "News"),
                    cellData("siri", "Siri"),
                    cellData("photos", "Photos"),
                    cellData("game", "Game Center")]
    let section6 = [cellData("maps", "Maps"),
                    cellData("safari", "Safari"),
                    cellData("news", "News"),
                    cellData("siri", "Siri"),
                    cellData("photos", "Photos"),
                    cellData("game", "Game Center")]
    let section7 = [cellData("maps", "Maps"),
                    cellData("safari", "Safari"),
                    cellData("news", "News"),
                    cellData("siri", "Siri"),
                    cellData("photos", "Photos"),
                    cellData("game", "Game Center")]
    
    init() {
        data = [section0, section1, section2, section3, section4] //, section5, section6, section7]
    }
    
}
