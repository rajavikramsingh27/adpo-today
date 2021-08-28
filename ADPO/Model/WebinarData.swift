//
//  WebinarData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 25.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct WebinarData : Decodable {
    
    let code : Int
    let answer: [WebinarDataAnswer]
    let errorText : String
    
}

struct WebinarDataAnswer : Decodable {
    
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
