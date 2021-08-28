//
//  GbookDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 02.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

//
//  ZachotnayaKnigaDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 26.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol GbookDataManagerDelegate {
    func didgetBooksData(data : GbookData)
    func didFailGettingGbookDataWithError(error : String)
}

struct GbookDataManager {
    
    var delegate : GbookDataManagerDelegate?
    
    func getBooksData(token : String , cmid : String ){
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?token=\(token)&method=gbooks&salt=HGDGJHSJSJJSJ7777ssd&id=\(cmid)"
        
        print("URL STRING FOR BOOKS \(urlString)")
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailGettingGbookDataWithError(error: error!.localizedDescription)
                    return
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(GbookData.self, from: safeData)
                        
                        self.delegate?.didgetBooksData(data: decodedData)
                        
                    }
                }catch{
                    self.delegate?.didFailGettingGbookDataWithError(error: error.localizedDescription)
                }
                
                
            }
            
            task.resume()
            
        }
        
    }
    
}

