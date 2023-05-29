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
            guard let image = UserDefaults.standard.object(forKey: imageIdentifier) as? UIImage else {
                assertionFailure("\(Self.self): wrong type of object")
                return nil
            }
            return image
        }
    }
    
    init(imageIdentifier: String) {
        self.imageIdentifier = imageIdentifier
    }
}
