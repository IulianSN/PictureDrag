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
    // MARK: Class functions
    
    class func cropImage(_ image : CGImage, inRect rect : CGRect) -> UIImage? {
        guard let croppedCGImg: CGImage = image.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: croppedCGImg)
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
        guard let cgImage = image.cgImage else {
            return nil
        }

        let cgImgRect = delegate.calculateNewOriginPoint(forImageSize: CGSize(width: cgImage.width, height: cgImage.height), selectionFrame: frame)

        guard let croppedCGImg: CGImage = cgImage.cropping(to: cgImgRect) else {
            return nil
        }
        let croppedImage: UIImage = UIImage(cgImage: croppedCGImg)
        
        let scale = self.graphicsFormat.scale
        let scaled = self.screenMinDimension * scale * self.bigImageDimensionModifier
        let finalRect = CGRect(origin: .zero, size: CGSize(width: scaled, height: scaled))
        
        let renderer = UIGraphicsImageRenderer(size: finalRect.size, format: self.graphicsFormat)
        image = renderer.image { _ in
            croppedImage.draw(in: finalRect)
        }

        return image
    }
    
    func saveImage(_ image : UIImage) -> String? {
        let imageID = UUID().uuidString
        guard let fileURL = self.urlWithImageID(imageID) else {
            return nil
        }
        guard let data = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        do {
            try data.write(to: fileURL)
        } catch {
            print("error saving file with error \(error)")
            return nil
        }
        return imageID
    }
    
    func getImage(withImageID identifier : String) -> UIImage? {
        guard let fileURL = self.urlWithImageID(identifier) else {
            return nil
        }
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
    func removeImages(withIDs array : [String]) {
        for identifier in array {
            self.deleteImage(forImageID: identifier)
        }
    }
    
    func deleteImage(forImageID identifier : String) { // return success ??
        guard let fileURL = self.urlWithImageID(identifier) else {
            return
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("couldn't remove file at path \(error)")
            }
        }
    }
    
    
    /**
     when selecting image - check if it is not too small:
     let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
     If too small - show alert ??
     */
    
    // MARK: -
    // MARK: Private functions
    
    private func urlWithImageID(_ identifier : String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(identifier)
        return fileURL
    }
    
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
