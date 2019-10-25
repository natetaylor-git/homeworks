//
//  ViewController.swift
//  hw6
//
//  Created by nate.taylor_macbook on 22/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol TransferedData: class {
    var changedData: cellData? { get }
}

class ViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let tableDataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        self.tableView.frame = self.view.frame
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cellType0")
        
        self.tableView.dataSource = self.tableDataSource
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = CustomViewController()
        let rowText = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        nextViewController.title = rowText
        nextViewController.textView.text = rowText
        nextViewController.changedData = self.tableDataSource.data[indexPath.section][indexPath.row]

        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let labelWidth: CGFloat = 250

        let cellInfo = self.tableDataSource.data[indexPath.section][indexPath.row]
        let padding : CGFloat = 5

        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = cellInfo.text
        let textLabelSize = textLabel.sizeThatFits(CGSize(width: labelWidth,
                                                          height: CGFloat.greatestFiniteMagnitude))

        var subTextLabelHeight: CGFloat = 0
        if indexPath.section == 0 {
            let subTextLabel = UILabel()
            subTextLabel.font = UIFont.systemFont(ofSize: 12)
            subTextLabel.lineBreakMode = .byWordWrapping
            subTextLabel.numberOfLines = 0
            subTextLabel.text = cellInfo.subText
            subTextLabelHeight = subTextLabel.sizeThatFits(CGSize(width: labelWidth,
                                                                height: CGFloat.greatestFiniteMagnitude)).height + padding
        }

        let imageSide = CGFloat(32)
        let imgView = UIImageView()
        imgView.image = UIImage(named: "\(cellInfo.imageName)")
        imgView.frame.size = CGSize(width: imageSide, height: imageSide)
        
        print("t", textLabelSize.height)
        
        return max(imgView.frame.height + padding * 2,
                   textLabelSize.height + subTextLabelHeight + padding * 2)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let height: CGFloat = (section == 0) || (section == 3) ? 40:-1

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width,
                                              height: height))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != 0 && section != 3 else {
            return 40
        }
        return -1
    }
    
}


