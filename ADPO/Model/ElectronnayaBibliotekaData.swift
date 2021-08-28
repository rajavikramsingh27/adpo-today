//
//  electronnayaBibliotekaData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 24.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct ElectronnayaBibliotekaData : Decodable{
    
    let code : Int
    let answer : [ElectronnayaBibliotekaDataAnswer]
    let errorText : String
    
}

struct ElectronnayaBibliotekaDataAnswer : Decodable{
    
    let count : Int
    let page : Int
    let perpage : Int
    let list : [ElectronnayaBibliotekaDataAnswerWebinar]
    
}

struct ElectronnayaBibliotekaDataAnswerWebinar : Decodable {
    
    let id : String
    let title : String
    let author : String
    let video : String
    let poster : String?
    let description : String
    let shorttitle : String
    let author_pic : String
    let videohttps : String
}
