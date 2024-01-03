//
//  Eevent Info.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import Foundation


struct MovieInfo:Codable{
    let eventCode:String
    let eventName:String
    let eventDescription:String
    let eventDate:[String]
    let eventTime: [String]
    let eventPrice:Int
    let category: Category
    
}

struct Category:Codable{
    let categoryName:String
}

