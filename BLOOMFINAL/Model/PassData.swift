//
//  PassData.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 14/06/23.
//

import SwiftUI

struct PassData: Identifiable {
    let id = UUID()
    let poster: Image
    let name: String
    let organizer: String
    let time: String
    let day: String
    let venue: String
    let bookingId: String
    let topicName: String
    let stacks: String
    let personsCount: Int
    let cost: Int
}
