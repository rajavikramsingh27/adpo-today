//
//  Grade.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 27.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import RealmSwift


//This is a Realm DB Class for learning program grade
class Grade : Object{
    
    @objc dynamic var course_name : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var ball : Int = 0
    @objc dynamic var litter : String = ""
    
}

