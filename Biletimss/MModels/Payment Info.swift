//
//  Payment Info.swift
//  Biletimss
//
//  Created by Ece Ok, Vodafone on 16.12.2023.
//

import Foundation
struct PaymentInfo : Codable {
    var ticketInfo : TicketBefore?
    var cardName: String?
    var cardNo : String?
    var cardMonth: String?
    var cardYear : String?
    var cardCnn : String?
    
    init(ticketInfo: TicketBefore? = nil, cardName: String? = nil, cardNo: String? = nil, cardMonth: String? = nil,cardYear: String? = nil, cardCnn: String? = nil) {
        self.ticketInfo = ticketInfo
        self.cardName = cardName
        self.cardNo = cardNo
        self.cardMonth = cardMonth
        self.cardYear = cardYear
        self.cardCnn = cardCnn
    }
    
}
struct TicketBefore : Codable{
    let eventCode:String
    let eventName:String
    let eventDate:String
    let eventTime:String
    let eventPrice : Int
    var seat : Seat
    
}
