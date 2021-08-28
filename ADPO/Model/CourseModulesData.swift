//
//  CourseModulesData.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 18.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation


struct CourseModulesData : Decodable{
    
    let code : Int
    let answer : [CourseModulesDataAnswer]
    let errorText : String
    
}

struct CourseModulesDataAnswer : Decodable{
    let course_id : String
    let course_shortname : String
    let course_fullname : String
    let modules : [CourseModule]
}

struct CourseModule : Decodable{
    
    let section_id : String
    let section_name : String
    let module_id : String
    let module_name : String
    let module_url : String
    let module_type : String
    let module_icon : String
    
}
