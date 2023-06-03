//
//  YNModels.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

struct YNResultsModel {
    var gamerName : String
    var dateString : String
    var gameResultTime: String
    var imageIdentifier : String
    
    var smallImage : UIImage? {
        get {
            if let image = YNBigImageModel(imageIdentifier: imageIdentifier).bigImage {
                return imageModifier.makeSmallImage(image)
            }
            return nil
        }
    }
    
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

struct YNBigImageModel {
    var imageIdentifier : String
    var bigImage : UIImage? {
        get {
            if let image = UserDefaults.standard.object(forKey: imageIdentifier) as? UIImage {
                return image
            }
            return nil
        }
    }
    
    init(imageIdentifier: String) {
        self.imageIdentifier = imageIdentifier
    }
}

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
