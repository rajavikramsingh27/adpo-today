//
//  ZachotnayaKnigaData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 26.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct ZachotnayaKnigaData : Decodable{
    
    let code : Int
    let answer : [ZachotnayaKnigaDataAnswer]
    let errorText : String
}

struct ZachotnayaKnigaDataAnswer : Decodable {
    
    let program_name : String
    let program_id : String
    let program_grades : [ZachotnayaKnigaDataAnswerGrades]
    
}

struct ZachotnayaKnigaDataAnswerGrades  : Decodable {
    
    let course_name : String
    let name : String
    let ball : Int
    let litter : String
    
}
