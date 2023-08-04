//
//  YNDragViewController.swift
//  PictureDrag
//
//  Created by Ulian on 17.07.2023.
//

import UIKit

class YNDragViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum YNRotationConstraintsEnum : Float {
        case portraitState = 600
        case landscape = 950
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var collectionViewWidthConst: NSLayoutConstraint!
    
#warning("Add image view to show original image")
    
    var settingsDataSource : YNDradViewSettingsDataSource?
    var uiActionsDelegate : YNDradViewDelegate?
    var dragDataSource : YNDradDataSource?
    var dragDelegate : YNDradDelegate?
    
    var orientationState : YNRotationConstraintsEnum {
        UIDevice.current.orientation.isPortrait ? .portraitState : .landscape
    }
#warning("start timer with dragDelegate. Notify controller with time changes (and update label)")
    var timer : Timer?
    var time = 0.0
    var successfullyFinished = false {
        didSet {
            // stop timer
            
        }
    }
    
    // MARK: -
    // MARK: Life cyckle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let minParam = min(self.view.bounds.size.width, self.view.bounds.size.height)
        self.collectionViewWidthConst.constant = minParam - 48 // 48 is width and right indents
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.updateViewsAfterRotation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {[weak self] _ in
            self?.onTimerFired()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func dealloc() {
//        self.timer?.invalidate()
        
        #warning("Check what owns the controller. Does not look like it is closure")
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: -
    // MARK: Private
    
    private func setUpViews() {
        self.timerLabel.text = "0.0"
    }
    
    private func onTimerFired() {
        self.time += 0.1
        self.timerLabel.text = String(format: "Angle: %.1f", self.time) //String(self.time) // round to 1.1
    }
    
    private func updateViewsAfterRotation() {
        guard let label = self.timerLabel else {
            assertionFailure("\(Self.self): could not get label as expected")
            return
        }
        label.removeFromSuperview()

        let container : UIView
        switch self.orientationState {
            case .portraitState: container = self.containerView
            case .landscape: container = self.leftContainerView
        }
        container.addSubview(label)
        label.addLeadConstraint(constant: 4, relation: .equal, inView: container)
        label.addTrailConstraint(constant: 4, relation: .equal, inView: container)
        label.addTopConstraint(constant: 24, relation: .equal, inView: container)

        self.view.layoutIfNeeded()
    }
    
    // MARK: -
    // MARK: UICollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsNo = self.dragDataSource?.itemsNo ?? 0
        return itemsNo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = YNDragViewCell.cellForIndexPath(indexPath, inCollectionView: collectionView) as! YNDragViewCell
        let img = self.dragDataSource![indexPath.row].image
        cell.image = img
//        self.setupCell(cell, withPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 4
//        print("cell width : \(width)")
        return CGSize(width: width, height: width)
    }
    
    // MARK: -
    // MARK: Selectors
    
    @objc func rotated() {
        DispatchQueue.main.async {
            self.updateViewsAfterRotation()
            self.imagesCollectionView.reloadData()
        }
    }
}

extension YNDragViewController : UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return !self.successfullyFinished
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
            
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let object = self.dragDataSource![indexPath.row]
        let itemProvider = NSItemProvider.init(object: object)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = object
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            guard let dragObj = item.dragItem.localObject as? YNDragableModel else {
                continue
            }
            
            let sourceIndex : IndexPath
            let aimIndex : IndexPath
            
            if let ip = coordinator.destinationIndexPath, let sourceIP = item.sourceIndexPath {
                sourceIndex = sourceIP
                aimIndex = ip
            } else {
                sourceIndex = IndexPath(row: dragObj.currentIndex, section: 0)
                aimIndex = IndexPath(row: dragObj.currentIndex, section: 0)
            }
            self.dragDelegate?.insertItem(withIndex: sourceIndex.row, toIndex: aimIndex.row)
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: [sourceIndex])
                collectionView.insertItems(at: [aimIndex])
            }
            coordinator.drop(item.dragItem, toItemAt: aimIndex)
            self.successfullyFinished = self.dragDataSource!.isSuccessfullyFinished()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }
        
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
//        // perform check and if all items on expected places - stop the game.
//    }
}
