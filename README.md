# WeatherApp

Implemented this assignment in swift 4.2 using Xcode 10 below some details:

Network Request: URLSession

Local Storage: Core Data

Design Pattern: MVVM

JSON Parsing: Codable Protocol


1. Implemented API call using URLSession in NetworkManager.swift file
2. When user select a location then fetch the file of minimum temperature, maximum temprature and rainfall on background queue.
3. Used Codable protocol and parsed json from temprary stored file.
4. Stored all the parsed object into Weather entity of Core Data.
5. Displayed above data on collection view by year wise.
5. Allow user to search data using year.
6. Allow user to pull to refresh the data.
7. Write some functions for Unit Testing.


Lazy loading is remaing: There is heavy collection of data so I can fetch some batch of records (ex. 50) from the core data and display it to user.










