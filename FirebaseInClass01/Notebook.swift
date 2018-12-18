//
//  Notebook.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/*Assignment : InClass05
 FileName : Notebook.swift
 Name: Prerana Singh
 */


import Foundation

class Notebook{
    var name:String = ""
    var createdTime: String = ""
    var bookId:String = ""
    
    init(name:String,createdTime:String,bookId:String) {
        self.name = name
        self.createdTime = createdTime
        self.bookId = bookId
    }
    
    init() {}
    
    var description:String{
        return "\(name),\(createdTime))"
    }
}

