//
//  CoreDataService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import CoreData

class CoreDataService {
    
    static let sharedInstance = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TASK-WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

extension CoreDataService {
    
    func saveContext () {
        
        let managedContext = persistentContainer.viewContext
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func get(_ option: SavedCitiesOptions) -> [CityWeather]? {
        
        let managedContext = persistentContainer.viewContext
        
        let request = CityWeather.fetchRequest() as NSFetchRequest<CityWeather>
        
        switch (option) {
        
        case .all:
            break
        case .byId(let id):
            request.predicate = NSPredicate(format: "id == \(id)")
            break
        }
        
        do {
            let savedCities = try managedContext.fetch(request)
            
            return savedCities
            
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    func save(_ item: WeatherInfo) {
        
        let managedContext = persistentContainer.viewContext
        
        let city = CityWeather(context: managedContext)
        
        city.setValue(Int64(item.id), forKey: "id")
        city.setValue(item.cityName, forKey: "name")
        
        saveContext()
    }
    
    func delete(_ id: Int64) {
        
        if let savedMovie = get(.byId(id: id))?.first {
            
            let managedContext = persistentContainer.viewContext
            
            managedContext.delete(savedMovie)
            
            saveContext()
        }
    }
    
    
    func deleteAll() {
        
        if let toDelete = get(.all) {
            
            for city in toDelete {
                delete(Int64(city.id))
            }
        }
    }
}



