//
//  YNCDManager.swift
//  PictureDrag
//
//  Created by Ulian on 16.06.2023.
//

import Foundation
import CoreData

class YNCDManager {
    static let shared = YNCDManager()
    
//    var predicate: NSPredicate? // predicate = NSPredicate(format: "imageID == %@", imageID)
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YNCoreData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
              try context.save()
            } catch {
              let error = error as NSError
              assertionFailure("\(Self.self): unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveImageModel(withID identifier : String) {
//        DispatchQueue.main.async { // [unowned self] in
            let commit = YNCDImageModel(context: self.persistentContainer.viewContext)
            commit.imageID = identifier
            self.saveContext()
//        }
    }
    
    func loadImages() -> [String] {
        var imageIDs = [String]()
        
        let request = YNCDImageModel.fetchRequest()
        do {
            let models = try self.persistentContainer.viewContext.fetch(request)
            for model in models {
                imageIDs.append(model.imageID)
            }
        } catch {
            print("Fetch failed with error: \(error)")
        }
        return imageIDs
    }
    
    
    /**
        let request = YNResultsModel.fetchRequest()
        let sort = NSSortDescriptor(key: "resultTime", ascending: true)
        request.sortDescriptors = [sort]
     
            // use predicate:
     request.predicate = self.predicate
     */
}
