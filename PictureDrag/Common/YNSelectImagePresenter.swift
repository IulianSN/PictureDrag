//
//  YNSelectImagePresenter.swift
//  PictureDrag
//
//  Created by Ulian on 26.06.2023.
//

import UIKit

protocol YNPreselectedImagesControllerDataSource : AnyObject { // YNPickImagePresenter
    var screenTitle : String {get}
    var startButtonTitle : String {get}
    var noImagesTitle : String {get}
    var cancelTitle : String {get}
    var deletePhotoImage : UIImage? {get}
    var celectedImage : UIImage? {get}
    var uncelectedImage : UIImage? {get}
    var placeholderImage : UIImage? {get}
    var solidButtonColor : UIColor {get}
    var solidButtonTextColor : UIColor {get}
    var colorOnTouch : UIColor {get}
    var colorDisabled : UIColor {get}
    var textColor : UIColor {get}
    var buttonHighlightedColor : UIColor {get}
}

class YNSelectImagePresenter : YNPreselectedImagesControllerDataSource {
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
    var noImagesTitle : String {
        self.selectImageScreenModel.noImagesTitle
    }
    var cancelTitle : String {
        self.selectImageScreenModel.cancelButtonTitle
    }
    var deletePhotoImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.deleteImageName)
    }
    var celectedImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.celectedImageName)?.withTintColor(self.selectImageScreenModel.solidButtonColor)
    }
    var uncelectedImage : UIImage? {
        UIImage(named: self.selectImageScreenModel.uncelectedImageName)?.withTintColor(self.selectImageScreenModel.solidButtonColor)
    }
    var placeholderImage : UIImage? {
        UIImage(named:self.selectImageScreenModel.placeholderImageName)?.withTintColor(UIColor.systemGray6)
    }
    var solidButtonColor : UIColor {
        self.selectImageScreenModel.solidButtonColor
    }
    var solidButtonTextColor: UIColor {
        self.selectImageScreenModel.solidButtonTextColor
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
}
