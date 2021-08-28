//
//  Auth.swift
//  ADPO
//
//  Created by Sam on 16.07.2020.
//  Copyright © 2020 Sam. All rights reserved.

import Foundation

protocol AuthManagerDelegate {
    func didGetLoginData(data : LoginData)
    func didFailWithError(_ error : String)
    //  func didGetErrorFromWebsite(data : LoginData)
}

struct AuthManager {
    
    var delegate : AuthManagerDelegate?
    
    func getLoginData(userName : String , password : String) {
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=auth&username=\(userName)&password=\(password)&salt=HGDGJHSJSJJSJ7777ssd&debug=1"
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{ //Checking for errors
                    print("Something went wrong with URLSession , \(error!.localizedDescription)")
                    self.delegate?.didFailWithError(error!.localizedDescription)
                    return
                }
                
                
                if let safeData = data{
                    do {
                        
                        let decoder = JSONDecoder() // Creating a JSON decoder
                        
                        let decodedData = try decoder.decode(LoginData.self, from: safeData) //Getting data in LoginData model
                        
                        if  decodedData.error && decodedData.code != 200{ //Checking for errors
                            print("Error with getting token")
                            self.delegate?.didFailWithError("Error with getting token")
                            return
                        }
                        
                        let token = decodedData.answer.token
                        
                        print(token)
                        
                        self.delegate?.didGetLoginData(data: decodedData) //Sending data to delegate
                        
                    } catch{
                        self.delegate?.didFailWithError(error.localizedDescription)
                        return
                    }
                }
            }
            
            task.resume()
        }else{
            delegate?.didFailWithError("Error with URL")
            print("Error with URL")
        }
    }
    
}


