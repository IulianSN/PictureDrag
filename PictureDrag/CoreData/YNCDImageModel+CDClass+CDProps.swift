//
//  YNCDImageModel+CoreDataProperties.swift
//  PictureDrag
//
//  Created by Ulian on 10.07.2023.
//
//

import Foundation
import CoreData

@objc(YNCDImageModel)
public class YNCDImageModel: NSManagedObject {

}

extension YNCDImageModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YNCDImageModel> {
        return NSFetchRequest<YNCDImageModel>(entityName: "YNCDImageModel")
    }

    @NSManaged public var imageID: String

}

extension YNCDImageModel : Identifiable {

}
