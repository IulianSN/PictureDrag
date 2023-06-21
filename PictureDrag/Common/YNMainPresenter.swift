//
//  YNMainPresenter.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

protocol YNMainPresenterDelegate : AnyObject {
    func buttonTapped(_ button : YNMainControllerButtonTapped)
}

// make protocol to navigate further from YNSelectImageFromGaleryController && YNSelecUsedImagesController

protocol YNPickImagePresenterDelegate : AnyObject {
    // mb notify on viewDidDisappear && in mainNavigator remove controller from navController.viewControllers stack
//    func imageSelected() //
    func startTappedWithModel(_ model : YNBigImageModel) // Start tapped
}

protocol YNMainPresenterDataSource : AnyObject {
    var newImageButtonTitle : String { get }
    var existingImageButtonTitle : String { get }
    var seeResultsButtonTitle : String { get }
    var buttonHighlightedColour : UIColor { get }
}

protocol YNBestResultsDataSource : AnyObject {
    var screenTitle : String {get}
    var noResultsText : String {get}
    var showNoResultsText : Bool {get}
    
    var gameResultsModels : Array<YNResultsModel>? {get}
    
    func resultStringFormTimeString(_ time : String) -> String
}

protocol YNImageFromGaleryDataSource : AnyObject { // YNPickImagePresenter
    var screenTitle : String {get}
    var startButtonTitle : String {get}
    var takePhotoImage : UIImage? {get}
    var selectPhotoImage : UIImage? {get}
    var solidButtonColor : UIColor {get}
    var colorOnTouch : UIColor {get}
    var colorDisabled : UIColor {get}
    var textColor : UIColor {get}
    var buttonHighlightedColor : UIColor {get}
    var colorGrayBackground : UIColor {get}
}

protocol YNEnablePickImageButtonsDataSource : AnyObject {
    func enableContinueButtonForKeyComponentSelected(_ selected : Bool) -> Bool
    func isTakePhotoButtonEnabled() -> Bool
}

protocol YNPreselectedImagesControllerDataSource : AnyObject { // YNPickImagePresenter
    var screenTitle : String {get}
    var startButtonTitle : String {get}
    var deletePhotoImage : UIImage? {get}
    var solidButtonColor : UIColor {get}
    var colorOnTouch : UIColor {get}
    var colorDisabled : UIColor {get}
    var textColor : UIColor {get}
    var buttonHighlightedColor : UIColor {get}
}

protocol YNEnableSelectImageButtonsDataSource : AnyObject {
    func enableContinueButtonForKeyComponentSelected(_ selected : Bool) -> Bool
    func enableDeleteButtonForKeyComponentSelected(_ selected : Bool) -> Bool
}

typealias YNButtonTapCompletion = (UIView) -> Void
typealias YNTouchMoveClosure = (CGPoint) -> Void 

class YNMainPresenter : YNMainPresenterDelegate,
                        YNMainPresenterDataSource,
                        YNBestResultsDataSource
{
    weak var navDelegate : YNMainPresenterDelegate?
    weak var interactor : YNInteractor?
    
    private var mainScreenModel : YNMainControllerSettingsModel
    private var bestResultsModel : YNResultsScreenModel
    
    lazy var pickImagePresenter : YNPickImagePresenter = {
        YNPickImagePresenter()
    }()
    
    lazy var selectImagePresenter : YNSelectImagePresenter = {
        YNSelectImagePresenter()
    }()
    
    // MARK: -
    // MARK: YNMainPresenterDataSource accessors
    var newImageButtonTitle : String {
        return self.mainScreenModel.newImageButtonTitle
    }
    
    var existingImageButtonTitle : String {
        return self.mainScreenModel.existingImageButtonTitle
    }
    
    var seeResultsButtonTitle : String {
        return self.mainScreenModel.seeResultsButtonTitle
    }
    
    var buttonHighlightedColour : UIColor {
        return self.mainScreenModel.colorOnTouch
    }
    
    // MARK: -
    // MARK: YNBestResultsDataSource properties
    
    var screenTitle : String {
        return self.bestResultsModel.screenTitle
    }
    
    var noResultsText : String {
        return self.bestResultsModel.noResultsText
    }
    
    var showNoResultsText : Bool {
        if let models = self.bestResultsModel.gameResultsModels {
            return models.isEmpty
        }
        return true
    }
    
    var gameResultsModels : Array<YNResultsModel>? {
        return self.bestResultsModel.gameResultsModels
    }
    
    func resultStringFormTimeString(_ time : String) -> String {
        return time + " " + "sec"// 12.0 sec
    }
    
    // MARK: -
    // MARK: Initializer
    
    init(navDelegate: YNMainPresenterDelegate, interactor : YNInteractor) {
        self.navDelegate = navDelegate
        self.interactor = interactor
        
        self.mainScreenModel = interactor.mainScreenSettingsModel()
        self.bestResultsModel = interactor.bestResultsScreenModel()
    }
    
    // MARK: -
    // MARK: Public functions
    
    func setupMainController(_ controller : inout YNMainViewController) {
        // I could assign navDelegate to controller's delegate, but it would be against VIPER principle IMO
        controller.presenterDelegate = self
        controller.dataSource = self
    }
    
    func setupShowResultsController(_ controller : inout YNShowResultsViewController) {
        if let interactor = self.interactor {
            self.bestResultsModel = interactor.bestResultsScreenModel()
            controller.dataSource = self
        }
    }
    
    func setupSelectNewImageController(_ controller : inout YNSelectImageFromGaleryController) {
        self.pickImagePresenter.setupSelectNewImageController(&controller)
    }
    
    func setupSelectedImagesController(_ controller : inout YNExistingImagesController) {
        self.selectImagePresenter.setupSelectNewImageController(&controller)
    }
    
    // MARK: -
    // MARK: YNMainPresenterDelegate functions
    
    func buttonTapped(_ button : YNMainControllerButtonTapped) {
        self.navDelegate?.buttonTapped(button)
    }
    
}


// MARK: -
// MARK: DataSource properties and functions

extension YNMainPresenter  { // DataSource properties and functions move here

}

// MARK: -
// MARK: YNSelectImagePresenter

class YNSelectImagePresenter : YNEnableSelectImageButtonsDataSource, YNPreselectedImagesControllerDataSource {
    var imageInteractor : YNSelectImageInteractor
    var selectImageScreenModel : YNSelectedImagesControllerModel
    
    // MARK: -
    // MARK: Initializer
    
    init() {
        self.imageInteractor = YNSelectImageInteractor()
        self.selectImageScreenModel = self.imageInteractor.imageScreenModel()
    }
    
    func setupSelectNewImageController(_ controller : inout YNExistingImagesController) {
        controller.setupDataSource = self
        controller.enableButtonsDataSource = self
        controller.imagesDataSource = self.imageInteractor
        controller.delegate = self.imageInteractor
    }
    
    // MARK: -
    // MARK: YNPreselectedImagesControllerDataSource
    
    var screenTitle : String {
        self.selectImageScreenModel.title
    }
    var startButtonTitle : String {
        self.selectImageScreenModel.startTitle
    }
    var deletePhotoImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.deleteImageName)
    }
    var solidButtonColor : UIColor {
        self.selectImageScreenModel.solidButtonColor
    }
    var colorOnTouch : UIColor {
        self.selectImageScreenModel.colorOnTouch
    }
    var colorDisabled : UIColor {
        self.selectImageScreenModel.colorDisabled
    }
    var textColor : UIColor {
        self.selectImageScreenModel.textColor
    }
    var buttonHighlightedColor : UIColor {
        self.selectImageScreenModel.imageHighlighted
    }
    
    // MARK: -
    // MARK: YNEnableContinueButtonDataSource
    
    func enableContinueButtonForKeyComponentSelected(_ selected : Bool) -> Bool {
        selected
    }
    
    func enableDeleteButtonForKeyComponentSelected(_ selected : Bool) -> Bool {
        selected
    }
}

// MARK: -
// MARK: YNPickImagePresenter

class YNPickImagePresenter : YNImageFromGaleryDataSource, YNEnablePickImageButtonsDataSource  {
    var imageInteractor : YNTakeImageInteractor
    var selectImageScreenModel : YNPickImageControllerModel
    
    // MARK: -
    // MARK: Initializer
    
    init() {
        self.imageInteractor = YNTakeImageInteractor()
        self.selectImageScreenModel = self.imageInteractor.selectImageScreenModel()
    }
    
    // MARK: -
    // MARK: YNImageFromGaleryDataSource
    
    var screenTitle : String {
        self.selectImageScreenModel.title
    }

    var startButtonTitle : String {
        self.selectImageScreenModel.startTitle
    }

    var takePhotoImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.takePhotoImageName)
    }

    var selectPhotoImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.selectPhotoImageName)
    }

    var solidButtonColor : UIColor {
        self.selectImageScreenModel.solidButtonColor
    }

    var colorOnTouch : UIColor {
        self.selectImageScreenModel.colorOnTouch
    }
    
    var textColor : UIColor {
        self.selectImageScreenModel.textColor
    }
    
    var buttonHighlightedColor : UIColor {
        self.selectImageScreenModel.imageHighlighted
    }

    var colorDisabled : UIColor {
        self.selectImageScreenModel.colorDisabled
    }
    
    var colorGrayBackground: UIColor {
        self.selectImageScreenModel.lightGrayBackground
    }
    
    // MARK: -
    // MARK: YNEnableContinueButtonDataSource
    
    func enableContinueButtonForKeyComponentSelected(_ selected : Bool) -> Bool {
        selected
    }
    
    func isTakePhotoButtonEnabled() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    // MARK: -
    // MARK: Public functions
    
    func setupSelectNewImageController(_ controller : inout YNSelectImageFromGaleryController) {
        controller.setupDataSource = self
        controller.continueDataSource = self
        controller.delegate = self.imageInteractor
    }
}
