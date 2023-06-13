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

    var name: String
    var imgID: String = ""
    var imgURL: URL?
    var venue: String
    var description: String
    var date: Date
   // var interests: [String]
    
    // MARK: Basic User Info
    var userName: String
    var userUID: String
    
    enum CodingKeys: CodingKey {
        case id
        case imgID
        case imgURL
        case venue
        case name
        case description
        case date
  //      case interests
        case userName
        case userUID
    }
}
