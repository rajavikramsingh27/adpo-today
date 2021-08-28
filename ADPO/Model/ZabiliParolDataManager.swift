//
//  ZabiliParolDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 12.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol ZabiliParolDataManagerDelegate {
    func didGetZabiliParolData(data : ZabiliParolData)
    func didFailZabiliParolWithError(error : String)
}

struct ZabiliParolDataManager {
    
    var delegate : ZabiliParolDataManagerDelegate?
    
    func getZabiliParolAnswr(username : String){
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?salt=HGDGJHSJSJJSJ7777ssd&method=forgotpassword&username=\(username)"
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    
                    self.delegate?.didFailZabiliParolWithError(error: error!.localizedDescription)
                    return
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(ZabiliParolData.self, from: safeData)
                        
                        
                        self.delegate?.didGetZabiliParolData(data: decodedData)
                        
                    }
                    
                }catch{
                    self.delegate?.didFailZabiliParolWithError(error: error.localizedDescription)
                }
                
            }
            
            task.resume()
            
        }
    }
    
}
