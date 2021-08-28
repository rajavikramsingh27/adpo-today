//
//  ZabiliParolData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 12.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct ZabiliParolData : Decodable{
    
    let code : Int
    let answer : String
    let errorText : String
    
}
