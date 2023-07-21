//
//  YNTakeImageInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 24.06.2023.
//

import UIKit

protocol YNInteractorDelegate : AnyObject {
    func calculateSelectionFrame(imageViewBounds frame : CGRect, imageSize size : CGSize) -> CGRect
    func calculateNextPositionWihtPoint(_ point : CGPoint, selectionViewFrame selectFrame : CGRect, imageViewBounds mainFrame : CGRect, imageSize size : CGSize) -> CGRect
    func saveSelectedImage(_ image : UIImage, imageViewBounds mainFrame : CGRect, selectionFrame frame : CGRect) -> (Bool, YNBigImageModel?)
    func newImageSelected()
}

protocol YNCalculateImageParametersDelegate : AnyObject {
    func calculateNewImageSize(forImageSize size : CGSize, withMinParameter parameter : CGFloat) -> CGSize
    func calculateNewOriginPoint(forImageSize size : CGSize, selectionFrame : CGRect) -> CGRect
}

class YNTakeImageInteractor : YNInteractorDelegate, YNCalculateImageParametersDelegate {
    private var dragDirectionVertical = false
    private var originPointProportion : CGFloat = 0
    
    func selectImageScreenModel() -> YNPickImageControllerModel {
        let model = YNPickImageControllerModel()
        return model
    }
    
    // MARK: -
    // MARK: Frame calculations
    
    private func calculateMaxParameter(forImageFrame frame : CGRect, size : CGFloat) -> CGFloat {
        return self.dragDirectionVertical ? (frame.size.height - size) : (frame.size.width - size)
    }
    
    private func calculateMultiplier(size: CGSize, rect : CGRect) -> CGFloat
    {
        let aspectRationImage = size.width / size.height
        let aspectRationContainer = rect.width / rect.height
        let multiplier : CGFloat
        
        if aspectRationImage > aspectRationContainer {
            multiplier = rect.width / size.width
        } else {
            multiplier = rect.height / size.height
        }
        self.dragDirectionVertical = aspectRationImage < 1.0
        
        return multiplier
    }
    
    private func calculateImageFrame(frame : CGRect, size : CGSize) -> CGRect {
        let multiplier = self.calculateMultiplier(size: size, rect: frame)

        let size = CGSize(width: size.width * multiplier, height: size.height * multiplier)
        let x = (frame.width - size.width) / 2.0
        let y = (frame.height - size.height) / 2.0
        
        let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
//        print("frame: \(rect)")
        return rect
    }
    
    // MARK: -
    // MARK: YNInteractorDelegate
    
    func calculateSelectionFrame(imageViewBounds frame : CGRect, imageSize size : CGSize)  -> CGRect {
        let imageFrameInImageView = self.calculateImageFrame(frame: frame, size: size)
        let minImageSize = min(imageFrameInImageView.size.width, imageFrameInImageView.size.height)
        
        var xPosition = imageFrameInImageView.origin.x
        var yPosition = imageFrameInImageView.origin.y
        
        if self.originPointProportion > 0.01 {
            let maxParam = calculateMaxParameter(forImageFrame: imageFrameInImageView, size: minImageSize)
            print("proportion: \(self.originPointProportion), maxParam: \(maxParam)")
            let calcValue = maxParam * self.originPointProportion
            if self.dragDirectionVertical {
                yPosition = yPosition + calcValue
            } else {
                xPosition = xPosition + calcValue
            }
        }
        
        return CGRect(x: xPosition,
                      y: yPosition,
                  width: minImageSize,
                 height: minImageSize)
    }
    
    func calculateNextPositionWihtPoint(_ point : CGPoint,
                 selectionViewFrame selectFrame : CGRect,
                      imageViewBounds mainFrame : CGRect,
                                 imageSize size : CGSize) -> CGRect
    {
        let imageFrame = self.calculateImageFrame(frame: mainFrame, size: size)
        
        let minParameter = self.dragDirectionVertical ? imageFrame.origin.y : imageFrame.origin.x
        
        let maxParameter = self.dragDirectionVertical ? (imageFrame.size.height - selectFrame.size.height + imageFrame.origin.y) : (imageFrame.size.width - selectFrame.size.width  + imageFrame.origin.x)
        let currentParameter = self.dragDirectionVertical ? selectFrame.origin.y : selectFrame.origin.x
        let addValue = self.dragDirectionVertical ? point.y : point.x
        let originPoint : CGFloat
        if currentParameter + addValue > maxParameter {
            originPoint = maxParameter
        } else if currentParameter + addValue < minParameter {
            originPoint = minParameter
        } else {
            let currentOriginPoint = self.dragDirectionVertical ? selectFrame.origin.y : selectFrame.origin.x
            originPoint = currentOriginPoint + addValue
        }
        let subtractValue = self.dragDirectionVertical ? imageFrame.origin.y : imageFrame.origin.x
        
        self.originPointProportion = (originPoint - subtractValue) / calculateMaxParameter(forImageFrame: imageFrame, size: selectFrame.size.height)
        
        var rect = selectFrame
        if self.dragDirectionVertical {
            rect = CGRect(x: rect.origin.x, y: originPoint, width: rect.size.width, height: rect.size.height)
        } else {
            rect = CGRect(x: originPoint, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        }
        return rect
    }
    
    func saveSelectedImage(_ image : UIImage, imageViewBounds mainFrame : CGRect, selectionFrame frame : CGRect) -> (Bool, YNBigImageModel?) {
        let imageModifier = YNImageModifier()
        let imageFrame = self.calculateImageFrame(frame: mainFrame, size: image.size)
        let celectionFrameInImageFrame = CGRect(x: frame.origin.x - imageFrame.origin.x,
                                                y: frame.origin.y - imageFrame.origin.y,
                                            width: frame.width,
                                           height: frame.height)
        if let croppedImage = imageModifier.makeBigImage(cropImage: image,
                                                         withFrame: celectionFrameInImageFrame,
                                                          delegate: self)
        {
            if let identifier = imageModifier.saveImage(croppedImage) {
                YNCDManager.shared.saveImageModel(withID: identifier)
                let model = YNBigImageModel(imageIdentifier: identifier)
                model.bigImage = croppedImage
                return (true, model)
            }
        }
        
        return (false, nil)
    }
    
    func newImageSelected() {
        self.originPointProportion = 0
    }
    
    // MARK: -
    // MARK: YNCalculateImageParametersDelegate
    
    func calculateNewImageSize(forImageSize size : CGSize, withMinParameter parameter : CGFloat) -> CGSize {
        let proportion = size.width/size.height
        let size : CGSize
        if proportion > 1.0 {
            size = CGSize(width: parameter * proportion, height: parameter)
        } else {
            size = CGSize(width: parameter, height: parameter / proportion)
        }
        return size
    }
    
    func calculateNewOriginPoint(forImageSize size : CGSize, selectionFrame : CGRect) -> CGRect {
        let imgProportion = size.width/size.height
        let minSize = min(size.width, size.height)
        let sizeProportion = minSize / selectionFrame.size.width // could be used .height as well, they are equal
        let point : CGPoint
        if imgProportion > 1.0 {
            point = CGPoint(x: selectionFrame.origin.x * sizeProportion, y: 0)
        } else {
            point = CGPoint(x: 0, y: selectionFrame.origin.y * sizeProportion)
        }
        
        return CGRect(origin: point, size: CGSize(width: minSize, height: minSize))
    }
}
