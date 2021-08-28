//
//  ZadatVoprosQuestionData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 03.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct ZadatVoprosQuestionData : Decodable{
    
    let error : Bool
    let code : Int
    let answer : [ZadatVoprosAnswerData]
    
}

struct ZadatVoprosAnswerData : Decodable {
    
    let id : String
    let name : String
    
}
