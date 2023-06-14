//
//  YNInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

protocol YNInteractorDelegate : AnyObject {
    func calculateSelectionFrame(imageViewBounds frame : CGRect, imageSize size : CGSize) -> CGRect
    func calculateNextPositionWihtPoint(_ point : CGPoint, selectionViewFrame selectFrame : CGRect, imageViewBounds mainFrame : CGRect, imageSize size : CGSize) -> CGRect
}

class YNInteractor {
    func mainScreenSettingsModel() -> YNMainControllerSettingsModel {
        let model = YNMainControllerSettingsModel()
        return model
    }
    
    func bestResultsScreenModel() -> YNResultsScreenModel {
        var model = YNResultsScreenModel()
        var modelArray = [YNResultsModel]()
        // mock results models
//        let model1 = YNResultsModel(gamerName: "Yulian",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "12.4",
//                                    imageIdentifier: "ASFDG-KUHDKJG")
//        model1.smallImage = self.smallImageForIdentifier(model1.imageIdentifier)
//        modelArray.append(model1)
        
//        let model2 = YNResultsModel(gamerName: "Ivan",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "11.1",
//                                    imageIdentifier: "ASFDG-KUHDerG")
//        model2.smallImage = self.smallImageForIdentifier(model2.imageIdentifier)
//        modelArray.append(model2)
        
//        let model3 = YNResultsModel(gamerName: "Yulian",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "15.4",
//                                    imageIdentifier: "ASFDG-KUHUIJG")
//        model3.smallImage = self.smallImageForIdentifier(model3.imageIdentifier)
//        modelArray.append(model3)
        
//        let model4 = YNResultsModel(gamerName: "Ivan",
//                                    dateString: "06.03.2023",
//                                    gameResultTime: "10.2",
//                                    imageIdentifier: "ASFDG-KUHDPOG")
//        model4.smallImage = self.smallImageForIdentifier(model4.imageIdentifier)
//        modelArray.append(model4)
        
        modelArray.sort(by: { return $0.gameResultTime < $1.gameResultTime })
        
        model.gameResultsModels = modelArray
        // fetch core data results, fill YNResultsModel(s)
        return model
    }
    
    func selectImageScreenModel() -> YNPickImageControllerModel {
        let model = YNPickImageControllerModel()
        return model
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func smallImageForIdentifier(_ identifier : String) -> UIImage? {
        if let image = bigImageForIdentifier(identifier) {
            return imageModifier.makeSmallImage(image)
        }
        return nil
    }
    
    private func bigImageForIdentifier(_ identifier : String) -> UIImage? {
        if let image = UserDefaults.standard.object(forKey: identifier) as? UIImage {
            return image
        }
        return nil
    }
}

    
class YNSelectImageInteractor : YNInteractorDelegate {
    private var dragDirectionVertical = false
    private var originPointProportion : CGFloat = 0
    
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
        
        if aspectRationImage > aspectRationContainer { // could move horizontally
            multiplier = rect.width / size.width//rect.height / size.height
        } else {
            multiplier = rect.height / size.height//rect.width / size.width
        }
        self.dragDirectionVertical = aspectRationImage < 1.0 // dragDirectionVertical
        
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
        
        let minImageSize = imageFrameInImageView.size.width > imageFrameInImageView.size.height ? imageFrameInImageView.size.height : imageFrameInImageView.size.width
        
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
}
