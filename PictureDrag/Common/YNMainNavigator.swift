//
//  YNMainWireframe.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

class YNMainNavigator : YNMainPresenterDelegate {
    var mainPresenter : YNMainPresenter?
    var mainViewController : YNMainViewController?
    let mainInteractor = YNInteractor()
    var navigationController : UINavigationController?
    
    // MARK: -
    // MARK: Public functions
    
    func presentRootInterfaceFromWindow(_ window: UIWindow?) {
        guard let windowUnwrapped = window else {
//            assert(pupName != nil, "pupName variable is nil")
            assertionFailure("\(Self.self): unexpectedly found window to be nil")
            return
        }
        let viewController = YNMainViewController.controller(inStoryboard: mainStoryboard()) 
        guard var controller = viewController as? YNMainViewController else {
            assertionFailure("\(Self.self): unexpectedly found YNMainViewController to be nil")
            return
        }
        self.mainPresenter = YNMainPresenter(navDelegate: self, interactor: self.mainInteractor)
        self.mainPresenter?.setupMainController(&controller)
        self.mainViewController = controller
        guard let navController = windowUnwrapped.rootViewController as? UINavigationController else {
            assertionFailure("\(Self.self): unexpectedly found UINavigationController to be nil")
            return
        }
        #warning("set up navigationController (nav bar style, buttons color and so on) in presenter!")
//        self.navigationController?.navigationBar.barStyle = .black // setup style / 
        self.navigationController = navController
        navController.modalPresentationCapturesStatusBarAppearance = true
        navController.show(controller, sender: self)
    }
    
    // MARK: -
    // MARK: Private functions
    
    
    
    // MARK: -
    // MARK: Show controllers on button tapps
    
    private func showNewImageController() {
        let viewController = YNSelectImageFromGaleryController.controller(inStoryboard: mainStoryboard())
        guard var controller = viewController as? YNSelectImageFromGaleryController else {
            assertionFailure("\(Self.self): unexpectedly found YNSelectImageFromGaleryController to be nil")
            return
        }
        self.mainPresenter?.setupSelectNewImageController(&controller)
        self.navigationController?.show(controller, sender: self)//present(controller, animated: true)
    }
    
    private func showAddedImageController() {
        let viewController = YNExistingImagesController.controller(inStoryboard: mainStoryboard())
        guard var controller = viewController as? YNExistingImagesController else {
            assertionFailure("\(Self.self): unexpectedly found YNExistingImagesController to be nil")
            return
        }
        self.mainPresenter?.setupSelectedImagesController(&controller)
        self.navigationController?.show(controller, sender: self)
    }
    
    private func showBestResultsController() {
        let viewController = YNShowResultsViewController.controller(inStoryboard: mainStoryboard())
        guard var controller = viewController as? YNShowResultsViewController else {
            assertionFailure("\(Self.self): unexpectedly found YNShowResultsViewController to be nil")
            return
        }
//        controller.modalPresentationStyle = .pageSheet
//        controller.modalTransitionStyle = .coverVertical
        
        self.mainPresenter?.setupShowResultsController(&controller)
        self.navigationController?.showDetailViewController(controller, sender: self)
        
//        self.present(controller, animated: true)
    }
    
    // MARK: -
    // MARK: Different functions
    
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    // MARK: -
    // MARK: YNMainPresenterDelegate functions
    
    func buttonTapped(_ button : YNMainControllerButtonTapped) {
        switch button {
            case .newImageButton : showNewImageController()
            case .addedImageButton : showAddedImageController()
            case .bestResultsButton : showBestResultsController()
        }
    }
}
