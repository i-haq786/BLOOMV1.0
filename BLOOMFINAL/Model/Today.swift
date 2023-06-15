//
//  Today.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 15/06/23.
//

import SwiftUI


struct Today: Identifiable, Codable{
    var id = UUID()
    var name: String
    var description: String
    var bannerTitle: String
    var organiserTitle: String
    var pic: String
    var venue: String
    var date: Date?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case bannerTitle
        case organiserTitle
        case pic
        case venue
        
    }
}


var todayItems: [Today] = [
    Today(name: "Pottery Making", description: "Join us for a captivating pottery experience where you'll learn the ancient art of shaping clay into beautiful vessels and express your creativity through intricate designs. Our expert instructors will guide you through the pottery-making process, from hand-building techniques to glazing, ensuring a hands-on and memorable event for all participants.", bannerTitle: "Learn the ancient art of shaping clay",organiserTitle:"Pottery Street", pic: "pottery", venue: "SRM University"),
    Today(name: "App Fair", description: "Join us for a captivating pottery experience where you'll learn the ancient art of shaping clay into beautiful vessels and express your creativity through intricate designs. Our expert instructors will guide you through the pottery-making process, from hand-building techniques to glazing, ensuring a hands-on and memorable event for all participants.", bannerTitle: "learn the ancient art of shaping clay",organiserTitle:"iOS Development Center", pic: "ios", venue: "Rajasthan"),
   
    
]
