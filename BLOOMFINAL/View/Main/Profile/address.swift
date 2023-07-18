//
//  address.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 16/06/23.
//

import SwiftUI

struct address: View {
    @State  var pro: User
    @State private var eventVenue: String = ""
    @State private var showingPicker = false

    
    var body: some View {
        VStack(spacing: 20){
           // TextField("Event Venue", text: $eventVenue, axis: .vertical)
            
            Button{
                showingPicker = true
            }label: {
                Image(systemName: "location.fill")
                    .font(.largeTitle).tint(.black)
            }
            .foregroundColor(Color("accent"))
            .mapItemPicker(isPresented: $showingPicker) { item in
                if let name = item?.name {
                    eventVenue = name
                }
            }
            Text("Click where you wish to host your event.")
                .font(.title2).tint(.black)
        }
        //.border(0.5, .black.opacity(0.2))
    }
}

//struct address_Previews: PreviewProvider {
//    static var previews: some View {
//        address()
//    }
//}
