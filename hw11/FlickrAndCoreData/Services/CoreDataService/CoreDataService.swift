//
//  CoreDataService.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 22/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveImages(from collection: ThreadSafeImageViewCollection)
    func loadPhotos(completion: @escaping ([MOPhoto]) -> Void)
    func deleteAllPhotos(completion: @escaping (Bool) -> Void)
}

/// Service that can be used in interactors for actions connected with SQLite such as saving and loading data
class CoreDataService: CoreDataServiceProtocol {
    private let stack = CoreDataStack.shared
    private let entityName = "Photo"
    
    func loadPhotos(completion: @escaping ([MOPhoto]) -> Void) {
        stack.persistentContainer.performBackgroundTask { (readContext) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            let sorter: NSSortDescriptor = NSSortDescriptor(key: "id" , ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            
            do {
                let result = try readContext.fetch(fetchRequest) as? [MOPhoto]
                guard let photoObjects = result else {
                    print("not MOPhoto")
                    return
                }

                completion(photoObjects)
            } catch {
                print(error.localizedDescription)
                completion([MOPhoto]())
            }
        }
    }
    
    func deleteAllPhotos(completion: @escaping (Bool) -> Void) {
        stack.persistentContainer.performBackgroundTask { (deleteContext) in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
                try deleteContext.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
                try deleteContext.save()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func saveImages(from collection: ThreadSafeImageViewCollection) {
        
        stack.persistentContainer.performBackgroundTask { (writeContext) in
            for index in 0..<collection.count {
                let imageViewModel = collection[index]
                let photo = MOPhoto(context: writeContext)
                guard let imageData = imageViewModel.image.pngData() else {
                    return
                }
                photo.data = imageData
                photo.text = imageViewModel.description
                photo.id = Int16(index)
            }
            
            do {
                try writeContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
