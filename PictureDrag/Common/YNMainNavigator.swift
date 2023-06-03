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
        self.navigationController = windowUnwrapped.rootViewController as? UINavigationController
        self.showRootViewController(viewController: controller)
    }
    
    // MARK: -
    // MARK: Private functions
    
    // MARK: -
    // MARK: Show root view controller
    
    private func showRootViewController(viewController: UIViewController) {
//        let navigationController = self.navigationControllerFromWindow(window: inWindow)
        self.navigationController?.viewControllers = [viewController]
    }
    
//    private func navigationControllerFromWindow(window: UIWindow) -> UINavigationController {
//        let navigationController = window.rootViewController as! UINavigationController
//        return navigationController
//    }
    
    // MARK: -
    // MARK: Show controllers on button tapps
    
    private func showNewImageController() {
        
    }
    
    private func showAddedImageController() {
        
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
