//
//  SummaryView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 15/07/23.
//
import SwiftUI

struct SummaryView: View {
    @State private var numberOfPersons = 1
    @State private var totalCost = 0
    @State private var eventName: String = "Dev-Fest"
    //@State private var eventDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Event Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Image("Image 10")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity, height: 300)
                Text("\(eventName)")
                    .font(.headline)
                Text("15 July 2023. 8:40 pm")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            
            HStack {
                Text("Number of Persons")
                    .font(.headline)
                Spacer()
                
                HStack(alignment: .center, spacing: 10) {
                    
                    
                    Button(action: {
                        if numberOfPersons > 1 {
                            numberOfPersons -= 1
                            calculateTotalCost()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(numberOfPersons)")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        numberOfPersons += 1
                        calculateTotalCost()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                }
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
               
            }
            Spacer()
            
            Text("Total Cost: \(totalCost) Rs.")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                
            
           
            
            Button(action: {
                // Perform payment action or connect to Firebase here
            }) {
                Text("Make Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private func calculateTotalCost() {
        totalCost = numberOfPersons * 100
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
