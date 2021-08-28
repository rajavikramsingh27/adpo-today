//
//  Login.swift
//  ADPO
//
//  Created by Sam on 16.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct LoginData : Decodable{
    let error : Bool
    let code : Int
    let answer : LoginAnswer
}

struct LoginAnswer : Decodable{
    let token : String
}

