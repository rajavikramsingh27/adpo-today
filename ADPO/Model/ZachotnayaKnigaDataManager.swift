//
//  ZachotnayaKnigaDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 26.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol ZachotnayaKnigaDataManagerDelegate {
    func didGetZachotnayaKnigaData(data : ZachotnayaKnigaData)
    func didFailGettingZachotnayaKnigaDataWithError(error : String)
}

struct ZachotnayaKnigaDataManager {
    
    var delegate : ZachotnayaKnigaDataManagerDelegate?
    
    func getWebinarData(token : String ){
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=getgrades&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&id=0"
        
        print("URL STRING FOR ZACHOTKA \(urlString)")
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailGettingZachotnayaKnigaDataWithError(error: error!.localizedDescription)
                    return
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(ZachotnayaKnigaData.self, from: safeData)
                        
                        self.delegate?.didGetZachotnayaKnigaData(data: decodedData)
                        
                    }
                }catch{
                    self.delegate?.didFailGettingZachotnayaKnigaDataWithError(error: error.localizedDescription)
                }
                
                
            }
            
            task.resume()
            
        }
        
    }
    
}
