//
//  DeviceTokenAnswerDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 24.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation


protocol DeviceTokenAnswerDataManagerDelegate {
    func didGetDeviceTokenDataAnswer(data : DeviceTokenAnswerData)
    func didFailGettingDeviceTokenDataAnswerWithError(error : String)
}

struct DeviceTokenAnswerDataManager {
    
    var delegate : DeviceTokenAnswerDataManagerDelegate?
    
    func getDeviceTokenDataAnswer(deviceToken : String , token : String){
        
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=setfcmtoken&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&fcmtoken=\(deviceToken)"
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    
                    self.delegate?.didFailGettingDeviceTokenDataAnswerWithError(error: error!.localizedDescription)
                    return
                    
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(DeviceTokenAnswerData.self, from: safeData)
                        
                        self.delegate?.didGetDeviceTokenDataAnswer(data: decodedData)
                        
                    }
                    
                }catch{
                    self.delegate?.didFailGettingDeviceTokenDataAnswerWithError(error: "Error with decoding data from deviceTokenDataManager")
                }
                
            }
            
            task.resume()
            
        }
    }
    
    
}
