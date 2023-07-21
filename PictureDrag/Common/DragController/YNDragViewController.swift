//
//  YNDragViewController.swift
//  PictureDrag
//
//  Created by Ulian on 17.07.2023.
//

import UIKit

class YNDragViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var labelViewTrailConstraint: NSLayoutConstraint!
    @IBOutlet private weak var colViewLeadConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelToColVertConstraint: NSLayoutConstraint!
    
    var settingsDataSource : YNDradViewSettingsDataSource?
    var uiActionsDelegate : YNDradViewDelegate?
    var dragDataSource : YNDradDataSource?
    var dragDelegate : YNDradDelegate?
    
    var horizontalLabToColConstraint : NSLayoutConstraint?
    
    // MARK: -
    // MARK: Life cyckle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: -
    // MARK: Private
    
    private func setUpViews() {
        
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
//            var activateForLandscape = true
            if UIDevice.current.orientation.isPortrait {
//                activateForLandscape = false
                NSLayoutConstraint.deactivate([self.labelViewTrailConstraint, self.colViewLeadConstraint, self.labelToColVertConstraint])
                if let constraint = self.horizontalLabToColConstraint {
                    NSLayoutConstraint.activate([self.horizontalLabToColConstraint!])
                } else {
                    self.horizontalLabToColConstraint = self.containerView.addHorizontalConstraint(constant: 24, relation: .equal, toView: self.imagesCollectionView)
                }
            } else {
                if let constraint = self.horizontalLabToColConstraint {
                    NSLayoutConstraint.deactivate([constraint])
                }
                NSLayoutConstraint.activate([self.labelViewTrailConstraint, self.colViewLeadConstraint, self.labelToColVertConstraint])
            }
            self.view.layoutIfNeeded()
//            self.labelViewTrailConstraint
            
            // labelViewTrailConstraint
            // colViewLeadConstraint
            // labelToColVertConstraint
            
            // horizontalLabToColConstraint
            
            self.imagesCollectionView.reloadData()
            //
        }
    }
}
