////
////  EventContentView.swift
////  BLOOMFINAL
////
////  Created by Sitanshu Pokalwar on 13/06/23.
////
//
//import SwiftUI
//import Firebase
//import SDWebImageSwiftUI
//
//struct EventContentView: View {
//
////    var basedOnUID: Bool = false
////    var uid: String = ""
//
//
//    @Binding var events: [Event]
//    @State var showDetailsView: Bool = false
//    @State private var isFetching: Bool = true
//    @State private var paginationDoc: QueryDocumentSnapshot?
//    @State private var selectedEvent: Event?
//    @Namespace private var animation
//
//
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false){
//            LazyVStack{
//                if isFetching{
//                    ProgressView()
//                        .padding(.top, 30)
//                }
//                else{
//                    if events.isEmpty{
//                        Text("No events found")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .padding()
//                    }else{
//                        Events()
//                    }
//                }
//            }
//            .padding(15)
//        }
//        .refreshable{
//           // guard !basedOnUID else{return}
//            isFetching = true
//            events = []
//         //   paginationDoc = nil
//            await fetchEvents()
//        }
//        .task{
//            guard events.isEmpty else{return}
//            await fetchEvents()
//        }
//        .overlay {
//            if let selectedEvent = selectedEvent, showDetailsView {
//                DetailView(show: $showDetailsView, animation: animation, event: selectedEvent)
//            }
//        }
//    }
//    //displaying fetched events
//    @ViewBuilder
//    func Events() -> some View {
//        ForEach(events) { event in
//            EventCard(event)
//            .onAppear {
//                if event.id == events.last?.id && paginationDoc != nil {
//                    Task { await fetchEvents() }
//                }
//            }
//            .onTapGesture {
//                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                    selectedEvent = event
//                    showDetailsView = true
//                }
//            }
//            Divider()
//                .padding(.top, 10)
//                .padding(.bottom, 10)
//        }
//    }
//
//    @ViewBuilder
//    func EventCard(_ event: Event)-> some View{
//        if let eventImage = event.imgURL{
//            GeometryReader{
//                let size = $0.size
////                    let rect = $0.frame(in: .named("SCROLLVIEW") )
//                //New design
//                HStack(spacing: -25){
//                    // detail card
//                    VStack(alignment: .leading, spacing: 6){
//
//                    }
//                    .padding()
//                    .frame(width: size.width / 2, height: size.height * 0.8)
//                    .background {
//                        RoundedRectangle (cornerRadius: 10, style: .continuous)
//                            .fill(.white)
//                        // Applying Shadow
//                            .shadow (color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
//                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
//                    }
//                    .zIndex(1)
//                    ZStack(){
//                        WebImage(url: eventImage)
//                            .resizable ()
//                            .aspectRatio (contentMode: .fill)
//                            .frame (width: size.width/2, height: size.height)
//                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                            .shadow (color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
//                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//                .frame(width: size.width)
////                    .rotation3DEffect(.init(degrees: convertoffsetToRotation(rect)), axis: (x:1, y:0, z:0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
//            }
//            .frame(height: 220)
//        }
//    }
//
//    //fetching events
//    func fetchEvents()async{
//        do{
//            var query: Query!
//            //pagination
//            if let paginationDoc{
//                query = Firestore.firestore().collection("Events")
//                    .order(by: "date", descending: true)
//                    .start(afterDocument: paginationDoc)
//                    .limit(to: 20)
//            }else{
//                query = Firestore.firestore().collection("Events")
//                    .order(by: "date", descending: true)
//                    .limit(to: 20)
//            }
//            //query for UID
////            if basedOnUID{
////                query = query.whereField("userUID", in: uid)
////            }
//
//            let docs = try await query.getDocuments()
//
//            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
//                try? doc.data(as: Event.self)
//            }
//            await MainActor.run(body:{
//                events.append(contentsOf: fetchedEvents)
//                paginationDoc = docs.documents.last
//                isFetching = false
//            })
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
//
//}
//
//
//struct EventContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
