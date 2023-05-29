//
//  ViewController.swift
//  PictureDrag
//
//  Created by Ulian on 20.05.2023.
//

import UIKit

enum YNMainControllerButtonTapped {
    case newImageButton
    case addedImageButton
    case bestResultsButton
}

class YNMainViewController: UIViewController {
    @IBOutlet weak var newImageButton: YNNoImageButton!
    @IBOutlet weak var addedImageButton: YNNoImageButton!
    @IBOutlet weak var bestResultsButton: YNNoImageButton!
    
    weak var presenterDelegate : YNMainPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newImageButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.newImageButton)
        })
        
        addedImageButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.addedImageButton)
        })
        
        bestResultsButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.bestResultsButton)
        })
    }
}

