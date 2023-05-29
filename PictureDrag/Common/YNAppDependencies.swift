//
//  YNAppDependencies.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

let appDesign = YNDesign()
let imageModifier = YNImageModifier()

class YNAppDependencies {
    let mainNavigator = YNMainNavigator()
    
    init() {
        configureDependencies()
    }
    
    private func configureDependencies() {
//        let mainPresenter = YNMainPresenter()
        // create navigation(s) and presenters(s)
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow?) {
        mainNavigator.presentRootInterfaceFromWindow(window)
    }
}
