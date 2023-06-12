//
//  Event.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Event: Identifiable,Codable{
    @DocumentID var id: String?

    var text: String
    var imageURL: URL?
    var eventID: String = ""
    var description: String = ""
    var date: Date = Date()
    var interests: [String] = []
    
    // MARK: Basic User Info
    var userName: String
    var userUID: String
    
    enum CodingKeys: CodingKey {
        case id
        case eventID
        case text
        case imageURL
        case date
        case interests
        case userName
        case userUID
    }
}
