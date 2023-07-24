//
//  PassData.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 14/06/23.
//

import SwiftUI
import FirebaseFirestoreSwift
struct PassData: Identifiable, Codable {
//    let id = UUID()
//    let poster: Image
//    let name: String
//    let organizer: String
//    let time: String
//    let day: String
//    let venue: String
//    let bookingId: String
//    let topicName: String
//    let stacks: String
//    let personsCount: Int
//    let cost: Int
///
    @DocumentID var id: String?
    var name: String
    var imgURL: URL?
    var venue: String
    var date: Date
    var cost: Double
    var bookingId: String
    
    enum CodingKeys: CodingKey{
        case id
        case name
        case imgURL
        case venue
        case date
        case cost
        case bookingId
    }
}
