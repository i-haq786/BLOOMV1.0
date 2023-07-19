//
//  BookingConfirmationPage.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 20/07/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct BookingConfirmationPage: View {
   // var event: Event
    var body: some View {
        VStack(alignment: .center) {
            Text("Congratulations!\n You booked the event successfully.\n Here is your QR")
                .padding()
            
            
//            Button(action: {
//                // Button action handling
//                print("Button Tapped")
//            }) {
//                Text("View Ticket")
//                    .padding()
//                    .background(Color("accent"))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
            
            QRCodeGenerator()
                        
            
        }
//        .onAppear(
//            perform: storeBookingInfo()
//        )

    }
        
}
//
//func storeBookingInfo()-> Void{
//    guard let userUID = Auth.auth().currentUser?.uid else{return}
//
//    let _ = try
//    Firestore.firestore().collection("Users").document(userUID)
//}

struct BookingConfirmationPage_Previews: PreviewProvider {
    static var previews: some View {
        //BookingConfirmationPage()
        ContentView()
    }
}
