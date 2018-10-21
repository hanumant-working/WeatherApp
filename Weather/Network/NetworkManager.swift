//
//  NetworkManager.swift
//  Weather
//
//  Created by Hanumant S on 19/10/18.
//  Copyright © 2018 Hanumant S. All rights reserved.
//

import Foundation
import UIKit

class NetworkManger {
    
    class func invokeService(url: URL, completion:@escaping ([Climate]?, String?) -> Void) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 90.0
        let task = URLSession.shared.downloadTask(with: request) { localURL, urlResponse, error in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil else {
                // Received error from server
                completion(nil, error?.localizedDescription)
                return
            }
        
            guard let fileURL = localURL else {
                completion(nil, nil)
                return
            }
            
            debugPrint(fileURL)
        
            do {
                let str = try String(contentsOf: fileURL)
                let data = str.data(using: .utf8)!
                do {
                    // Prase json using Codable protocol
                    let array = try JSONDecoder().decode([Climate].self, from: data)
                    // Return actual data
                    completion(array, nil)
                    
                } catch let error {
                    print("Decoding Error: \(error.localizedDescription)")
                }
            } catch let error {
                print("File Parse Error: \(error.localizedDescription)")
            }
    
        }
        
        task.resume()
    }

    
}

