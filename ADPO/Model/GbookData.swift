//
//  GbookData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 02.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct GbookData : Decodable{
    
    let code : Int
    let answer : [GbookDataAnswer]
    let errorText : String
    
}

struct GbookDataAnswer : Decodable{
    
    let id : String
    let name : String
    let count : String
    let current : String
    let pages : [GbookDataPage]
    
}

struct GbookDataPage : Decodable {
    let url : String
    let num : Int
}
