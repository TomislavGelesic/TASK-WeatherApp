//
//  CoreDataService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import CoreData
import Combine

class CoreDataService {
    
    static let sharedInstance = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TASK_WeatherApp")
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
    
    func get(_ option: SavedCitiesOptions) -> [WeatherInfo]? {
        
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
            
            var weatherInfo = [WeatherInfo]()
            
            for city in savedCities {
                
                weatherInfo.append(WeatherInfo(city))
            }
            return weatherInfo
            
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func get(id: Int64) -> [CityWeather]? {
        
        let managedContext = persistentContainer.viewContext
        
        let request = CityWeather.fetchRequest() as NSFetchRequest<CityWeather>
        
        request.predicate = NSPredicate(format: "id == \(id)")
        
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
        city.setValue(item.longitude, forKey: "longitude")
        city.setValue(item.latitude, forKey: "latitude")
        saveContext()
    }
    
    func save(_ item: Geoname) {
        
        let managedContext = persistentContainer.viewContext
        
        if let _ = get(id: Int64(item.id) ?? -1)?.first {
            
            return
        }
        else {
            let city = CityWeather(context: managedContext)
            
            city.setValue(Int64(item.id) ?? -1, forKey: "id")
            city.setValue(item.name, forKey: "name")
            city.setValue(item.longitude, forKey: "longitude")
            city.setValue(item.latitude, forKey: "latitude")
            saveContext()
        }
        
    }
    
    func delete(_ id: Int64) {
        
        if let savedMovie = get(id: id)?.first {
            
            let managedContext = persistentContainer.viewContext
            
            managedContext.delete(savedMovie)
            
            saveContext()
        }
    }
    
    func deleteAll() {
        
        if let toDelete = get(.all) {
            
            for city in toDelete {
                if let id = Int64(city.id) {
                    delete(id)
                }
            }
        }
    }
}



