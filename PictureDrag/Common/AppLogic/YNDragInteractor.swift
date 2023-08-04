//
//  YNDragInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 18.07.2023.
//

import UIKit

protocol YNDradDataSource : AnyObject {
    var itemsNo : Int {get}
    subscript(ix : Int) -> YNDragableModel {get}
    
    func isSuccessfullyFinished() -> Bool
}

protocol YNDradDelegate : AnyObject {
    func insertItem(withIndex index1 : Int, toIndex index2 : Int)
}

class YNDragInteractor : YNDradDelegate, YNDradDataSource {
    let imageModel : YNBigImageModel
    var imagesToDrag = [YNDragableModel]()
    
    init(imageModel : YNBigImageModel, images : [YNDragableModel]) {
        self.imageModel = imageModel
    }
    
    convenience init(imageModel : YNBigImageModel) {
        self.init(imageModel: imageModel, images: [YNDragableModel]())
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
            let imgModel = YNDragableModel(initialIndex: shuffleIndex, expectedIndex: i, image: cutImages[i])
            self.imagesToDrag.append(imgModel)
        }
        self.imagesToDrag.sort { m1, m2 in
            m1.currentIndex < m2.currentIndex
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
    
    subscript(ix : Int) -> YNDragableModel {
        self.imagesToDrag[ix]
    }
    
    func isSuccessfullyFinished() -> Bool {
        for t in self.imagesToDrag.enumerated() {
            if t.offset != t.element.currentIndex {
                return false
            }
        }
        return true // all elements are in right order
    }
    
    //MARK: -
    //MARK: YNDradDelegate
    
    func insertItem(withIndex index1 : Int, toIndex index2 : Int) {
        if index1 == index2 {
            return
        }
        
        var item = self.imagesToDrag[index1]
        self.imagesToDrag.remove(at: index1)
        self.imagesToDrag.insert(item, at: index2)
        
        for t in self.imagesToDrag.enumerated() {
            t.element.previousIndex = t.element.currentIndex
            t.element.currentIndex = t.offset
        }

        self.imagesToDrag.sort { m1, m2 in
            m1.currentIndex < m2.currentIndex
        }
    }
}
