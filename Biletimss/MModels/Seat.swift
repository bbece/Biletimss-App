//
//  Seat.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import Foundation


struct AreasInfo : Codable {
    let eventCode:String
    let eventName:String
    let eventDate:[String]
    let eventTime: [String]
    let eventPrice: Int
    let areas : [Area]
}

struct Area : Codable {
    let areaName: String
    let seats : [Seat]
    
}
struct Seat : Codable {
    let eventCode : String
    let seatCode : String
    var status : String
    
}
