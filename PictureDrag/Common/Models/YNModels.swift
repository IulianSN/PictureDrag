//
//  YNModels.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

// MARK: -
// MARK: Data models

struct YNResultsModel {
    var gamerName : String
    var dateString : String
    var gameResultTime: String
    var imageIdentifier : String
    var smallImage : UIImage?
    
    init(gamerName : String = "Unknown",
        dateString : String,
    gameResultTime : String,
   imageIdentifier : String)
    {
        self.gamerName = gamerName
        self.dateString = dateString
        self.gameResultTime = gameResultTime
        self.imageIdentifier = imageIdentifier
    }
}

class YNBigImageModel {
    var imageIdentifier : String
    var bigImage : UIImage?
    
    init(imageIdentifier: String) {
        self.imageIdentifier = imageIdentifier
    }
}

struct YNImageToDragModel {
    var initialIndex : Int
    let expectedIndex : Int
    let image : UIImage
}

// MARK: -
// MARK: Controllers content models

struct YNMainControllerSettingsModel {
    let newImageButtonTitle = "Select new image"
    let existingImageButtonTitle = "Select existing image"
    let seeResultsButtonTitle = "Best results"
    
    let colorOnTouch = appDesign.colorBackgroundHighlighted
}

struct YNResultsScreenModel {
    let screenTitle = "Best results"
    let noResultsText = "There is no results yet. Please play the game at least once!"
    
    var gameResultsModels : Array<YNResultsModel>?
}

struct YNPickImageControllerModel {
    let title = "Take a photo or select image"
    let startTitle = "Start!"
    
    let solidButtonColor = appDesign.borderColor
    let colorOnTouch = appDesign.colorBackgroundHighlighted
    let colorDisabled = appDesign.disabledButtonColor
    let lightGrayBackground = appDesign.lightGrayBackground
    let textColor = appDesign.borderColor
    let imageHighlighted = appDesign.imageHighlighted
    
    let takePhotoImageName = "take_a_photo"
    let selectPhotoImageName = "select_a_photo"
}

struct YNSelectedImagesControllerModel {
    let title = "Select one of the images or remove unneeded"
    let startTitle = "Start!"
    let noImagesTitle = "There is no mages yet. Please play a game at least once!"
    let cancelButtonTitle = "Cancel"
    
    let solidButtonColor = appDesign.borderColor
    let solidButtonTextColor = appDesign.solidButtonTextColor
    let colorOnTouch = appDesign.colorBackgroundHighlighted
    let colorDisabled = appDesign.disabledButtonColor
    let textColor = appDesign.borderColor
    let imageHighlighted = appDesign.imageHighlighted
    
    let deleteImageName = "delete_image"
    let placeholderImageName = "placeholder_image"
    let celectedImageName = "celected_image"
    let uncelectedImageName = "uncelected_image"
}
