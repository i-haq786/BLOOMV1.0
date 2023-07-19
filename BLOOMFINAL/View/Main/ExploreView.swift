//
//  ExploreView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ExploreView: View {
    
    @State private var recentEvents: [Event] = []
    @State private var activeTag: String = "All"
    @Namespace private var animation
    @State private var selectedEvent: Event?
    @State private var events: Event?
    @State var showDetailsView: Bool = false
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State private var animateCurrentEvent: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                TagView()
                ScrollView(.vertical, showsIndicators: false){
                    EventContent()
                }
                .coordinateSpace(name: "SCROLLVIEW")
                .padding(.top, 15)
            }
            .navigationTitle("Events")
        }
        .overlay {
            if let selectedEvent = selectedEvent, showDetailsView {
                DetailView(show: $showDetailsView, animation: animation, event: selectedEvent)
                    .transition(.asymmetric(insertion: .identity, removal: AnyTransition.offset(CGSize(width: 0, height: 5))))
                
            }
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
                                    .matchedGeometryEffect(id: "ACTIVETAB" ,in: animation)
                            } else {
                                Capsule ()
                                    .fill(.ultraThinMaterial)
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
    
    @ViewBuilder
    func EventContent() -> some View{
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                }
                else{
                    if recentEvents.isEmpty{
                        Text("No events found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    }else{
                        Events()
                    }
                }
            }
            .padding(15)
        }
        .refreshable{
            // guard !basedOnUID else{return}
            isFetching = true
            recentEvents = []
            //   paginationDoc = nil
            await fetchEvents()
        }
        .task{
            guard recentEvents.isEmpty else{return}
            await fetchEvents()
        }
        
    }
    
    //displaying fetched events
    @ViewBuilder
    func Events() -> some View {
        ForEach(recentEvents.filter({ eve in
            if activeTag == "All" {
                return true
            }
                else
            {
                return eve.category == activeTag
            }
        })) { event in
            EventCard(event)
                .onAppear {
                    if event.id == recentEvents.last?.id && paginationDoc != nil {
                        Task { await fetchEvents() }
                    }
                }
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        selectedEvent = event
                        showDetailsView = true
                    }
                }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    func EventCard(_ event: Event)-> some View{
        if let eventImage = event.imgURL{
            GeometryReader{
                let size = $0.size
                //                    let rect = $0.frame(in: .named("SCROLLVIEW") )
                //New design
                HStack(spacing: -25){
                    // detail card
                    VStack(alignment: .leading, spacing: 6){
                        VStack(alignment: .leading, spacing: 8){
                            Text(event.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(event.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                               
                            Text(event.category)
                                .padding(3)
                                .foregroundColor(Color("background"))
                                .font(.system(size: 8, weight: .regular))
                                .background(Color("primary"))
                                .cornerRadius(45)
                               
                            Spacer()
                            
                            HStack(spacing: 4){
                                
                                Text("110")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("accent"))
                                
                                Text("Registrations")
                                    .font(.caption)
                                  
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                   
                            }
                        }
                    }
                    .padding()
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle (cornerRadius: 10, style: .continuous)
                            .fill(Color("otab"))
                        // Applying Shadow
                            .shadow (color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                    ZStack(){
                        if !(showDetailsView && selectedEvent?.id == event.id ){
                            WebImage(url: eventImage)
                                .resizable ()
                                .aspectRatio (contentMode: .fill)
                                .frame (width: (size.width/2 + 20), height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .matchedGeometryEffect(id: event.id, in: animation)
                                .shadow (color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: size.width)
                //                    .rotation3DEffect(.init(degrees: convertoffsetToRotation(rect)), axis: (x:1, y:0, z:0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
            }
            .frame(height: 220)
        }
    }
    
    //fetching events
    func fetchEvents()async{
        do{
            var query: Query!
            //pagination
            if let paginationDoc{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: false)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: false)
                    .limit(to: 20)
            }
            //query for UID
            //            if basedOnUID{
            //                query = query.whereField("userUID", in: uid)
            //            }
            
            let docs = try await query.getDocuments()
            print(docs.documents)
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            print(fetchedEvents)
            await MainActor.run(body:{
                recentEvents.append(contentsOf: fetchedEvents)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
var tags: [String] = [
    "All", "Art", "Pottery", "Gardening", "Cooking", "Wellness", "Techshop", "Other"
]
//var tags: [String] = [
//    "All", "Coding", "Pottery", "Gardening", "Cooking", "Wellness", "Exercise", "Dance & Music"
//]

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
