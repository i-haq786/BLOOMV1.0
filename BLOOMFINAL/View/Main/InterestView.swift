//
//  InterestView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 20/07/23.
//

import SwiftUI

struct InterestView: View {
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
                        
                        InterestUI()
                            .frame(width: 330)
                    }.offset(x: 20, y: 40)
                
                HStack {
                    
                    Button(action: {
                               // Button action handling
                               print("Image button tapped")
                           }) {
                               Image("Image 9") // Replace "imageName" with the actual name of your image asset
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

