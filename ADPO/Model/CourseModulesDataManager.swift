//
//  CourseModulesDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 18.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol CourseModulesDataManagerDelegate {
    func didGetCourseModulesData (data : CourseModulesData)
    func didFailWithErrorCourseModulesData(error : String)
}

struct CourseModulesDataManager {
    
    var delegate : CourseModulesDataManagerDelegate?
    
    func getCourseModules (courseId : String , token : String){
        
        let session = URLSession(configuration: .default)
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=getcourse&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&id=\(courseId)"
        
        print("\(urlString) URL STRING FOR COURSE MODULES")
        
        let url = URL(string: urlString)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                self.delegate?.didFailWithErrorCourseModulesData(error: error!.localizedDescription)
                return
            }
            
            do{
                
                let decoder = JSONDecoder()
                
                if let safeData = data{
                    
                    let decodedData = try decoder.decode(CourseModulesData.self, from: safeData)
                    
                    self.delegate?.didGetCourseModulesData(data: decodedData)
                }
            }catch{
                
                self.delegate?.didFailWithErrorCourseModulesData(error: error.localizedDescription)
                
            }
            
        }
        
        task.resume()
        
        
        
        
    }
    
}
