//
//  ElectronnayaBibliotekaDataManager.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 24.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol ElectronnayaBibliotekaDataManagerDelegate {
    func didGetElectronnayaBibliotekaData(data : ElectronnayaBibliotekaData)
    func didFailGettingElectronnayaBibliotekaDataWithError(error : String)
}

struct ElectronnayaBibliotekaDataManager {
    
    var delegate : ElectronnayaBibliotekaDataManagerDelegate?
    
    func getElectronnayaBibliotekaAnswer(token : String){
        
        let urlString = "https://sdo.adpo.edu.ru/local/api/mobile.php?method=getwebinars&salt=HGDGJHSJSJJSJ7777ssd&token=\(token)&startUrl=https://sdo.adpo.edu.ru/"
        
        print("\(urlString) EB URL STRING")
        
        let session = URLSession(configuration: .default)
        
        if let url = URL(string: urlString){
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailGettingElectronnayaBibliotekaDataWithError(error: error!.localizedDescription)
                    return
                }
                
                do{
                    
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        
                        let decodedData = try decoder.decode(ElectronnayaBibliotekaData.self, from: safeData)
                        
                        self.delegate?.didGetElectronnayaBibliotekaData(data: decodedData)
                        
                    }
                    
                }catch{
                    
                    self.delegate?.didFailGettingElectronnayaBibliotekaDataWithError(error: error.localizedDescription)
                    
                }
                
            }
            
            task.resume()
        }
        
    }
    
}
