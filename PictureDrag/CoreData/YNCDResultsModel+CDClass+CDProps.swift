//
//  YNCDResultsModel+CoreDataProperties.swift
//  PictureDrag
//
//  Created by Ulian on 10.07.2023.
//
//

import Foundation
import CoreData

@objc(YNCDResultsModel)
public class YNCDResultsModel: NSManagedObject {

}

extension YNCDResultsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YNCDResultsModel> {
        return NSFetchRequest<YNCDResultsModel>(entityName: "YNCDResultsModel")
    }

    @NSManaged public var imageID: String
    @NSManaged public var name: String
    @NSManaged public var date: Date
    @NSManaged public var resultTime: String
    // add complexity parameter as Int (1, 2, 4) // and create enum : Int
}

extension YNCDResultsModel : Identifiable {

}
