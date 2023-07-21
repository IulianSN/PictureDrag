//
//  YNDragPresenter.swift
//  PictureDrag
//
//  Created by Ulian on 17.07.2023.
//

import Foundation

protocol YNDradViewSettingsDataSource : AnyObject {
    
}

protocol YNDradViewDelegate : AnyObject {
    
}

class YNDragPresenter : YNDradViewSettingsDataSource, YNDradViewDelegate {
    var interactor : YNDragInteractor?
    
    
    
    // MARK: -
    // MARK: Initializer
    
    init(model : YNBigImageModel) {
        self.interactor = YNDragInteractor(imageModel: model)
//            self.selectImageScreenModel = self.imageInteractor.imageScreenModel()
    }
    
    func setupDragController(_ controller : inout YNDragViewController) {
        controller.settingsDataSource = self
        controller.uiActionsDelegate = self
        controller.dragDataSource = self.interactor
        controller.dragDelegate = self.interactor
    }
    
}
