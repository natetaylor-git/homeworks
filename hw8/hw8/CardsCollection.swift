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
    var cardsCollectionPaddingY: CGFloat = 0
    var changedCell: CardViewCell?
    var oldCellFrame: CGRect = .zero
    var changingCellState = false
    
    var cardsCollectionView: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = .groupTableViewBackground
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
        
        self.cardsCollectionView.dragDelegate = self
        self.cardsCollectionView.dropDelegate = self
        self.cardsCollectionView.dragInteractionEnabled = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let darkGreen = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        let colors: [UIColor] = [.blue,.red, .brown, darkGreen, .purple, .orange, .magenta]
        
        let backgroundColor: UIColor = colors[indexPath.section % colors.count]

        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerId", for: indexPath) as! HeaderCell
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
        self.changingCellState = true
        collectionView.dragInteractionEnabled = false
        
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
                
                cell.superview?.sendSubviewToBack(cell)
                cell.textView.setContentOffset(.zero, animated: false)
                self.cardsCollectionView.isScrollEnabled = true
                self.cardsCollectionView.allowsSelection = true
                self.changingCellState = false
                self.cardsCollectionView.dragInteractionEnabled = true
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
        if self.changingCellState {
            return
        }
        self.changingCellState = true
        
        let section = sender.tag
        self.cardsCollectionView.isScrollEnabled = false
        self.cardsCollectionView.allowsSelection = false
        self.cardsCollectionView.dragInteractionEnabled = false
        
        let indexPathToScroll = IndexPath(item: 0, section: section)
        self.cardsCollectionView.scrollToItem(at: indexPathToScroll, at: .bottom, animated: false)
        
        let indexPath = IndexPath(item: 1, section: section)
        self.cardsCollectionView.performBatchUpdates({
            data[section].insert("Type new task!", at: indexPath.item)
            self.cardsCollectionView.insertItems(at: [indexPath])
        }, completion: {
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let numberOfVisibleCardCells = self.cardsCollectionView.indexPathsForVisibleItems.filter{$0.item != 0}.count
//        if  numberOfVisibleCardCells == 0 {
//            self.cardsCollectionView.setContentOffset(CGPoint(x: cardsCollectionView.contentOffset.x, y: 0), animated: true)
//        }
//    }
}

extension CardsCollection: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CardViewCell {
            let object = cell.textView.text ?? ""
            let itemProvider = NSItemProvider(object: object as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            
            dragItem.localObject = object
            session.localContext = indexPath
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        if let context = session.localContext as? IndexPath {
            let index = IndexPath(item: 0, section: context.section)
            if let cell = collectionView.cellForItem(at: index) {
                cell.superview?.bringSubviewToFront(cell)
            }
        }
    }
}

extension CardsCollection: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.item == 0 {
                return
            }
            destinationIndexPath = indexPath
        } else {
            let endDragLocation = coordinator.session.location(in: collectionView)
            var section: Int = 0
            for cell in collectionView.visibleCells {
                let indexPath = collectionView.indexPath(for: cell)!
                if indexPath.item == 0 {
                    let range = cell.frame.minX ... cell.frame.maxX
                    if range.contains(endDragLocation.x) {
                        section = indexPath.section
                    }
                }
            }
            let item = collectionView.numberOfItems(inSection: section) + 1

            destinationIndexPath = IndexPath(item: item, section: section)
            guard let source = coordinator.items.first?.sourceIndexPath,
                source.section != destinationIndexPath.section else {
                return
            }
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.item >= collectionView.numberOfItems(inSection: dIndexPath.section) {
                dIndexPath.item -= 1
            }
            
            collectionView.performBatchUpdates({
                let textInfo = self.data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
                self.data[dIndexPath.section].insert(textInfo, at: dIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            
            coordinator.drop(item.dragItem, toItemAt: dIndexPath)
        }
    }
}
