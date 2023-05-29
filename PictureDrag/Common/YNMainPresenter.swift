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

typealias YNButtonTapCompletion = (UIView) -> Void

class YNMainPresenter : YNMainPresenterDelegate {
    weak var navDelegate : YNMainPresenterDelegate?
    weak var interactor : YNInteractor?
    
    init(navDelegate: YNMainPresenterDelegate, interactor : YNInteractor) {
        self.navDelegate = navDelegate
    }
    
    func setupMainController(_ controller : inout YNMainViewController) {
        // set buttons names
        
        // I could assign navDelegate to controller's delegate, but it would be against VIPER principle
        controller.presenterDelegate = self
        // setup buttons names
    }
    
    func setupShowResultsController(_ controller : inout YNShowResultsViewController) {
        // fetch data from interactor
        
    }
    
    
    // MARK: -
    // MARK: YNMainPresenterDelegate functions
    
    func buttonTapped(_ button : YNMainControllerButtonTapped) {
        self.navDelegate?.buttonTapped(button)
    }
    
}

