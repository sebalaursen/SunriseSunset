//
//  fetchSunInfo.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

class FetchSunInfo {
    
    let requestedURL: RequestURL
    
    init(url: RequestURL) {
        self.requestedURL = url
    }
    
    func fetch(completion: @escaping (_ resSunInfo: SunInfo?) -> () ) {
        //print(requestedURL.url.string)
        guard let url = URL(string: requestedURL.url.string!) else { return  }
        
        URLSession.shared.dataTask(with: url) { (data,_ ,err) in
            DispatchQueue.main.async {
                if err != nil {
                    print("Failed to fentch data from url ", url)
                    return
                }
                else {
                    guard let data = data else { return }
                    
                    do {
                        let res = try JSONDecoder().decode(result.self, from: data)
                        let resSunInfo = res.results
                        return completion(resSunInfo)
                    } catch let jsonErr {
                        print("Failed to decode JSON ", jsonErr)
                    }
                }
            }
        }.resume()
    }
}
