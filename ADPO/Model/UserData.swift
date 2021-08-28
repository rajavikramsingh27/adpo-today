//
//  UserData.swift
//  ADPO
//
//  Created by Sam on 27.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation


struct UserData : Decodable{
    let code : Int
    let answer : UserDataAnswer
    let errorText : String
}

struct UserDataAnswer : Decodable {
    let avatar : String
}
