//
//  YNSelectImageFromPhotos.swift
//  PictureDrag
//
//  Created by Ulian on 03.06.2023.
//

import UIKit
import Photos
import PhotosUI

class YNSelectImageFromGaleryController : UIViewController, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet private weak var mainContainerView: UIView! // set gray color
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var startButton: YNNoImageButton!
    
    @IBOutlet private weak var takePhotoButton: UIButton!
    @IBOutlet private weak var selectImageButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel! // use custom label
    
    private var takenImage : UIImage?
    private weak var frameView : YNDragableView?
    
    weak var setupDataSource : YNImageFromGaleryDataSource?
    weak var continueDataSource : YNEnablePickImageButtonsDataSource?
    weak var delegate : YNInteractorDelegate?
    weak var successDelegate : YNContinueWithImageDelegate?
    
    private var dragDirectionVertical = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set 'go back' text color
        self.setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
        
#warning("Notify delegate (if continued with selected image) to remove controller from navController.viewControllers. && MB use navController delegate methods.")
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
        guard let continueDataSource = self.continueDataSource else {
            assertionFailure("\(Self.self): unexpectedly found continueDataSource to be nil")
            return
        }
        let tintColor = source.buttonHighlightedColor
        let cameraAvailable = continueDataSource.isTakePhotoButtonEnabled()
        
        self.titleLabel.text = source.screenTitle
        
        self.takePhotoButton.isEnabled = cameraAvailable
        self.takePhotoButton.setTitle("", for: .normal)
        self.takePhotoButton.setImage(source.takePhotoImage, for: .normal)
        self.takePhotoButton.setImage(source.takePhotoImage?.withTintColor(tintColor), for: .highlighted)
        self.takePhotoButton.backgroundColor = cameraAvailable ? source.solidButtonColor : source.colorDisabled
        self.takePhotoButton.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], withRadius: 6.0)
        
        self.selectImageButton.setTitle("", for: .normal)
        self.selectImageButton.setImage(source.selectPhotoImage, for: .normal)
        self.selectImageButton.setImage(source.selectPhotoImage?.withTintColor(tintColor), for: .highlighted)
        self.selectImageButton.backgroundColor = source.solidButtonColor
        self.selectImageButton.roundCorners([.layerMaxXMinYCorner, .layerMaxXMaxYCorner], withRadius: 6.0)
        
        self.mainContainerView.backgroundColor = source.colorGrayBackground
        
        self.startButton.title = source.startButtonTitle
        self.startButton.setupColors(tintColor: source.solidButtonColor,
                                     textColor : source.textColor,
                                     touchColor: source.colorOnTouch,
                                     disabledColor: source.colorDisabled)
        self.startButton.onTap { _ in
            self.notifyDelegateStartTapped()
        }
        self.enableStartButtonIfNeeded()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGreen
    }
    
    private func showImagePickerController(takePhoto : Bool) {
        DispatchQueue.main.async {
            /**
             using PHPickerViewController to fetch photo from library and UIImagePickerController for taking photo.
             I could use UIImagePickerController for both operations, but wanted to chekc how newer technology works
             P.S. had to increase min iOS ver to 14.0
             */
            if takePhoto {
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .camera
                pickerController.allowsEditing = true
                pickerController.delegate = self
                self.presentAnimatedViewController(pickerController)
                #warning("show rotating animation ?? It appears just in 2-3 sec")
            } else {
                var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
                phPickerConfig.selectionLimit = 1
                phPickerConfig.filter = .images
                let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
                phPickerVC.delegate = self
                self.presentAnimatedViewController(phPickerVC)
                #warning("show rotating animation ?? It appears just in 2-3 sec")
            }
        }
    }
    
    private func enableStartButtonIfNeeded() {
        guard let continueDataSource = self.continueDataSource else {
            assertionFailure("\(Self.self): unexpectedly found continueDataSource to be nil")
            return
        }
        self.startButton.disabled = !continueDataSource.enableContinueButtonForKeyComponentSelected(self.takenImage != nil)
    }
    
    private func presentAnimatedViewController(_ controller : UIViewController) {
        self.present(controller, animated: true)
    }
    
    private func applyImage(_ image : UIImage) {
        DispatchQueue.main.async {
            self.takenImage = image
            self.imageView.image = image
            self.delegate?.newImageSelected()
            self.makeFrameForImage()
            self.enableStartButtonIfNeeded()
        }
    }
    
    private func moveToNextPositionWihtPoint(_ point : CGPoint) {
        guard let frameView = self.frameView else {
            assertionFailure("\(Self.self): unexpectedly found frameView to be nil")
            return
        }
        guard let image = self.imageView.image else {
            return
        }
        guard let delegate = self.delegate else {
            assertionFailure("\(Self.self): unexpectedly found delegate to be nil")
            return
        }
        
        let rect = delegate.calculateNextPositionWihtPoint(point,
                                       selectionViewFrame: frameView.frame,
                                          imageViewBounds: self.imageView.bounds,
                                                imageSize: image.size)

        DispatchQueue.main.async {
            self.frameView?.frame = rect
        }
    }
    
    // TMP make it here, later move to Presenter
    private func makeFrameForImage() {
        guard let image = self.imageView.image else {
            self.enableStartButtonIfNeeded()
            return
        }
        guard let delegate = self.delegate else {
            assertionFailure("\(Self.self): unexpectedly found delegate to be nil")
            return
        }
        
        self.imageView.isUserInteractionEnabled = true
        self.frameView?.removeFromSuperview() // if another image picked, remove previous selection zone
        self.mainContainerView.layoutIfNeeded()

        let frameForView = delegate.calculateSelectionFrame(imageViewBounds: self.imageView.bounds, imageSize: image.size)
        
        let frameView = YNDragableView(frame: frameForView)
        frameView.onTouchMove { point in
            self.moveToNextPositionWihtPoint(point)
        }
        
        frameView.layer.addSublayer({
            let border = CAShapeLayer()
            border.strokeColor = UIColor.systemRed.cgColor
            border.lineDashPattern = [12, 20]
            border.frame = frameView.bounds
            border.lineWidth = 3.0
            border.fillColor = nil
            border.path = UIBezierPath(rect: frameView.bounds).cgPath
            
            let animation = CABasicAnimation(keyPath: "lineDashPhase")
            animation.fromValue = 0
            animation.toValue = 8
            animation.duration = 0.2
            animation.isCumulative = true
            animation.repeatCount = Float.greatestFiniteMagnitude
            border.add(animation, forKey: "lineDashPhase")
            return border
        }())
        
        self.frameView = frameView
        self.imageView.addSubview(frameView)
    }
    
    private func notifyDelegateStartTapped() {
        guard let image = self.imageView.image else {
            self.enableStartButtonIfNeeded()
            return
        }
        guard let delegate = self.delegate else {
            assertionFailure("\(Self.self): unexpectedly found delegate to be nil")
            return
        }
        guard let selectionView = self.frameView else {
            assertionFailure("\(Self.self): unexpectedly found frameView to be nil")
            return
        }
        
        let (success, model) = delegate.saveSelectedImage(image, imageViewBounds: self.imageView.bounds, selectionFrame: selectionView.frame)
        
        if success {
            self.successDelegate?.continueWith(imageModel: model!) // continue game
        } // show alert that smth went wrong??
    }
    
    // MARK: -
    // MARK: IBActions
    
    @IBAction func takePhotoTapped(sender : UIButton) {
        showImagePickerController(takePhoto: true)
    }
    
    @IBAction func selectImageTapped(sender : UIButton) {
        showImagePickerController(takePhoto: false)
    }
    
    // MARK: -
    // MARK: UIImagePickerControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        if !results.isEmpty {
            let result = results[0]
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self.applyImage(image)
            }
        }
    }
    
    // MARK: -
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
        }
        self.applyImage(image)
    }
    
    // MARK: -
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
#warning("hide rotating animation if needed")
    }
    
    // MARK: -
    // MARK: Selectors
    
    @objc func rotated() {
        if self.takenImage == nil { // don't calculate rotations if there is no image
            return
        }
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
        
        DispatchQueue.main.async {
            self.frameView?.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.makeFrameForImage()
        }
    }
}
