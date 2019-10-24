//
//  TableDataSource.swift
//  hw6
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    
    let data = Store().data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellType0", for: indexPath) as! TableViewCell
        let cellInfo = data[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.detailTextLabel?.text = cellInfo.subText
            cell.detailTextLabel?.textColor = .gray
            cell.textLabel?.textColor = UIColor.init(red: 0, green: 122/255, blue: 1.0, alpha: 1.0)
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.imageView?.image = UIImage(named: "\(cellInfo.imageName)")
        cell.textLabel?.text = cellInfo.text
        
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
}
