//
//  YNImageModifier.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

class YNImageModifier {
    let bigImageDimensionModifier = 0.8 // make global ??
    
    private let imageSmallSize = CGSize(width: 120, height: 120)
    lazy var screenMinDimension = {
        return self.calculateScreenMinDimension()
    }()
    lazy var imageBigSize = { // see lazy initializer !!
        return self.calculateBigSize()
    }()
    
    // MARK: -
    // MARK: Public functions
    
    func makeSmallImage(_ image : UIImage?) -> UIImage? {
        if image == nil {
            return nil
        }
//        let resized = image!.preparingThumbnail(of: imageSmallSize) // for iOS 15
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: self.imageSmallSize, format: format)
        let resized = renderer.image { (context) in
            image!.draw(in: CGRect(origin: .zero, size: self.imageBigSize))
        }
        return resized
    }
    
    /**
     when selecting image - check if it is not too small:
     let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
     If too small - show alert ??
     */
    
    // MARK: -
    // MARK: Private functions
    
    private func calculateScreenMinDimension() -> Double {
        guard let window : UIWindow = UIApplication.shared.windows.first else {
            assertionFailure("\(Self.self): unexpectedly found first window to be nil")
            return 0
        }
        let width = window.frame.size.width
        let height = window.frame.size.height
        let dimension = width < height ? width : height
        return dimension
    }
    
    private func calculateBigSize() -> CGSize {
        let dimension = screenMinDimension * bigImageDimensionModifier
        
        return CGSize(width: dimension, height: dimension)
    }
    

}
