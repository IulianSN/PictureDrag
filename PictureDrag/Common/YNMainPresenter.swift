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

typealias YNButtonTapCompletion = (UIView) -> Void

class YNMainPresenter : YNMainPresenterDelegate,
                        YNMainPresenterDataSource,
                        YNBestResultsDataSource
{
    weak var navDelegate : YNMainPresenterDelegate?
    weak var interactor : YNInteractor?
    
    var mainScreenModel : YNMainControllerSettingsModel
    var bestResultsModel : YNResultsScreenModel
    
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
    
    
    // MARK: -
    // MARK: YNMainPresenterDelegate functions
    
    func buttonTapped(_ button : YNMainControllerButtonTapped) {
        self.navDelegate?.buttonTapped(button)
    }
    
}

