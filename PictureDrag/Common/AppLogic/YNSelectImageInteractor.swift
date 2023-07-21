//
//  YNSelectImageInteractor.swift
//  PictureDrag
//
//  Created by Ulian on 24.06.2023.
//

import UIKit

protocol YNSelectImageDelegate : AnyObject {
    func updateData()
    func cleanData()
    func deleteTapped()
    func cellPressed()
    func endDeletionMode()
    func selectedImageIndex(_ index : Int)
}

protocol YNImagesListDataSource : AnyObject {
    var numberOfImagesToShow : Int {get}
    var imgModelToContinue : YNBigImageModel? {get}
    
    func imageForID(_ id : Int) -> UIImage?
    func deleteStateForID(_ id : Int) -> YNCelectForDeleteEnum
    func isSelected(forID id : Int) -> Bool
    func isContinueButtonEnabled() -> Bool
    func isDeleteBlockEnabled() -> Bool
    func showNoImagesLabel() -> Bool
    func fetchImageForIndex(_ index : Int, _ completion : (Bool) -> ())
}

class YNSelectImageInteractor : YNSelectImageDelegate, YNImagesListDataSource {
    private var images = [YNBigImageModel]()
    private var deletionMode = false
    private var imageID = ""

    private var currentSelectedIndex : Int = -1 {
        didSet {
            if currentSelectedIndex >= 0 {
                self.imageID = self.images[currentSelectedIndex].imageIdentifier
            } else {
                self.imageID = ""
            }
        }
    }
    private var idsToDelete = [Int]() // remove images from local storage && imageModels form CD
    
    func imageScreenModel() -> YNSelectedImagesControllerModel {
        let model = YNSelectedImagesControllerModel()
        return model
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func dealWithIndex(_ index : Int) {
        if self.deletionMode {
            if let index = self.idsToDelete.firstIndex(of: index) {
                self.idsToDelete.remove(at: index)
            } else {
                self.idsToDelete.append(index)
            }
        } else {
            if self.currentSelectedIndex == index { // unselect
                self.currentSelectedIndex = -1
            } else {
                self.currentSelectedIndex = index
            }
        }
    }
    
    // MARK: -
    // MARK: YNSelectImageDelegate
    
    func updateData() {
        // mock models
//        var imgModel = YNBigImageModel(imageIdentifier: "111222")
//        imgModel.bigImage = UIImage(named: "placeholder_image")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
//        imgModel = YNBigImageModel(imageIdentifier: "222333")
//        imgModel.bigImage = UIImage(named: "take_a_photo")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
//        imgModel = YNBigImageModel(imageIdentifier: "111333")
//        imgModel.bigImage = UIImage(named: "placeholder_image")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
//        imgModel = YNBigImageModel(imageIdentifier: "111444")
//        imgModel.bigImage = UIImage(named: "placeholder_image")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
//        imgModel = YNBigImageModel(imageIdentifier: "111555")
//        imgModel.bigImage = UIImage(named: "placeholder_image")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
//        imgModel = YNBigImageModel(imageIdentifier: "111666")
//        imgModel.bigImage = UIImage(named: "placeholder_image")?.withTintColor(UIColor.black)
//        self.images.append(imgModel)
        //
        let imageIDs = YNCDManager.shared.loadImages()
        for value in imageIDs {
            let model = YNBigImageModel(imageIdentifier: value)
            self.images.append(model)
        }
    }
    
    func cleanData() {
        self.images = [YNBigImageModel]()
        self.deletionMode = false
        self.imageID = ""
        self.currentSelectedIndex = -1
        self.idsToDelete = [Int]()
    }
    
    func deleteTapped() {
        if self.idsToDelete.isEmpty {
            return
        }
        var newArray = [YNBigImageModel]()
        var deleteArray = [String]()
        for (index, element) in self.images.enumerated() {
            if !self.idsToDelete.contains(index) {
                newArray.append(element)
            } else {
                deleteArray.append(element.imageIdentifier)
            }
        }
        self.images = newArray
        YNImageModifier().removeImages(withIDs: deleteArray)
        YNCDManager.shared.removeImageModels(withIDs: deleteArray)
        self.idsToDelete = [Int]()
    }
    
    func cellPressed() {
        self.deletionMode = true
    }
    
    func endDeletionMode() {
        self.deletionMode = false
        self.idsToDelete = [Int]()
        
        if self.currentSelectedIndex >= 0 { // check if previously selected image still on the same position
            let imageModel = self.images[self.currentSelectedIndex]
            if imageModel.imageIdentifier != self.imageID {
                self.imageID = ""
                self.currentSelectedIndex = -1
            }
        }
    }
    
    func selectedImageIndex(_ index : Int) {
        self.dealWithIndex(index)
    }
    
    // MARK: -
    // MARK: YNImagesListDataSource
    
    var numberOfImagesToShow : Int {
        return self.images.count
    }
    
    var imgModelToContinue : YNBigImageModel? {
        if self.currentSelectedIndex >= 0 {
            return self.images[self.currentSelectedIndex]
        }
        return nil
    }
    
    func imageForID(_ id : Int) -> UIImage? {
        return self.images[id].bigImage
    }
    
    func deleteStateForID(_ id : Int) -> YNCelectForDeleteEnum {
        if !self.deletionMode {
            return .noDeletionState
        }
        return self.idsToDelete.contains(id) ? .selectedToDelete : .notSelectedToDelete
    }
    
    func isSelected(forID id : Int) -> Bool {
        id == self.currentSelectedIndex && !self.deletionMode
    }
    
    func isContinueButtonEnabled() -> Bool {
        self.currentSelectedIndex >= 0 && !self.deletionMode
    }
    
    func isDeleteBlockEnabled() -> Bool {
        self.deletionMode
    }
    
    func showNoImagesLabel() -> Bool {
        self.images.isEmpty
    }
    
    func fetchImageForIndex(_ index : Int, _ completion : (Bool) -> ()) {
        let imgModifier = YNImageModifier()
        let model = self.images[index]
        let img = imgModifier.getImage(withImageID: model.imageIdentifier)
        model.bigImage = img
        completion(img != nil)
    }
}
