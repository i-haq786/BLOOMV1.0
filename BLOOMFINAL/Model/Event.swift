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
    //var imageURL: URL?
    var imgID: String = ""
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
        case venue
        case name
        //case imageURL
        case description
        case date
  //      case interests
        case userName
        case userUID
    }
}
