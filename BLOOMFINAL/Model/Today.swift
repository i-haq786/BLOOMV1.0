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
    Today(name: "Pottery Making", description: "Discover the enchanting world of pottery with us and embark on a captivating artistic journey. Join our pottery experience and delve into the ancient art of molding clay into exquisite vessels while exploring your boundless creativity through intricate designs. Our skilled instructors, well-versed in the nuances of pottery, will accompany you throughout the process, imparting their expertise in hand-building techniques and the art of glazing. This hands-on event promises an unforgettable experience, allowing you to channel your inner artist and create unique ceramic pieces. Unleash your imagination, connect with the tactile nature of clay, and leave with cherished mementos crafted by your own hands.", bannerTitle: "Learn the ancient art of shaping clay",organiserTitle:"Pottery Street", pic: "pottery", venue: "SRM University"),
    Today(name: "App Fair", description: "SRM University's new iOS Development Center is a state-of-the-art facility dedicated to nurturing students in iOS app development. The center offers specialized courses, workshops, and training programs that provide hands-on experience in developing iOS apps using the latest technologies and frameworks. The curriculum covers various aspects of iOS app development, including user interface design, coding, debugging, and testing. Students have access to advanced hardware and software resources, creating an environment conducive to innovation and collaboration. The center fosters a supportive atmosphere where students can engage in discussions, seek guidance from experienced faculty, and collaborate on exciting app development projects. By establishing the iOS Development Center, SRM University emphasizes its commitment to preparing students for the digital future and equipping them with the skills and knowledge needed to excel in the competitive app development industry. The center serves as a launchpad for students to embark on successful careers as iOS developers, entrepreneurs, or tech innovators.", bannerTitle: "Learn innovation with fun",organiserTitle:"iOS Development Center", pic: "ios", venue: "Rajasthan"),
   
    
]
