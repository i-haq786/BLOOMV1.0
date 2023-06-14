//
//  EventContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase

struct EventContentView: View {
    
//    var basedOnUID: Bool = false
//    var uid: String = ""
    @Binding var events: [Event]
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    
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
        }
        .refreshable{
           // guard !basedOnUID else{return}
            
            isFetching = true
            events = []
         //   paginationDoc = nil
            await fetchEvents()
        }
        .task{
            guard events.isEmpty else{return}
            await fetchEvents()
        }
    }
    //displaying fetched events
    @ViewBuilder
    func Events()->some View{
        ForEach(events){event in
            EventCardView(event: event){updatedEvent in
                
            }onDelete: {
                
            }.onAppear{
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
            if let paginationDoc{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .limit(to: 20)
            }
            //query for UID
//            if basedOnUID{
//                query = query.whereField("userUID", in: uid)
//            }
            
            let docs = try await query.getDocuments()
            
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            await MainActor.run(body:{
                events.append(contentsOf: fetchedEvents)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
}


struct EventContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
