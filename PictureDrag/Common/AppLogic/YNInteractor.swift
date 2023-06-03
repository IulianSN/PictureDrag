//
//  YNInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import Foundation

class YNInteractor {
    func mainScreenSettingsModel() -> YNMainControllerSettingsModel {
        let model = YNMainControllerSettingsModel()
        return model
    }
    
    func bestResultsScreenModel() -> YNResultsScreenModel {
        var model = YNResultsScreenModel()
        var modelArray = [YNResultsModel]()
        // mock results models
        let model1 = YNResultsModel(gamerName: "Yulian",
                                    dateString: "06.03.2023",
                                    gameResultTime: "12.4",
                                    imageIdentifier: "ASFDG-KUHDKJG")
        modelArray.append(model1)
        let model2 = YNResultsModel(gamerName: "Ivan",
                                    dateString: "06.03.2023",
                                    gameResultTime: "11.1",
                                    imageIdentifier: "ASFDG-KUHDerG")
        modelArray.append(model2)
        let model3 = YNResultsModel(gamerName: "Yulian",
                                    dateString: "06.03.2023",
                                    gameResultTime: "15.4",
                                    imageIdentifier: "ASFDG-KUHUIJG")
        modelArray.append(model3)
        let model4 = YNResultsModel(gamerName: "Ivan",
                                    dateString: "06.03.2023",
                                    gameResultTime: "10.2",
                                    imageIdentifier: "ASFDG-KUHDPOG")
        modelArray.append(model4)
        modelArray.sort(by: { return $0.gameResultTime < $1.gameResultTime })
        
        model.gameResultsModels = modelArray
        // fetch core data results, fill YNResultsModel(s)
        return model
    }
//    func setResults
}
