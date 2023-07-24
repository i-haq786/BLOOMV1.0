//
//  PassesView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 14/06/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct PassesView: View {
    
    @State private var passData : [PassData] = []
//        PassData(poster: Image("Image 10"), name: "Devfest 2022", organizer: "GDG Chennai", time: "1:30 PM", day: "SAT, 11 July", venue: "Infosys, Shollinganallur", bookingId: "IXJK000457865CJ83", topicName: "Introduction to Flutter", stacks: "State Management, API Integration", personsCount: 2, cost: 620),
//
//        PassData(poster: Image("Image 44"), name: "Pottery Making", organizer: "YMX Corp.", time: "5:30 PM", day: "MON, 31 July", venue: "Phoenix Mall, Guindy", bookingId: "DKLK02047715BK90", topicName: "Learn Pottery with me", stacks: "Materials provided", personsCount: 1, cost: 120)
       
   // ]
    
    var body: some View {
        NavigationStack{
           ScrollView {
                       ForEach(passData, id: \.bookingId) { data in
                           PassView(data: data).padding(10)
                       }
                       Spacer()
                   }.navigationTitle("Passes")
                //.padding(10)
        }.onAppear{
            Task{
                do{
                    guard let userUID = Auth.auth().currentUser?.uid else{return}
                    let docs = try await Firestore.firestore().collection("Users").document(userUID).collection("Passes").getDocuments()
                    
                    let fetchedPasses = docs.documents.compactMap{ doc -> PassData? in
                        try? doc.data(as: PassData.self)
                    }
                    passData = fetchedPasses
                }
                catch{
                    print("Fetch pass failed")
                }
            }
        }
       
    }
}

struct PassesView_Previews: PreviewProvider {
    static var previews: some View {
        PassesView()
    }
}
