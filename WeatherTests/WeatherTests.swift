//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Hanumant S on 18/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

}


class NetworkTest: XCTestCase {
    
    let viewModelObj = WeatherViewModel()
    
    func testDataResponse() {
        self.measure {
            NetworkManger.invokeService(url: viewModelObj.rainfallURL!, completion: { (data, error ) in
            })
        }
        
    }
    
    func testValidateURL() {
        if let url = viewModelObj.rainfallURL {
            XCTAssertNotNil(url)
        } else {
            XCTAssertNil(viewModelObj.rainfallURL)
        }
    }
    
}

class ViewControllerTest: XCTestCase {
    
    func testWeatherMonths() {
        let cell = ClimateCell()
        XCTAssertEqual(cell.months.count, 12)
    }
    
    func testRegionData() {
        let regionVC = RegionsViewController()
        XCTAssertNotEqual(regionVC.regionsList.count, 0)
    }

}
