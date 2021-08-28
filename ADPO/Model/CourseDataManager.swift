//  CourseDataManager.swift
//  ADPO

//  Created by Sam on 22.07.2020.
//  Copyright © 2020 Sam. All rights reserved.

import Foundation

protocol CourseListDataDelegate {
    func didGetCourseData(data : CourseData )
    func didFailWithError(error : String)
}

struct CourseDataManager {
    var delegate : CourseListDataDelegate?
    
    func getCourses(token : String) {
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=eduplan&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&id=0"
//        print("\(urlString) URL STRING")
        
        let url = URL(string: urlString)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.delegate?.didFailWithError(error: error!.localizedDescription)
                return
            }
            
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    
                    let decodedData = try decoder.decode(CourseData.self, from: safeData)
                    
                    if !decodedData.error && decodedData.code != 200{
                        print("There was an error on webSite when getting courses info")
                        self.delegate?.didFailWithError(error: "There was an error on webSite when getting courses info")
                        return
                    }
                    
                    self.delegate?.didGetCourseData(data: decodedData)
                } catch {
                    print(error.localizedDescription)
                    self.delegate?.didFailWithError(error: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
}
