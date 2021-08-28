//
//  WebinarDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 25.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol WebinarDataManagerDelegate {
    func didGetWebinarData(data : WebinarData)
    func didFailGettingWebinarDataWithError(error : String)
}

struct WebinarDataManager {
    
    var delegate : WebinarDataManagerDelegate?
    
    func getWebinarData(token : String , webinarId : String){
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=getwebinars&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&id=\(webinarId)"
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailGettingWebinarDataWithError(error: error!.localizedDescription)
                    return
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(WebinarData.self, from: safeData)
                        
                        self.delegate?.didGetWebinarData(data: decodedData)
                        
                    }
                }catch{
                    self.delegate?.didFailGettingWebinarDataWithError(error: error.localizedDescription)
                }
                
                
            }
            
            task.resume()
            
        }
        
    }
    
}
