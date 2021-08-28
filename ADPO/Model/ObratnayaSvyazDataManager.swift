//
//  ObratnayaSvyazDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 03.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol ObratnayaSvyazDataManagerDelegate {
    
    func didGetAnswer(answer : ObratnayaSvyazData)
    func didFailObratnayaSvyazWithError(error : String)
    
}

struct ObratnayaSvyazDataManager {
    
    var delegate : ObratnayaSvyazDataManagerDelegate?
    
    func getAnswer(urlString : String , params : [String : Any] ){
        
//        let params = ["salt" : "HGDGJHSJSJJSJ7777ssd" ,
//                      "method" : "sendquestion" ,
//                      "fio" : "SAM SAM SAM" ,
//                      "email" : "sam912@mail.ru" ,
//                      "text" : "Hello Hello " ,
//                      "who" : "7"]
        
        if let url = URL(string: urlString){
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
            
            request.httpBody = httpBody
            
            let session = URLSession.shared
            
            session.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailObratnayaSvyazWithError(error: error!.localizedDescription)
                    return
                }
                
                if let safeResponse = response{
                    print(response)
                }
                
                if let safeData = data{
                    
                    do{
                        
                        let decodedData = try JSONDecoder().decode(ObratnayaSvyazData.self, from: safeData)
                        
                        print(decodedData)
                        
                        self.delegate?.didGetAnswer(answer: decodedData)
                        
                    }catch{
                        self.delegate?.didFailObratnayaSvyazWithError(error: error.localizedDescription)
                    }
                    
                }
                
            }.resume()
        }
    }
    
}
