//
//  YNDragViewCell.swift
//  PictureDrag
//
//  Created by Ulian on 19.07.2023.
//

import UIKit

class YNDragViewCell : UICollectionViewCell {
    @IBOutlet private weak var imgView : UIImageView!
    
    var image : UIImage? {
        didSet {
            self.imgView.image = image
        }
    }
}
