//
//  YNWholeImageCollectionViewCell.swift
//  PictureDrag
//
//  Created by Ulian on 20.06.2023.
//

import UIKit

enum YNCelectForDeleteEnum {
    case noDeletionState
    case notSelectedToDelete
    case selectedToDelete
}
typealias YNCellTapCompletion = (YNWholeImageCollectionViewCell) -> Void

class YNWholeImageCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var touchView: YNTouchView!
    
    private var onPressClosure : YNCellTapCompletion?
    private var onTapClosure : YNCellTapCompletion?
    
    var mainImage : UIImage? {
        didSet {
            self.contentImageView.image = mainImage
        }
    }
    var selectionColor : UIColor?
    var makeSelected = false {
        didSet {
            if makeSelected {
                self.touchView.layer.borderColor = self.selectionColor?.cgColor ?? UIColor.red.cgColor
            } else {
                self.touchView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    var cellID = -1
    var selectForDeletImage : UIImage? {
        didSet {
            self.selectionImageView.image = selectForDeletImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.touchView.layer.borderWidth = 3.0
        self.touchView.supportPressEvent = true
    }
    
    // MARK: -
    // MARK: Public functions
    
    func onTapCompletion(_ c : @escaping YNCellTapCompletion) {
        self.onTapClosure = c
        self.touchView.onTap { _ in
            self.onTapClosure?(self)
        }
    }
    
    func onPressCompletion(_ c : @escaping YNCellTapCompletion) {
        self.onPressClosure = c
        self.touchView.onPress { _ in
            self.onPressClosure?(self)
        }
    }
}
