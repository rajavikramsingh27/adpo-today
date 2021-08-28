//
//  ZadatVoprosQuestionDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 03.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol ZadatVoprosQuestionDataManagerDelegate {
    func didGetQuestions(data : ZadatVoprosQuestionData)
    func didFailWithError(error : String)
}

struct ZadatVoprosQuestionDataManager {
    
    var delegate : ZadatVoprosQuestionDataManagerDelegate?
    
    func getQuestions(){
        
        let session = URLSession(configuration: .default)
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?salt=HGDGJHSJSJJSJ7777ssd&method=getallthemesforquestions"
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: "Error with fetching zadat vopros question data from web")
                    return
                }
                
                do {
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(ZadatVoprosQuestionData.self, from: safeData)
                        
                        if decodedData.error && decodedData.code != 200 {
                            self.delegate?.didFailWithError(error: "Error with fetching zadat vopros question data")
                            return
                        }
                        
                        self.delegate?.didGetQuestions(data: decodedData)
                    }
                    
                    
                }catch{
                    self.delegate?.didFailWithError(error: "Error witg decoding json for zadat vopros question data")
                }
                
            }
            
            task.resume()
        }
        
    }
    
}
