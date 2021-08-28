//
//  LearningProgram.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 13.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift


//This is a Realm DB Class for learning program
class LearningProgram : Object{
    
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var isfacult : String = ""
    
//    var courses = List<LearningCourse>()
}
