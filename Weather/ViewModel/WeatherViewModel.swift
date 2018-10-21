//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Hanumant S on 20/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import UIKit

class WeatherViewModel: NSObject {

    private let basePath = "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice/"
    
    var country = String() {
        didSet{
            setLocationId()
        }
    }
    
    var rainfallURL: URL? {
        return URL(string: "\(basePath)Rainfall-\(country).json")
    }
    private var minTempURL: URL? {
        return URL(string: "\(basePath)Tmin-\(country).json")
    }
    private var maxTempURL: URL? {
        return URL(string: "\(basePath)Tmax-\(country).json")
    }
    
    var weatherData: [Weather]?
    var locationId: Int = 0
    
    func invokeWeatherData(completion: @escaping() -> Void ) {
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            guard let rainURL = self.rainfallURL else {
                fatalError("Wrong RainFall URL")
            }
        
            NetworkManger.invokeService(url: rainURL) { (data, errorMessage) in
                if data != nil {
                    DispatchQueue.main.async {
                        CoreDataManager.saveWeatherData(json: data!, location: Locations(rawValue: self.locationId)!, metrics: .rainfall, completion: {
                            self.setWeatherData()
                            completion()
                        })
                    }
                }
            }
        }
        
        queue.async {
            guard let minURL = self.minTempURL else {
                fatalError("Wrong min temp URL")
            }
            NetworkManger.invokeService(url: minURL) { (data, errorMessage) in
                if data != nil {
                    DispatchQueue.main.async {
                        CoreDataManager.saveWeatherData(json: data!, location: Locations(rawValue: self.locationId)!, metrics: .tMin, completion: {
                            self.setWeatherData()
                            completion()
                        })
                    }
                }
            }
        }
        
        
        queue.async {
            guard let maxURL = self.maxTempURL else {
                fatalError("Wrong max temp URL")
            }
            NetworkManger.invokeService(url: maxURL) { (data, errorMessage) in
                if data != nil {
                    DispatchQueue.main.async {
                        CoreDataManager.saveWeatherData(json: data!, location: Locations(rawValue: self.locationId)!, metrics: .tMax, completion: {
                            self.setWeatherData()
                            completion()
                        })
                    }
                }
            }
        }
  
    }
    
    // Fetch all weather data of selected location
    func setWeatherData() {
        let pred = NSPredicate(format: "locationId == %d", argumentArray: [self.locationId])
        self.weatherData = CoreDataManager.fetchEntity(entityClass: Weather.self, setPredicate: pred, fetchLimit: 0, sortByKey: "year") as? [Weather]
    }
 
    func getNumberOfMonths(in year: Int) -> Int {
        return weatherData?.filter{ $0.year == year }.count ?? 0
    }
    
    func getWeatherDataOfYear(year: Int) -> [Weather]? {
        // Sort Months from 1 to 12
        let array = (self.weatherData?.filter{$0.year == year})?.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.month > obj2.month
        })
        return array?.reversed()
    }
    
    // Set location id in numeric format for respective country
    func setLocationId() {
        switch country {
        case "UK":
            locationId = Locations.UK.rawValue
        case "England":
            locationId = Locations.England.rawValue
        case "Scotland":
            locationId = Locations.Scotland.rawValue
        case "Wales":
            locationId = Locations.Wales.rawValue
        default:
            fatalError("Not Matching Location")
        }
    }

}
