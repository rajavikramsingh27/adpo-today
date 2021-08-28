//
//  File.swift
//  ADPO
//
//  Created by Sam on 22.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct CourseData : Decodable {
    let error : Bool
    let code : Int
    let answer : [CourseAnswer]
}

struct CourseAnswer : Decodable {
    let courseid : String
    let url : String
    let name : String
    let available : Bool
    let iscompleted : Bool
    let pid : String
    let teachers : [CourseTeacher]
    let ifer : [CourseIfer]
}

struct CourseTeacher : Decodable{
    let id : String
    let lastname : String
    let firstname : String
    let pictureurl : String
}

struct CourseIfer : Decodable {
    let name : String
    let access : Bool
}
