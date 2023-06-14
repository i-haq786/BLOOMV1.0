//
//  PassesView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 14/06/23.
//

import SwiftUI

struct PassesView: View {
    
    let passData = [
        PassData(poster: Image("Image 10"), name: "Devfest 2022", organizer: "GDG Chennai", time: "1:30 PM", day: "SAT, 11 July", venue: "Infosys, Shollinganallur", bookingId: "IXJK000457865CJ83", topicName: "Introduction to Flutter", stacks: "State Management, API Integration", personsCount: 2, cost: 620)
    ]
    
    var body: some View {
        VStack {
            ForEach(passData, id: \.bookingId) { data in
                PassView(data: data)
            }
        }
    }
}

struct PassesView_Previews: PreviewProvider {
    static var previews: some View {
        PassesView()
    }
}
