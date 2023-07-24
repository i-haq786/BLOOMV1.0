//
//  HostEventView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI


struct HostEventView: View {
    @State private var createNewEvent: Bool = false
    @State private var recentEvents: [Event] = []
    @State private var filteredRecentEvents: [Event] = []
    @State private var selectedEvent: Event?
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State private var listenerRegistration: ListenerRegistration?
    @Namespace private var animation
    @State var showDetailsView: Bool = false
    @State private var animateCurrentEvent: Bool = false
    var users: Int = 122

    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                ReusableContent()
            }.navigationTitle("Hosted Events")
               // .padding()
                .overlay(alignment: .bottomTrailing){
                    Button {
                        createNewEvent.toggle()
                    } label:{
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("background"))
                            .padding(13)
                            .background(Color("accent"), in:Circle())
                    }
                    .padding (15)
                    
                }
                .fullScreenCover(isPresented: $createNewEvent){
                    CreateNewEvent{event in
                        
                    }
                }
        }.overlay {
            if let selectedEvent = selectedEvent, showDetailsView {
                DetailView(show: $showDetailsView, animation: animation, event: selectedEvent)
                    .transition(.asymmetric(insertion: .identity, removal: AnyTransition.offset(CGSize(width: 0, height: 5))))
                
            }
        }
        
    }
    
    @ViewBuilder
    func ReusableContent()->some View{
        var filteredEvents = recentEvents.filter({ eve in
            eve.userUID == Auth.auth().currentUser?.uid
        })
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                }
                else{
                    if filteredEvents.isEmpty{
                        NoEventsDefaultView()
//                        Text("No events found")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .padding()
                    }else{
                        Events(filteredEvents: filteredEvents)
                    }
                }
            }
            .padding(15)
            .onAppear {
                // Fetch events only when the view appears
                if recentEvents.isEmpty {
                    Task {
                        await fetchEvents()
                    }
                }
                startEventListeners() // Start Firestore listeners
                
            }
            .onDisappear {
                stopEventListeners() // Stop Firestore listeners
            }
        }
        .refreshable {
            isFetching = true
            recentEvents = []
            paginationDoc = nil // Reset pagination document
            
            await fetchEvents()
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
                                
                                Text("\(users)")
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
    
    //displaying fetched events
    @ViewBuilder
    func Events( filteredEvents: [Event] )->some View{
        
       ForEach(filteredEvents) { event in
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
    //fetching events
    func fetchEvents()async{
        do{
//            print("Start")
            var query: Query!
            //pagination
            if let lastDocument = paginationDoc {
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .start(afterDocument: lastDocument)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .limit(to: 20)
            }
            

            
            let docs = try await query.getDocuments()
            
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            if fetchedEvents.isEmpty {
                print("No events found")
            } else {
                await MainActor.run {
                    if recentEvents.isEmpty {
                        recentEvents.append(contentsOf: fetchedEvents)
                    } else {
                        recentEvents = fetchedEvents
                    }
                    paginationDoc = docs.documents.last
                    isFetching = false
                }
            }
//           print("DONEEEEEE")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func startEventListeners() {
        Firestore.firestore().collection("Events")
            .addSnapshotListener { [self] snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error listening for events: \(error?.localizedDescription ?? "")")
                    return
                }
                
                for change in snapshot.documentChanges {
                    if change.type == .added {
                        if let event = try? change.document.data(as: Event.self) {
                            if !recentEvents.contains(where: { $0.id == event.id }) {
                                recentEvents.insert(event, at: 0)
                            }
                        }
                    }
                    // Handle other change types (modified, removed)
                }
            }
    }
    
    
    // Stop Firestore listeners
    func stopEventListeners() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
}

struct HostEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostEventView()
    }
}
