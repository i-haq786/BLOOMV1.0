//
//  ExploreView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var recentEvents: [Event] = []
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                EventContentView(events: $recentEvents)
                
            }.navigationTitle("Events")
                .padding()
                .background(Color("background"))
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
