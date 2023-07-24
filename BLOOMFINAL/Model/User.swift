//
//  User.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
  @DocumentID var id: String?
    var userName: String
    var userEmail: String
    var userUID: String
    var userNumber: String
    var interests: [String]?
    
    enum CodingKeys: CodingKey{
        case id
        case userName
        case userEmail
        case userUID
        case userNumber
        case interests
    }
}
