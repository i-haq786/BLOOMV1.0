//
//  EventContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase

struct EventContentView: View {
    
    @Binding var events: [Event]
    @State var isFetching: Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
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
            
        } .refreshable {
            isFetching = true
            events = []
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
            EventCardView()
        }
    }
    
    //fetching events
    func fetchEvents()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("Events")
                .order(by: "date", descending: true)
                .limit(to: 20)
            let docs = try await query.getDocuments()
            
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            await MainActor.run(body:{
                events = fetchedEvents
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
