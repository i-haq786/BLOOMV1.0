//
//  InterestView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 20/07/23.
//

import SwiftUI

import FirebaseAuth
import FirebaseFirestore

struct InterestView: View {
    @State private var selectedInterests: [String] = []
    @AppStorage("interest_set") var interestSet: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color("highlight")
                .edgesIgnoringSafeArea(.all)
            
        
                Rectangle()
                    .fill(Color("primary"))
                    .frame(width: 400, height: 800)
                    .cornerRadius(50)
                    .offset(x: 50, y: 100)
                
            
            VStack{
                HStack {
                    
                    
                    Text("Getting Started")
                        .font(.title.bold())
                        .foregroundColor(Color("background"))
                        .padding(.top, 10)
                    
                    
                    Spacer(minLength: 10)
                    
//                    Image("Image 35")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 55, height: 40)
                    
                    
                     }
                    
                
                    VStack {
                        Image("Image 8")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 30)
//                                    .stroke(Color("background"), lineWidth: 0.5)
//                            )
                            .padding()
                        
                        Text("What interests you?")
                            .font(.title3.bold())
                            .foregroundColor(Color("background"))
                        Text("Choose at least 2")
                            .font(.callout)
                            .foregroundColor(Color("background"))
                        
                        InterestUI(selectedInterests: selectedInterests)
                            .frame(width: 330)
                    }.offset(x: 20, y: 40)
                
                HStack {
                    Button(action: {
                        do {
                            
                            Task {
                                guard let userUID = Auth.auth().currentUser?.uid else{return}
                                try await Firestore.firestore().collection("Users").document(userUID).setData(["interests": selectedInterests])
                            }
                            interestSet = true
                        } catch {
                            print(error)
                        }
                           }) {
                               Image("Image 9")
                                   .resizable()
                                   .frame(width: 55, height: 50)
                                   .cornerRadius(10)
                                   
                           }
                    
                    }.offset(x: 140)
                
                }.padding(20)
          //
        }
    }
}

struct InterestView_Previews: PreviewProvider {
    static var previews: some View {
        InterestView()
    }
}

