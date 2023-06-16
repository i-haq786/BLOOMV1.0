//
//  EventContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct ReusableContentView: View {
    
    //    var basedOnUID: Bool = false
    //    var uid: String?
    @Binding var events: [Event]
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State private var listenerRegistration: ListenerRegistration?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                }
                else{
                    if events.isEmpty{
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
            .onAppear {
                // Fetch events only when the view appears
                if events.isEmpty {
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
            events = []
            paginationDoc = nil // Reset pagination document
            
            await fetchEvents()
        }
    }
    //displaying fetched events
    @ViewBuilder
    func Events()->some View{
        ForEach(events){event in
            EventCardView(event: event)
//            {updatedEvent in
//                
//            }onDelete: {
//                
//            }
            .onAppear{
                if event.id == events.last?.id && paginationDoc != nil{
                    Task{await fetchEvents()}                }
            }
            Divider()
        }
    }
    //fetching events
    func fetchEvents()async{
        do{
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
            
            //uid based filter
            //            if basedOnUID{
            //                query = query.whereField("userUID", isEqualTo: uid)
            //            }
            
            let docs = try await query.getDocuments()
            
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            if fetchedEvents.isEmpty {
                print("No events found")
            } else {
                await MainActor.run {
                    if events.isEmpty {
                        events.append(contentsOf: fetchedEvents)
                    } else {
                        events = fetchedEvents
                    }
                    paginationDoc = docs.documents.last
                    isFetching = false
                }
            }
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
                            if !events.contains(where: { $0.id == event.id }) {
                                events.insert(event, at: 0)
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


struct ReusableContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
