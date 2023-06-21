//
//  YNImageModifier.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

class YNImageModifier {
    let bigImageDimensionModifier = 0.95
    
    private let imageSmallSize = CGSize(width: 60, height: 60)
    
    lazy var screenMinDimension = {
        return self.calculateScreenMinDimension()
    }()
    
    lazy var imageBigSize = {
        return self.calculateBigSize()
    }()
    
    var graphicsFormat : UIGraphicsImageRendererFormat {
        get {
            return UIGraphicsImageRendererFormat.default()
        }
    }
    
    // MARK: -
    // MARK: Public functions
    
    func makeSmallImage(_ image : UIImage?) -> UIImage? {
        if image == nil {
            return nil
        }
//        let resized = image!.preparingThumbnail(of: imageSmallSize) // for iOS 15
        
//        let format = UIGraphicsImageRendererFormat.default()
//        format.scale = 1 // don't set this value, let it be pixels per point of current device
        let renderer = UIGraphicsImageRenderer(size: self.imageSmallSize, format: self.graphicsFormat)
        let resized = renderer.image { _ in
            image!.draw(in: CGRect(origin: .zero, size: self.imageSmallSize))
        }
        return resized
    }
    
    func makeBigImage(cropImage image : UIImage, withFrame frame : CGRect, delegate : YNCalculateImageParametersDelegate) -> UIImage? {
        // decrease image size if needed
        var image = image
        let imageMinSize = image.size.width < image.size.height ? image.size.width : image.size.height
        let scale = self.graphicsFormat.scale
        let scaled = self.screenMinDimension * scale * self.bigImageDimensionModifier
        
        if imageMinSize > scaled {
            let newImageSize = delegate.calculateNewImageSize(forImageSize: image.size, withMinParameter: scaled)
            
            let renderer = UIGraphicsImageRenderer(size: newImageSize, format: self.graphicsFormat)
            image = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newImageSize))
            }
        }
        
        let finishRect = delegate.calculateNewOriginPoint(forImageSize: image.size, selectionFrame: frame)
        let renderer = UIGraphicsImageRenderer(size: finishRect.size, format: self.graphicsFormat)
        image = renderer.image { _ in
            image.draw(in: finishRect)
        }

        return image
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
