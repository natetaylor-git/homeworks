//
//  CardsCollectionView.swift
//  hw8
//
//  Created by nate.taylor_macbook on 07/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol CardsCollectionDelegate {
    func createDoneButton()
}

class CardsCollection: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data = Data().allInfo
    var delegate: CardsCollectionDelegate?
    var cardsCollectionPaddingY: CGFloat = 0 //100
    var changedCell: CardViewCell?
    var oldCellFrame: CGRect = .zero
    
    var cardsCollectionView: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = .groupTableViewBackground//UIColor.init(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        return collectionView
    }()
    
    init(offset yPadding: CGFloat) {
        super.init()
        
        self.cardsCollectionPaddingY = yPadding
        let screenBoundsSize = UIScreen.main.bounds.size
        let frame = CGRect(origin: CGPoint(x: 0, y: cardsCollectionPaddingY),
                           size: CGSize(width: screenBoundsSize.width,
                                        height: screenBoundsSize.height - cardsCollectionPaddingY))
        
        self.cardsCollectionView.contentInsetAdjustmentBehavior = .never
        self.cardsCollectionView.frame = frame
        //self.cardsCollectionView.layer.contents = UIImage(named: "BackgroundPicture")?.cgImage
        self.cardsCollectionView.dataSource = self
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.isDirectionalLockEnabled = true
        self.cardsCollectionView.register(CardViewCell.self, forCellWithReuseIdentifier: "cellId")
        self.cardsCollectionView.register(HeaderCell.self, forCellWithReuseIdentifier: "headerId")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var backgroundColor: UIColor
        switch indexPath.section {
        case 0: backgroundColor = .blue
        case 1: backgroundColor = .red
        case 3: backgroundColor = .brown
        default: backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        }
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerId", for: indexPath) as! HeaderCell
            //cell.isUserInteractionEnabled = false
            cell.label.text = data[indexPath.section][0]
            cell.addButton.backgroundColor = backgroundColor
            cell.addButton.tag = indexPath.section
            cell.addButton.addTarget(self, action: #selector(addNewCell(sender:)), for: .touchUpInside)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardViewCell
        cell.backgroundColor = backgroundColor
        
        cell.textView.text = data[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cardsCollectionView.cellForItem(at: indexPath) as! CardViewCell
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false
        
        self.changedCell = cell
        self.oldCellFrame = cell.frame
        
        self.presentCellFullScreen(with: cell)
    }
    
    func presentCellFullScreen(with cell: CardViewCell) {
        let viewFrame = cardsCollectionView.frame
        let paddingY: CGFloat = viewFrame.height / 20
        let paddingX: CGFloat = viewFrame.width / 20
        let offset = cardsCollectionView.contentOffset
        
        let newOrigin = CGPoint(x: viewFrame.origin.x + paddingX + offset.x,
                                y: viewFrame.origin.y - self.cardsCollectionPaddingY + paddingY + offset.y)
        
        cell.superview?.bringSubviewToFront(cell)
        
        UIView.animate(withDuration: 1.0, animations: {
            cell.frame = CGRect(origin: newOrigin,
                                size: CGSize(width: viewFrame.width - paddingX * 2,
                                             height: viewFrame.height - paddingY * 2))
            cell.layoutSubviews()
        }) { finished in
            cell.textView.isUserInteractionEnabled = true
            self.createDoneButton(on: cell)
        }
    }
    
    func createDoneButton(on cell: CardViewCell) {
        self.delegate?.createDoneButton()
    }
    
    func finishedCellEditing() {
        if let cell = self.changedCell {
            cell.textView.isUserInteractionEnabled = false
            let indexPath = self.cardsCollectionView.indexPath(for: cell)!
            data[indexPath.section][indexPath.row] = cell.textView.text
            
            UIView.animate(withDuration: 1.0, animations: {
                cell.frame = self.oldCellFrame
                cell.layoutSubviews()
            }) { (finished) in
                // to make zIndex = 1
               // self.cardsCollectionView.reloadData()
                cell.superview?.sendSubviewToBack(cell)
                cell.textView.setContentOffset(.zero, animated: false)
                self.cardsCollectionView.isScrollEnabled = true
                self.cardsCollectionView.allowsSelection = true
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item == 0 {
            return false
        } else {
            return true
        }
    }
    
    @objc func addNewCell(sender: UIButton) {
        let section = sender.tag
        
        // добавление в конец
        //let numberOfItems = cardsCollectionView.numberOfItems(inSection: section)
        let indexPath = IndexPath(item: 1, section: section)
        self.cardsCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        
        // this method groups operations with collectionview
        self.cardsCollectionView.performBatchUpdates({
            data[section].insert("new cell", at: indexPath.item)
            let layout = self.cardsCollectionView.collectionViewLayout as! CustomCollectionViewLayout
            layout.update = true
            self.cardsCollectionView.insertItems(at: [indexPath])
            self.cardsCollectionView.reloadData()
        }, completion:// nil )
        {
            finished in
            if let cell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardViewCell {
                self.changedCell = cell
                self.oldCellFrame = cell.frame
                self.presentCellFullScreen(with: cell)
            } else {
                print("новая ячейка не показалась на редактирование", indexPath)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//        let visibleCells = cardsCollectionView.visibleCells
//
//
//        let maxItemNumber = cardsCollectionView.indexPathsForVisibleItems.map{ $0.item }.max()
//        let visibleCell = cardsCollectionView.indexPathsForVisibleItems[0]
//
//        if let max = maxItemNumber {
//            if cardsCollectionView.frame.height > CGFloat(max + 1) * cardsCollectionView.cellForItem(at: IndexPath(item: visibleCell.item, section: visibleCell.section))!.frame.height {
//                print("here")
//            }
//        }
//
//        print(cardsCollectionView.visibleSize)
//    }
