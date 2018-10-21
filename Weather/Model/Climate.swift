//
//  Form.swift
//  Weather
//
//  Created by Hanumant S on 20/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import Foundation


// Json parsing model
struct Climate: Codable {
    let value: Double
    let year: Int16
    let month: Int16
    
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case year = "year"
        case month = "month"
    }
}


// Core Data Model extension
extension Weather {
    // Mapping json model data with core data model
    func save(_ formData: Climate, loc: Locations, metrics: Metrics) {
        locationId = Int16(loc.rawValue)
        year = formData.year
        month = formData.month
        
        switch metrics {
        case .rainfall:
            rainfall = formData.value
        case .tMax:
            maxTemprature = formData.value
        case .tMin:
            minTemprature = formData.value
        }
    }
}


enum Metrics: String {
    case tMin, tMax, rainfall
}


enum Locations: Int {
    case UK, England, Scotland, Wales
}

