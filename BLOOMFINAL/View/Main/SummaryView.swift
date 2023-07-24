//
//  SummaryView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 15/07/23.
//
import SwiftUI
import SDWebImageSwiftUI
import Razorpay
import FirebaseAuth
import FirebaseFirestore

class RazorpayViewModel: ObservableObject, RazorpayPaymentCompletionProtocol {
    @Published var paymentStatus: String = ""
    
    private var razorpay: RazorpayCheckout!
    
    init() {
        // Initialize razorpay here with your key and delegate
        razorpay = RazorpayCheckout.initWithKey("rzp_test_z5AbGgaNo0s89r", andDelegate: self)
    }
    
    func startPayment(amount: Double, description: String) {
        let amountInPaise = amount * 100 // Razorpay accepts the amount in paise
        let params: [String: Any] = [
            "amount": amountInPaise,
            "currency": "INR", // Replace with your desired currency code
            "description": description
        ]
        razorpay.open(params)
    }
    
    // MARK: - RazorpayPaymentCompletionProtocol
    
    func onPaymentSuccess(_ paymentId: String) {
        paymentStatus = "Payment Successful! Payment ID: \(paymentId)"
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        paymentStatus = "Payment Error: \(str)"
    }
}

struct SummaryView: View {
    @StateObject private var razorpayViewModel = RazorpayViewModel()
    
    var event: Event
    var isPresented: Binding <Bool>
    @State private var numberOfPersons = 1
    private var totalCost : Double {
        return Double(numberOfPersons) * event.cost
        
    }
    //@State private var formattedTotalCost : String = "0"
    @State private var eventName: String = "Dev-Fest"
    //@State private var eventDate: Date = Date()
    @State private var showSecondView = false
    var isPaymentSuccessful : Binding <Bool> 
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("Event Summary")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                VStack(alignment: .center, spacing: 10) {
                    WebImage(url: event.imgURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 300)
                        .cornerRadius(15)
                    
                    VStack(alignment: .leading) {
                        
                        Text(event.name)
                            .font(.title3.bold())
                        HStack{
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 35)
                                .foregroundColor(Color("accent")) // Color of the SF Symbol
                                
                            Text(event.date.formatted())
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        HStack{
                            Image(systemName: "location.viewfinder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 35)
                                .foregroundColor(Color("accent")) // Color of the SF Symbol
                                
                            Text(event.venue)
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        Text("Hosted by: \(event.userName)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                
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
               
                
                Button(action: {
                    isPresented.wrappedValue = false
                    initiatePayment()
                    
                }) {
                    Text("Make Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("accent"))
                        .cornerRadius(10)
                }
                
                Text(razorpayViewModel.paymentStatus)
                    .padding()
                    .foregroundColor(.red)
                    .font(.caption.bold())
  
            }
            .padding()
            .background(Color("background"))
        }
    }
    
    private func initiatePayment() {
        do {
            razorpayViewModel.startPayment(amount: 100.0, description: "Test Payment")
            
            guard let userUID = Auth.auth().currentUser?.uid else{return}
            let uid = UUID().uuidString
            try Firestore.firestore().collection("Users").document(userUID).collection("Passes").document(uid).setData(from: PassData(id: event.id, name: event.name, imgURL: event.imgURL, venue: event.venue, date: event.date, cost: event.cost, bookingId: UUID().uuidString))
            
            DispatchQueue.main.async {
                // Perform the navigation on the main thread
                self.isPaymentSuccessful.wrappedValue = true
            }
        }
        catch{
           print(error)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
