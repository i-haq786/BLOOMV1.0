//
//  ExploreView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var recentEvents: [Event] = []
    @State private var activeTag: String = "Pottery"
    
    var body: some View {
        NavigationStack{
            VStack{
                TagView()
                ScrollView(.vertical, showsIndicators: false){
                    EventContentView(events: $recentEvents)
                }
            }
            .navigationTitle("Events")
                
        }
    }
    
    @ViewBuilder
    func TagView() -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text (tag)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background{
                            if activeTag == tag {
                            Capsule ()
                                .fill(Color("tab"))
                               
                            } else {
                            Capsule ()
                             .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor (activeTag == tag ? Color("otab") : Color("tab"))
                }
            } .padding(.horizontal, 8)
        }
    }
    
}
var tags: [String] = [
    "Coding", "Pottery", "Gardening", "Cooking", "Wellness", "Exercise", "Dance & Music"
]

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
