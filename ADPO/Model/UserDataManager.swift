//
//  UserDataManager.swift
//  ADPO
//
//  Created by Sam on 27.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol UserDataManagerDelegate {
    func didGetUserData(data : UserData)
    func didFailWithError(error : String)
}

struct UserDataManager {
    
    var delegate : UserDataManagerDelegate?
    
    func getUserData (token : String) {
        
        let session = URLSession(configuration: .default)
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&method=getuserinfo"
        
        let url = URL(string: urlString)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error: "\(error!.localizedDescription) ERROR WITH USER DATA")
            }
            
            do{
                let decoder = JSONDecoder()
                
                if let safeData = data{
                    
                    let decodedData = try decoder.decode(UserData.self, from: safeData)
                    
                    if decodedData.code != 200{
                        self.delegate?.didFailWithError(error: "Couldn't fetch user data ERROR WITH USER DATA")
                    }
                    
                    print(decodedData.answer.avatar)
                    
                    self.delegate?.didGetUserData(data: decodedData)
                }
            }catch{
                self.delegate?.didFailWithError(error: "\(error.localizedDescription) ERROR WITH USER DATA")
            }
            
        }
        
        task.resume()
        
    }
    
    
}

