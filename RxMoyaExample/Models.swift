//
//  Models.swift
//  RxMoyaExample
//
//  Created by iMeraj-MacbookPro on 9/6/16.
//  Copyright © 2016 Sekai Lab BD. All rights reserved.
//

import Foundation
import Mapper

struct Repository: Mappable {
    let identifier: Int
    let language: String
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}

struct Issue: Mappable { 
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}