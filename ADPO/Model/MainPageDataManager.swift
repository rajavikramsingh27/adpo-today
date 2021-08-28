//
//  MainPageDataManager.swift
//  ADPO
//
//  Created by Sam on 16.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation


protocol ProgramsListDataDelegate {
    func didGetProgramsData(data : ProgramListData)
    func didFailWithError()
}

struct MainPageDataManager {
    
    var delegate : ProgramsListDataDelegate?
    
    func getPrograms()  {
        
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: "token"){
            
            let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=getprograms&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)"
            
            let url = URL(string: urlString)
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url!) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError()
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    do{
                        let decoder = JSONDecoder()
                        
                        let decodedData = try decoder.decode(ProgramListData.self
                            , from: safeData)
                        
                        if decodedData.error && decodedData.code != 200{
                            self.delegate?.didFailWithError()
                            print("Error with fetching programs list data from web (")
                            return
                        }
                        
                        
                        
                        self.delegate?.didGetProgramsData(data: decodedData)
                        
                        //     print("\(decodedData) HELLO DECODED DATA")
                        
                    } catch{
                        print(error.localizedDescription)
                        self.delegate?.didFailWithError()
                    }
                }
            }
            
            task.resume()
            
        }else{
            delegate?.didFailWithError()
            print("Error with token")
        }
        
        
    }
    
}
