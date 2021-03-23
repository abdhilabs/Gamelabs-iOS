//
//  GameProvider.swift
//  Gamelabs
//
//  Created by Abdhi on 20/03/21.
//

import CoreData
import UIKit

class GameProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameFavourite")
        
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Error on: \(error?.localizedDescription ?? "Undefined")")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavouriteGame(completion: @escaping(_ game: [FavouriteModel]) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [FavouriteModel] = []
                for result in results {
                    let game = FavouriteModel(id: result.value(forKey: "id") as? Int32, name: result.value(forKey: "title") as? String, description: result.value(forKey: "content") as? String, released: result.value(forKey: "releaseDate") as? String, backgroundImage: result.value(forKey: "imageBanner") as? String, ratingAverage: result.value(forKey: "rating") as? String, genres: result.value(forKey: "category") as? String)
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Couldn't fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getFavouriteGame(_ id: Int, completion: @escaping(_ fav: FavouriteModel) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let gameFav = FavouriteModel(id: result.value(forKey: "id") as? Int32, name: result.value(forKey: "title") as? String, description: result.value(forKey: "content") as? String, released: result.value(forKey: "releaseDate") as? String, backgroundImage: result.value(forKey: "imageBanner") as? String, ratingAverage: result.value(forKey: "rating") as? String, genres: result.value(forKey: "category") as? String)
                    completion(gameFav)
                }
            } catch let error as NSError {
                print("Couldn't fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func isGameFavourited(_ id: Int, completion: @escaping(_ isFavourite: Bool) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let _ = try taskContext.fetch(fetchRequest).first {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveGameToFavourite(_ id: Int,_ title: String, _ rating: String, _ category: String, _ releaseDate: String, _ description: String, _ image: String, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKey: "id")
                game.setValue(title, forKey: "title")
                game.setValue(rating, forKey: "rating")
                game.setValue(category, forKey: "category")
                game.setValue(releaseDate, forKey: "releaseDate")
                game.setValue(description, forKey: "content")
                game.setValue(image, forKey: "imageBanner")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Couldn't save. \(error), \(error.userInfo)")
                }
            }
        }
        
    }
    
    func deleteFavouriteGame(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
               batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
