//
//  YNMainWireframe.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

class YNMainNavigator : YNMainPresenterDelegate, YNContinueWithImageDelegate {
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
        guard var vc = YNSelectImageFromGaleryController.controller(inStoryboard: mainStoryboard()) as? YNSelectImageFromGaleryController else {
            assertionFailure("\(Self.self): unexpectedly found YNSelectImageFromGaleryController to be nil")
            return
        }
        self.mainPresenter?.setupSelectNewImageController(&vc, sender: self)
        self.navigationController?.show(vc, sender: self)//present(controller, animated: true)
    }
    
    private func showAddedImageController() {
        guard var vc = YNExistingImagesController.controller(inStoryboard: mainStoryboard()) as? YNExistingImagesController else {
            assertionFailure("\(Self.self): unexpectedly found YNExistingImagesController to be nil")
            return
        }
        self.mainPresenter?.setupSelectedImagesController(&vc, sender: self)
        self.navigationController?.show(vc, sender: self)
    }
    
    private func showBestResultsController() {
        guard var vc = YNShowResultsViewController.controller(inStoryboard: mainStoryboard()) as? YNShowResultsViewController else {
            assertionFailure("\(Self.self): unexpectedly found YNShowResultsViewController to be nil")
            return
        }
//        controller.modalPresentationStyle = .pageSheet
//        controller.modalTransitionStyle = .coverVertical
        
        self.mainPresenter?.setupShowResultsController(&vc)
        self.navigationController?.showDetailViewController(vc, sender: self)
        
//        self.present(controller, animated: true)
    }
    
    private func showDragController(withModel model : YNBigImageModel) {
        guard var vc = YNDragViewController.controller(inStoryboard: mainStoryboard()) as? YNDragViewController else {
            assertionFailure("\(Self.self): unexpectedly found YNDragViewController to be nil")
            return
        }
        self.mainPresenter?.setupDragController(&vc, withModel: model)
        self.navigationController?.show(vc, sender: self)
    }
    
    // MARK: -
    // MARK: Different functions
    
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    // MARK: -
    // MARK: YNContinueWithImageDelegate
    
    func continueWith(imageModel model : YNBigImageModel) {
        self.showDragController(withModel : model)
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
