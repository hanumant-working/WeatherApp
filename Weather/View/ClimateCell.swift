//
//  ClimateCell.swift
//  Weather
//
//  Created by Hanumant S on 20/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import UIKit

class ClimateCell: UICollectionViewCell {
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblRainfall: UILabel!
    
    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEPT", "OCT", "NOV", "DEC"]
    var weather: Weather! {
        didSet{
            lblMonth.text = months[Int(weather.month - 1)]
            weather.minTemprature == 0 ? (lblMin.text = "NA") : (lblMin.text = String(format: "%.1f°", weather.minTemprature))
            weather.maxTemprature == 0 ? (lblMax.text = "NA") : (lblMax.text = String(format: "%.1f°", weather.maxTemprature))
            weather.rainfall == 0 ? (lblRainfall.text = "NA") : (lblRainfall.text = String(format: "%.1fmm", weather.rainfall))
        }
    }
    

}
