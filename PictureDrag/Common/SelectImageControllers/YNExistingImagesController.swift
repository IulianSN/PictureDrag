//
//  YNExistingImagesController.swift
//  PictureDrag
//
//  Created by Ulian on 19.06.2023.
//

import UIKit

protocol YNExistingImagesControllerProtocol : AnyObject {
    func updateViews()
}

class YNExistingImagesController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var deleteButton : UIButton!
    @IBOutlet private weak var startButton : YNNoImageButton!
    @IBOutlet private weak var imagesCollectionView : UICollectionView!
    @IBOutlet private weak var noImagesLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var selectedImage : UIImage?
    private var unselectedImage : UIImage?
    private var placeholderImage : UIImage?
    
    weak var setupDataSource : YNPreselectedImagesControllerDataSource?
    weak var imagesDataSource : YNImagesListDataSource?
    weak var delegate : YNSelectImageDelegate?
    weak var successDelegate : YNContinueWithImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate?.updateData()
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate?.cleanData()
        #warning("Notify delegate (if continued with selected image) to remove controller from navController.viewControllers. && MB use navController delegate methods.")
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: -
    // MARK: Private functions
    
    func setUpViews() {
        // as size classes do not work for iPad portrait/landscape, modify constraints manually. Once.
        guard let source = self.setupDataSource else {
            assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
            return
        }
        func setStandardCornerRadius(_ view : UIView) {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 6.0
        }
        
        let tintColor = source.buttonHighlightedColor
        
        self.titleLabel.text = source.screenTitle
        
        self.selectedImage = source.celectedImage
        self.unselectedImage = source.uncelectedImage
        self.placeholderImage = source.placeholderImage
        
        self.noImagesLabel.text = source.noImagesTitle
        self.showNoImagesLabelIfNeeded()

        self.enableDeleteBlockIfNeeded()
        self.deleteButton.setTitle("", for: .normal)
        self.deleteButton.setImage(source.deletePhotoImage, for: .normal)
        self.deleteButton.setImage(source.deletePhotoImage?.withTintColor(tintColor), for: .highlighted) // mb I should take this image from source as well
        setStandardCornerRadius(self.deleteButton)
        
        self.cancelButton.setTitle(source.cancelTitle, for: .normal)
        self.cancelButton.backgroundColor = source.solidButtonColor
        self.cancelButton.setTitleColor(source.solidButtonTextColor, for: .normal)
        self.cancelButton.setTitleColor(tintColor, for: .highlighted)
        setStandardCornerRadius(self.cancelButton)
        
        self.startButton.title = source.startButtonTitle
        self.startButton.setupColors(tintColor: source.solidButtonColor,
                                     textColor : source.textColor,
                                     touchColor: source.colorOnTouch,
                                     disabledColor: source.colorDisabled)
        self.startButton.onTap {[weak self] _ in
            self?.notifyDelegateStartTapped()
        }
        self.enableStartButtonIfNeeded()
    }
    
    private func notifyDelegateStartTapped() {
        if let model = self.imagesDataSource?.imgModelToContinue {
            self.successDelegate?.continueWith(imageModel: model)
        }
        // show error alert ??
    }
    
    private func enableDeleteBlockIfNeeded() {
        guard let imgSource = self.imagesDataSource else {
            assertionFailure("\(Self.self): unexpectedly found imagesDataSource to be nil")
            return
        }
        guard let source = self.setupDataSource else {
            assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
            return
        }
        let enableDelete = imgSource.isDeleteBlockEnabled()
        self.deleteButton.isEnabled = enableDelete
        self.deleteButton.backgroundColor = enableDelete ? source.solidButtonColor : source.colorDisabled
        self.cancelButton.alpha = enableDelete ? 1 : 0
    }
    
    private func enableStartButtonIfNeeded() {
        guard let imgSource = self.imagesDataSource else {
            assertionFailure("\(Self.self): unexpectedly found imagesDataSource to be nil")
            return
        }
        self.startButton.disabled = !imgSource.isContinueButtonEnabled()
    }
    
    private func updateViews() {
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
            self.enableDeleteBlockIfNeeded()
            self.enableStartButtonIfNeeded()
            self.showNoImagesLabelIfNeeded()
        }
    }
    
    private func updateCollection(forPath path : IndexPath) {
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadItems(at: [path])
        }
    }
    
    private func setupCell(_ cell : YNWholeImageCollectionViewCell, withPath path : IndexPath) {
        let id = path.row
        guard let paramSource = self.imagesDataSource else {
            assertionFailure("\(Self.self): unexpectedly found imagesDataSource to be nil")
            return
        }
        guard let source = self.setupDataSource else {
            assertionFailure("\(Self.self): unexpectedly found setupDataSource to be nil")
            return
        }
        
        cell.cellID = id
        if let img = paramSource.imageForID(id) {
            cell.mainImage = img
        } else {
            cell.mainImage = self.placeholderImage
            paramSource.fetchImageForIndex(id) {[weak self] success in
                if success {
                    self?.updateCollection(forPath: path)
                }
//                else {
                #warning("MB show description like 'smth went wrong'")
//                }
            }
//            cell.mainImage = img
        }
        cell.selectionColor = source.solidButtonColor
        
        let image : UIImage?
        switch (paramSource.deleteStateForID(id)) {
            case .noDeletionState : image = nil
            case .notSelectedToDelete : image = self.unselectedImage
            case .selectedToDelete : image = self.selectedImage
        }
        cell.selectForDeletImage = image
        
        cell.makeSelected = paramSource.isSelected(forID: id)
        
        cell.onTapCompletion {[weak self] cell in
            self?.delegate?.selectedImageIndex(id)
            self?.updateViews()
        }
        cell.onPressCompletion {[weak self] cell in
            self?.delegate?.cellPressed()
            self?.updateViews()
        }
    }
    
    private func showNoImagesLabelIfNeeded() {
        guard let paramSource = self.imagesDataSource else {
            assertionFailure("\(Self.self): unexpectedly found imagesDataSource to be nil")
            return
        }
        self.noImagesLabel.alpha = paramSource.showNoImagesLabel() ? 1 : 0
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func onDeleteTap(_ sender: UIButton) {
        self.delegate?.deleteTapped()
        self.updateViews()
    }
    
    @IBAction func onCancelTapped(_ sender: UIButton) {
        self.delegate?.endDeletionMode()
        self.updateViews()
    }
    
    // MARK: -
    // MARK: UICollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesDataSource?.numberOfImagesToShow ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = YNWholeImageCollectionViewCell.cellForIndexPath(indexPath, inCollectionView: collectionView) as! YNWholeImageCollectionViewCell
        self.setupCell(cell, withPath: indexPath)
        
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
        }
    }
}
