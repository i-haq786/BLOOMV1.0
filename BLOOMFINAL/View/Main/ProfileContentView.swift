//
//  ProfileContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI

struct ProfileContentView: View {
    var user: User
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(alignment: .leading){
                VStack(alignment: .leading ,spacing: 6) {
                    Text(user.userName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(user.userEmail)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(user.userNumber)
                        .font(.caption)
                        .foregroundColor(.gray)
                }.padding(.leading)
            }.hAlign(.leading)
        }
    }
}
