//
//  YNExistingImagesController.swift
//  PictureDrag
//
//  Created by Ulian on 19.06.2023.
//

import UIKit

class YNExistingImagesController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var startButton : YNNoImageButton!
    @IBOutlet weak var imagesCollectionView : UICollectionView!
    
    private var images : [YNBigImageModel] {
        get {
            guard let source = self.imagesDataSource else {
                assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
                return [YNBigImageModel]()
            }
            return source.imagesToShow()
        }
    }
    
    weak var setupDataSource : YNPreselectedImagesControllerDataSource?
    weak var enableButtonsDataSource : YNEnableSelectImageButtonsDataSource?
    weak var imagesDataSource : YNImagesListDataSource?
    weak var delegate : YNSelectImageDelegate?
    
    var selectedModel : YNBigImageModel?
    lazy var idsToDelete = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: -
    // MARK: Private functions
    
    func setUpViews() {
        // as size classes do not work for iPad portrait/landscape, modify constraints manually. Once.
        guard let source = self.setupDataSource else {
            assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
            return
        }
        guard let continueDataSource = self.enableButtonsDataSource else {
            assertionFailure("\(Self.self): unexpectedly found continueDataSource to be nil")
            return
        }
        let tintColor = source.buttonHighlightedColor
        let enableDelete = continueDataSource.enableDeleteButtonForKeyComponentSelected(!self.idsToDelete.isEmpty)
        
        self.titleLabel.text = source.screenTitle

        self.enableDeleteButtonIfNeeded()
        self.deleteButton.setTitle("", for: .normal)
        self.deleteButton.setImage(source.deletePhotoImage, for: .normal)
        self.deleteButton.setImage(source.deletePhotoImage?.withTintColor(tintColor), for: .highlighted)
        self.deleteButton.layer.masksToBounds = true
        self.deleteButton.layer.cornerRadius = 6.0
        
        self.startButton.title = source.startButtonTitle
        self.startButton.setupColors(tintColor: source.solidButtonColor,
                                     textColor : source.textColor,
                                     touchColor: source.colorOnTouch,
                                     disabledColor: source.colorDisabled)
        self.startButton.onTap { _ in
            self.notifyDelegateStartTapped()
        }
        self.enableStartButtonIfNeeded()
    }
    
    private func notifyDelegateStartTapped() {
        
    }
    
    private func enableDeleteButtonIfNeeded() {
        guard let enableButtonsDataSource = self.enableButtonsDataSource else {
            assertionFailure("\(Self.self): unexpectedly found continueDataSource to be nil")
            return
        }
        guard let source = self.setupDataSource else {
            assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
            return
        }
        let enableDelete = enableButtonsDataSource.enableDeleteButtonForKeyComponentSelected(!self.idsToDelete.isEmpty)
        self.deleteButton.isEnabled = enableDelete
        self.deleteButton.backgroundColor = enableDelete ? source.solidButtonColor : source.colorDisabled
    }
    
    private func enableStartButtonIfNeeded() {
        guard let enableButtonsDataSource = self.enableButtonsDataSource else {
            assertionFailure("\(Self.self): unexpectedly found continueDataSource to be nil")
            return
        }
        self.startButton.disabled = !enableButtonsDataSource.enableContinueButtonForKeyComponentSelected(self.selectedModel != nil)
    }
    
    // MARK: -
    // MARK: UICollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count//3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = YNWholeImageCollectionViewCell.cellForIndexPath(indexPath, inCollectionView: collectionView)
//        collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! YNWholeImageCollectionViewCell
        
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
            self.imagesCollectionView.reloadData()
//            self.frameView?.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.makeFrameForImage()
        }
    }
}
