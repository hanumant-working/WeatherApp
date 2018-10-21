//
//  RegionsViewController.swift
//  Weather
//
//  Created by Hanumant S on 18/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import UIKit

class RegionsViewController: UIViewController {

    
    @IBOutlet weak var tblRegionList: UITableView! {
        didSet{
            tblRegionList.estimatedRowHeight = 90
            tblRegionList.rowHeight = UITableView.automaticDimension
        }
    }
    
    var regionsList: [String] {
        return ["UK", "England", "Scotland", "Wales"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
}


extension RegionsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionsList.count
    }
}

extension RegionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = regionsList[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let weatherVC = storyboard?.instantiateViewController(withIdentifier: "WeatherDataViewController") as! WeatherDataViewController
        weatherVC.country = regionsList[indexPath.row]
        navigationController?.pushViewController(weatherVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
