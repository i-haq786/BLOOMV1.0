//
//  SummaryView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 15/07/23.
//
import SwiftUI
import SDWebImageSwiftUI

struct SummaryView: View {
    var event: Event
    @State private var numberOfPersons = 1
    private var totalCost : Double {
        return Double(numberOfPersons) * event.cost
        
    }
    //@State private var formattedTotalCost : String = "0"
    @State private var eventName: String = "Dev-Fest"
    //@State private var eventDate: Date = Date()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("Event Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    WebImage(url: event.imgURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 300)
                    Text(event.name)
                        .font(.headline)
                    Text(event.date.formatted())
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Text(event.venue)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Text(event.userName)
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
                                //calculateTotalCost()
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
                            //calculateTotalCost()
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
                
                Text(String(format: "Total Cost: %.2f Rs.", totalCost))
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                
                
                NavigationLink{
                    BookingConfirmationPage()
                }label: {
                    Text("Make Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("accent"))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
//    private func calculateTotalCost() {
////        totalCost = Double(numberOfPersons) * 100.0
//        totalCost = Double(numberOfPersons) * event.cost
////formattedTotalCost = String(format: "%.2f", totalCost)
//    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
