//
//  YNSelectImageFromPhotos.swift
//  PictureDrag
//
//  Created by Ulian on 03.06.2023.
//

import UIKit

class YNSelectImageFromGaleryController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var mainContainerView: UIView! // set gray color
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var startButton: YNNoImageButton!
    
    @IBOutlet private weak var takePhotoButton: UIButton!
    @IBOutlet private weak var selectImageButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel! // use custom label
    
    private var takenImage : UIImage?
    private var editedImage : UIImage?
    
    weak var setupDataSource : YNImageFromGaleryDataSource?
    weak var continueDataSource : YNEnableContinueButtonDataSource?
//    weak var delegate :
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set 'go back' text color
        self.setUpViews()
        
        

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
        
        self.titleLabel.text = source.screenTitle
// tmp here, than move to presenter
        let cameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front)
        //
        self.takePhotoButton.setTitle("", for: .normal)
        self.takePhotoButton.setImage(source.takePhotoImage, for: .normal)
        self.takePhotoButton.setImage(source.takePhotoImage?.withTintColor(tintColor), for: .highlighted)
        self.takePhotoButton.backgroundColor = source.solidButtonColor
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
        
        self.startButton.disabled = !continueDataSource.enableContinueButtonForKeyComponentSelected(self.takenImage != nil)
        
//        navigationController?.navigationBar.barTintColor = UIColor.green
    }
    
    private func showImagePickerController(takePhoto : Bool) {
        DispatchQueue.main.async {
            
        }
        
        // move imagePickerController to Presenter
//        UIImagePickerController
//        let controller = UIImagePickerController()
//        if controller.isCameraDeviceAvailable {
//
//        }
        // isCameraDeviceAvailable
        // sourceType: UIImagePickerController.SourceType
//        controller.sourceType = .camera
//        controller.allowsEditing = true
//        controller.delegate = self
//        self.mainContainerView.addSubview(controller.view)
//        self.navigationController?.present(controller, animated: true)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
        
    }
    
    // MARK: -
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
}
