//
//  HostEventView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI

struct HostEventView: View {
    @State private var createNewEvent: Bool = false
    @State private var recentEvents: [Event] = []
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                EventContentView(events: $recentEvents)
            }.navigationTitle("Hosted Events")
                .padding()
                .overlay(alignment: .bottomTrailing){
                    Button {
                        createNewEvent.toggle()
                    } label:{
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.black, in:Circle())
                    }
                    .padding (15)
                }
                .fullScreenCover(isPresented: $createNewEvent){
                    CreateNewEvent{event in
                        
                    }
                }
        }
    }
}

struct HostEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostEventView()
    }
}
