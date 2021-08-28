//
//  Teacher.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 16.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift

class Teacher : Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var lastname : String = ""
    @objc dynamic var firstname : String = ""
    @objc dynamic var pictureurl : String = ""
    
    var parentLearningCourse = LinkingObjects(fromType: LearningCourse.self, property: "teachers")
    
}

//struct CourseTeacher : Decodable{
//    let id : String
//    let lastname : String
//    let firstname : String
//    let pictureurl : String
//}
