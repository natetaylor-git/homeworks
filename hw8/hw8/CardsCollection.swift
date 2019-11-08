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
    let cardsCollectionPaddingY: CGFloat = 60
    var changedCell: CardViewCell?
    var oldCellFrame: CGRect = .zero
    
    var cardsCollectionView: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        return collectionView
    }()
    
    override init() {
        super.init()
        
        let screenBoundsSize = UIScreen.main.bounds.size
        let frame = CGRect(origin: CGPoint(x: 0, y: cardsCollectionPaddingY),
                           size: CGSize(width: screenBoundsSize.width,
                                        height: screenBoundsSize.height - cardsCollectionPaddingY))
        self.cardsCollectionView.frame = frame
        //self.cardsCollectionView.layer.contents = UIImage(named: "BackgroundPicture")?.cgImage
        self.cardsCollectionView.dataSource = self
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.isDirectionalLockEnabled = true
        self.cardsCollectionView.register(CardViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardViewCell
        
        switch indexPath.section {
        case 0: cell.backgroundColor = .blue
        case 1: cell.backgroundColor = .red
        case 3: cell.backgroundColor = .brown
        default: cell.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        }
        
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
            //cell.textView.becomeFirstResponder()
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
                cell.textView.setContentOffset(.zero, animated: false)
                self.cardsCollectionView.isScrollEnabled = true
                self.cardsCollectionView.allowsSelection = true
            }
        }
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
