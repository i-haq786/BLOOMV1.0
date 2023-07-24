//
//  PassView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 14/06/23.
//
import SwiftUI
import SDWebImageSwiftUI

struct PassView: View {
    let data: PassData
    @State private var poster: Image = Image("Image 44")
//    @State private var name: String = "Devfest 2022"
//    @State private var organizer: String = "GDG Chennai"
//    @State private var time: String = "1:30 PM"
//    @State private var day: String = "SAT, 11 July"
//    @State private var venue: String = "Infosys, Shollinganallur"
//
//    @State private var bookingId: String = "IXJK000457865CJ83"
//    @State private var topicName: String = "Introduction to Flutter"
//    @State private var stacks: String = "State Management, API Integration"
//    @State private var personsCount: Int = 2
//    @State private var cost : Int = 620
    
    
    var body: some View {
       
        ZStack {
            Image("Image 40")
                .resizable()
                .scaledToFit()
            
            VStack{
                
                HStack {
                    HStack {
                        
                        WebImage(url: data.imgURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                        
                        
                        VStack(alignment: .leading){
                            Text("\(data.name)")
                                .foregroundColor(Color("background"))
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                            
                            //                            Text("\(data.organizer)")
                            //                                .foregroundColor(Color("background"))
                            //                                .font(.system(size: 12))
                            //                                .fontWeight(.medium)
                        }
                        .frame(width: 100, height: 70)
                    }
                    
                    Divider()
                        .frame(height: 60)
                    
                    
                    HStack {
                        
                        VStack(alignment: .center){
                            Text("\(data.date.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute()))")
                                                            .foregroundColor(Color("background"))
                                                            .font(.system(size: 12))
                                                            .fontWeight(.medium)
                            
                            Text("\(data.date.formatted(Date.FormatStyle().day().month().year()))")
                                .foregroundColor(Color("background"))
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            
                            Text("\(data.venue)")
                                .foregroundColor(Color("background"))
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            
                            
                        } .frame(width: 150, height: 70)
                    }
                }
                Spacer()
                HStack{
                    VStack(alignment: .center){
                        Text("Booking ID:")
                            .foregroundColor(Color("background"))
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        Text("\(data.bookingId)")
                            .foregroundColor(Color("background"))
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                        Spacer()
                        
                        //                        Text("\(data.topicName)")
                        //                            .foregroundColor(Color("background"))
                        //                            .font(.system(size: 12))
                        //                            .fontWeight(.bold)
                        //                        Text("(\(data.stacks))")
                        //                            .foregroundColor(Color("background"))
                        //                            .font(.system(size: 12))
                        //                            .fontWeight(.regular)
                        
                        Spacer()
                        
                        Text("Cancellations valid till 12 hrs prior to show timings")
                            .foregroundColor(Color("background"))
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Text("For queries, complaints or any issues please mail  us on support@bloom. com")
                            .foregroundColor(Color("background"))
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                            .padding(.leading, 10)
                        
                    } .frame(width: 220, height: 190)
                    
                    VStack {
                        //                        QRCodeGenerator(eventName: data.name, eventDate: data.date)
                        //
                        //                        Text("\(data.personsCount) Person(s)")
                        //                            .foregroundColor(Color("background"))
                        //                            .font(.system(size: 12))
                        //                            .fontWeight(.bold)
                        Text("Rs. \(data.cost)")
                            .foregroundColor(Color("background"))
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                    }
                }
            }.padding(10)
                .frame(width: 320, height: 290)
    }
    }
}
//
//struct PassView_Previews: PreviewProvider {
//    static var previews: some View {
//        PassView()
//    }
//}
