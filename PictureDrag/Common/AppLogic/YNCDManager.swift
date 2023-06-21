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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                assertionFailure("\(Self.self): unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
          do {
              try context.save()
          } catch {
              let error = error as NSError
              assertionFailure("\(Self.self): unresolved error \(error), \(error.userInfo)")
          }
        }
      }
}
