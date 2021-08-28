//
//  Course.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 13.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift

class LearningCourse : Object {
    
    @objc dynamic var courseid : String = ""
    @objc dynamic var url : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var available : Bool = false
    @objc dynamic var iscompleted : Bool = false
    @objc dynamic var pid : String = ""
    
    var teachers = List<Teacher>()
    var ifer = List<Ifer>()
    
}

//
//struct CourseAnswer : Decodable {
//    let courseid : String
//    let url : String
//    let name : String
//    let available : Bool
//    let iscompleted : Bool
//    let pid : String
//    let teachers : [CourseTeacher]
//    let ifer : [CourseIfer]
//}
//
//struct CourseTeacher : Decodable{
//    let id : String
//    let lastname : String
//    let firstname : String
//    let pictureurl : String
//}
//
//struct CourseIfer : Decodable {
//    let name : String
//    let access : Bool
//}
