//
//  WeatherDataViewController.swift
//  Weather
//
//  Created by Hanumant S on 18/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import UIKit

class WeatherDataViewController: UIViewController {

    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet var weatherViewModel: WeatherViewModel!
    
    var country: String!
    var years = [Int16]()
    var filtered = [Int16]()
    var filterring = false
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
    
        setData()
        setupUI()
    }
    
    @objc func setData() {
        weatherViewModel.country = self.country
        weatherViewModel.setWeatherData()
        
        // Call API when data is empty or after pull to refresh
        if (weatherViewModel.weatherData?.isEmpty ?? true) || (refreshControl.isRefreshing) {
            weatherViewModel.invokeWeatherData { [unowned self] in
                self.reloadCollectionView()
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        } else {
           reloadCollectionView()
        }
    }
    
    // Set search bar for searching weather data by year.
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.definesPresentationContext = true
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.placeholder = "Search Year"
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Set Refresh Control
        refreshControl.addTarget(self, action:#selector(WeatherDataViewController.setData), for: .valueChanged)
        weatherCollectionView.addSubview(refreshControl)
    }
    
    func reloadCollectionView() {
        guard let wData = self.weatherViewModel.weatherData, wData.count > 0 else {
            debugPrint("Empty Data")
            return
        }
        
        let allYears = self.weatherViewModel.weatherData?.compactMap{ $0.year } ?? []
        // Get Unique years from the data and sort it.
        self.years = (Array(Set(allYears)).sorted()).reversed()
        self.weatherCollectionView.reloadData()
    }

}


extension WeatherDataViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterring == true ? filtered.count : years.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemsCount = 0
        if filterring {
            itemsCount = weatherViewModel.getNumberOfMonths(in: Int(filtered[section]))
        } else {
            if years.count > 0 {
                itemsCount = weatherViewModel.getNumberOfMonths(in: Int(years[section]))
            }
        }
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Set Year to header view
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath)
            let lblTitle = headerView.viewWithTag(1) as! UILabel
            lblTitle.text = filterring == true ? "\(filtered[indexPath.section])" : "\(years[indexPath.section])"
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension WeatherDataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClimateCell", for: indexPath) as! ClimateCell
        var sectionYear: Int16 = 0
        if filterring {
            sectionYear = filtered[indexPath.section]
        } else {
            sectionYear = years[indexPath.section]
        }
        
        // Get 12 months data of |sectionYear|
        let oneYearWeatherArray = weatherViewModel.getWeatherDataOfYear(year: Int(sectionYear))
        cell.weather = oneYearWeatherArray![indexPath.item]
        return cell
    }
    
}

extension WeatherDataViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width/3) - 8
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
}




extension WeatherDataViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            if let enteredYear = Int16(text) {
                self.filtered = years.filter{ $0 == enteredYear}
            }
            self.filterring = true
        } else {
            self.filterring = false
            self.filtered = []
        }
        self.weatherCollectionView.reloadData()
    }
    
}
