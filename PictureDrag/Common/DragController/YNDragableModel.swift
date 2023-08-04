//
//  YNDragableModel.swift
//  PictureDrag
//
//  Created by Ulian on 23.07.2023.
//

import UIKit

class YNDragableModel : NSObject, NSItemProviderWriting {
    var previousIndex : Int
    var currentIndex : Int
    let expectedIndex : Int
    let image : UIImage
    
    init(initialIndex: Int, expectedIndex: Int, image: UIImage) {
        self.previousIndex = initialIndex
        self.currentIndex = initialIndex
        self.expectedIndex = expectedIndex
        self.image = image
    }
    
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return ["YNDragableModel"]
    }
        
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
