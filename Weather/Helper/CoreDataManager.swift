//
//  DBMapper.swift
//  Weather
//
//  Created by Hanumant S on 20/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
   class func fetchEntity<T: NSManagedObject>(entityClass:T.Type, setPredicate:NSPredicate? = nil, fetchLimit:Int = 0, sortByKey: String? = nil) -> [AnyObject] {
        let entityName = String(describing: entityClass)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    
        // Check fetch predicate
        if setPredicate != nil {
            fetchRequest.predicate = setPredicate
        }
        
        fetchRequest.returnsObjectsAsFaults = false
    
        // Check fetch limit
        if fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
    
        // Sort object by key
        if sortByKey != nil {
            let sectionSortDescriptor = NSSortDescriptor(key: sortByKey, ascending: false)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        var result:[AnyObject] = []
        do {
            result = try APP_DELEGATE.MOC.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("error in fetchrequest is",error)
            result = []
        }
        return result
    }
    
   class func saveWeatherData(json: [Climate], location: Locations, metrics: Metrics, completion: () -> Void) {
        let storedData = fetchEntity(entityClass: Weather.self) as! [Weather]
        debugPrint("***** \(json.count) : \(location)")
        for data in json {
            let filterObjs = storedData.filter { $0.year == data.year && $0.locationId == location.rawValue && $0.month ==  data.month}
            if filterObjs.isEmpty {
                // Insert Record
                let obj = (NSEntityDescription.insertNewObject(forEntityName: "Weather", into: APP_DELEGATE.MOC) as! Weather)
                obj.save(data, loc: location, metrics: metrics)
            } else {
                // Update Record
                filterObjs.first?.save(data, loc: location, metrics: metrics)
            }
        }
        
        do {
            try APP_DELEGATE.MOC.save()
        } catch let error as NSError  {
            print("error in save weather : \(error),  #####info:\(error.userInfo)")
            fatalError("Save DB Error")
        }
        
        completion()
    }

}






