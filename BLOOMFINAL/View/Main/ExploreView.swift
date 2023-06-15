//
//  ExploreView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreView: View {
    
    @State private var recentEvents: [Event] = []
    @State private var activeTag: String = "All"
    @Namespace private var animation
    
    var body: some View {
        NavigationStack{
            VStack{
                TagView()
                ScrollView(.vertical, showsIndicators: false){
                    EventContentView(events: $recentEvents)
                }
//                ScrollView(.vertical, showsIndicators: false){
//                    VStack(spacing:15){
//                        ForEach(recentEvents) { event in
//                            CardView(event)
//
//                        }
//                    }
//                }
                .coordinateSpace(name: "SCROLLVIEW")
                .padding(.top, 15)
            }
            .navigationTitle("Events")
            
        }
    }
//
//    @ViewBuilder
//    func CardView(_ event: Event) ->some View{
//        GeometryReader {
//            let size = $0.size
//            let rect = $0.frame(in: .named("SCROLLVIEW"))
//
//            HStack(spacing: 0){
//                VStack(alignment: .leading, spacing: 8){
//
//                }
//                .frame(width: size.width / 2)
//
//                ZStack{
//                    if let eventImage = recentEvents.imgURL{
//                        WebImage(url: eventImage)
//                            .resizable ()
//                    }
//                }
//            }
//
//        }
//        .frame(height: 220)
//    }
//
    
    
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
                                    .matchedGeometryEffect(id: "ACTIVETAB" ,in: animation)
                            } else {
                                Capsule ()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor (activeTag == tag ? Color("otab") : Color("tab"))
                        .onTapGesture {
                            withAnimation(.interactiveSpring (response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
    
}
var tags: [String] = [
    "All", "Coding", "Pottery", "Gardening", "Cooking", "Wellness", "Exercise", "Dance & Music"
]

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
