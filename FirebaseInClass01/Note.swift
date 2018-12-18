//
//  Note.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/14/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/*Assignment : InClass05
 FileName : Note.swift
 Name: Prerana Singh
 */

import Foundation

class Note{
    var name:String = ""
    var createdTime: String = ""
    var noteId:String = ""
    
    init(name:String,createdTime:String,noteId:String) {
        self.name = name
        self.createdTime = createdTime
        self.noteId = noteId
    }
    
    init() {}
    
    var description:String{
        return "\(name),\(createdTime))"
    }
}
