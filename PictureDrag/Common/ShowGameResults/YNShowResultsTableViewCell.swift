//
//  YNShowResultsTableViewCell.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

class YNShowResultsTableViewCell : UITableViewCell {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImageView.backgroundColor = appDesign.imageBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /**
          this is not the best practice for performance to clean table view cell's fields (especially image) from here.
          But it is the most sufficient.
         */
        self.thumbnailImageView.image = nil
        self.nameLabel.text = ""
        self.dateLabel.text = ""
        self.resultLabel.text = ""
    }
    
    func setupCellData(image : UIImage?,
                       name : String,
                       date : String,
                       result : String,
                       place : Int)
    {
        self.thumbnailImageView.image = image
        self.nameLabel.text = name
        self.dateLabel.text = date
        self.resultLabel.text = result
        self.placeLabel.text = String(place)
    }
    
}
