//
//  YNInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

class YNInteractor {
    func mainScreenSettingsModel() -> YNMainControllerSettingsModel {
        let model = YNMainControllerSettingsModel()
        return model
    }
    
    func bestResultsScreenModel() -> YNResultsScreenModel {
        var model = YNResultsScreenModel()
        var modelArray = [YNResultsModel]()
        // mock results models
//        let model1 = YNResultsModel(gamerName: "Yulian",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "12.4",
//                                    imageIdentifier: "ASFDG-KUHDKJG")
//        model1.smallImage = self.smallImageForIdentifier(model1.imageIdentifier)
//        modelArray.append(model1)
        
//        let model2 = YNResultsModel(gamerName: "Ivan",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "11.1",
//                                    imageIdentifier: "ASFDG-KUHDerG")
//        model2.smallImage = self.smallImageForIdentifier(model2.imageIdentifier)
//        modelArray.append(model2)
        
//        let model3 = YNResultsModel(gamerName: "Yulian",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "15.4",
//                                    imageIdentifier: "ASFDG-KUHUIJG")
//        model3.smallImage = self.smallImageForIdentifier(model3.imageIdentifier)
//        modelArray.append(model3)
        
//        let model4 = YNResultsModel(gamerName: "Ivan",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "10.2",
//                                    imageIdentifier: "ASFDG-KUHDPOG")
//        model4.smallImage = self.smallImageForIdentifier(model4.imageIdentifier)
//        modelArray.append(model4)
        
        modelArray.sort(by: { return $0.gameResultTime < $1.gameResultTime })
        
        model.gameResultsModels = modelArray
        // fetch core data results, fill YNResultsModel(s)
        return model
    }
    
    func selectImageScreenModel() -> YNPickImageControllerModel {
        let model = YNPickImageControllerModel()
        return model
    }
//    func setResults
    
    // MARK: -
    // MARK: Private functions
    
    private func smallImageForIdentifier(_ identifier : String) -> UIImage? {
        if let image = bigImageForIdentifier(identifier) {
            return imageModifier.makeSmallImage(image)
        }
        return nil
    }
    
    private func bigImageForIdentifier(_ identifier : String) -> UIImage? {
        if let image = UserDefaults.standard.object(forKey: identifier) as? UIImage {
            return image
        }
        return nil
    }
}
