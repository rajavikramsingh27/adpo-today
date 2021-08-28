//
//  Ifer.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 16.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift

class Ifer : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var access : Bool = false
    
    var parentLearningCourse = LinkingObjects(fromType: LearningCourse.self, property: "ifer")
    
}
