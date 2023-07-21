//
//  YNDragInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 18.07.2023.
//

import UIKit

protocol YNDradDataSource : AnyObject {
    var itemsNo : Int {get}
    subscript(ix : Int) -> YNImageToDragModel {get}
    
}

protocol YNDradDelegate : AnyObject {
    
}

class YNDragInteractor : YNDradDelegate, YNDradDataSource {
    let imageModel : YNBigImageModel
    var imagesToDrag = [YNImageToDragModel]()
    
    init(imageModel : YNBigImageModel, images : [YNImageToDragModel]) {
        self.imageModel = imageModel
    }
    
    convenience init(imageModel : YNBigImageModel) {
        self.init(imageModel: imageModel, images: [YNImageToDragModel]())
        self.createImages()
    }
    
    func createImages() {
        guard let cutImages = self.cutImages(basicImage: self.imageModel.bigImage) else {
            assertionFailure("\(Self.self): could not get array of images")
            return
        }
        var indexes = [Int]()
        for i in 0..<16 { // 4x4 // later MB make variable, like 4x4, 5x5 ...
            let shuffleIndex = self.randomNewInt(indexes)
            indexes.append(shuffleIndex)
            let imgModel = YNImageToDragModel(initialIndex: shuffleIndex, expectedIndex: i, image: cutImages[i])
            self.imagesToDrag.append(imgModel)
        }
        self.imagesToDrag.sort { m1, m2 in
            m1.initialIndex < m2.initialIndex
        }
    }
    
    //MARK: -
    //MARK: Private
    
    private func randomNewInt(_ indexes : [Int]) -> Int {
        var index = Int.random(in: 0..<16)
        if indexes.contains(index) {
            index = self.randomNewInt(indexes)
        }
        return index
    }
    
    private func cutImages(basicImage : UIImage?) -> [UIImage]? {
        guard let cgImage = basicImage?.cgImage else {
            return nil
        }
        let imgWidth = cgImage.width
        let imgHeight = cgImage.height
        if imgWidth != imgHeight { // wrong calculations on previous steps, need to fix
            assertionFailure("\(Self.self): width and height are not equal")
        }
        var images = [UIImage]()
        let cutImgWidth = imgWidth / 4 // equal to height
        for i in 0..<16 {
            let row = i / 4
            let column = i % 4
            let x = column * cutImgWidth
            let y = row * cutImgWidth
            let frame = CGRect(x: x, y: y, width: cutImgWidth, height: cutImgWidth)
            if let image = YNImageModifier.cropImage(cgImage, inRect: frame) {
                images.append(image)
            }
            // else { // try one more time? show error?
        }

        return images
    }
    
    //MARK: -
    //MARK: YNDradDataSource
    
    var itemsNo : Int {
        imagesToDrag.count
    }
    
    subscript(ix : Int) -> YNImageToDragModel {
        self.imagesToDrag[ix]
    }
    
    //MARK: -
    //MARK: YNDradDelegate
}
