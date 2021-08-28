//
//  ProgramsListData.swift
//  ADPO
//
//  Created by Sam on 16.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation


struct ProgramListData : Decodable{
    let error : Bool
    let code : Int
    let answer : [ProgramListAnswer]
}

struct ProgramListAnswer : Decodable{
    let id : String
    let name : String
    let isfacult : String
}
