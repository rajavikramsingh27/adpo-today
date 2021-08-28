//
//  ProgramGrade.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 27.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift


//This is a Realm DB Class for learning program grade
class ProgramGrade : Object{
    
    @objc dynamic var programName : String = ""
    @objc dynamic var programId : String = ""
    
    var program_grades = List<Grade>() //List of grade objects
}

