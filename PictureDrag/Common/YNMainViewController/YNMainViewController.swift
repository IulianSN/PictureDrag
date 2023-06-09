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

class YNMainViewController: UIViewController { // make presenter controller's data source
    @IBOutlet weak var newImageButton: YNNoImageButton!
    @IBOutlet weak var addedImageButton: YNNoImageButton!
    @IBOutlet weak var bestResultsButton: YNNoImageButton!
    
    weak var presenterDelegate : YNMainPresenterDelegate?
    weak var dataSource : YNMainPresenterDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dataSource = self.dataSource else {
            assertionFailure("\(Self.self): unexpectedly found dataSource to be nil")
            return 
        }
        
//        self.navigationController?.navigationBar.barStyle = .black
        
        self.newImageButton.title = dataSource.newImageButtonTitle
        self.newImageButton.colorOnTouch = dataSource.buttonHighlightedColour
        self.newImageButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.newImageButton)
        })
        
        self.addedImageButton.title = dataSource.existingImageButtonTitle
        self.addedImageButton.colorOnTouch = dataSource.buttonHighlightedColour
        self.addedImageButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.addedImageButton)
        })
        
        self.bestResultsButton.title = dataSource.seeResultsButtonTitle
        self.bestResultsButton.colorOnTouch = dataSource.buttonHighlightedColour
        self.bestResultsButton.onTap({[weak self] _ in
            self?.presenterDelegate?.buttonTapped(.bestResultsButton)
        })
//        self.overrideUserInterfaceStyle = .dark // dark mode

//        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate() // does not work for now. Find the reason
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

