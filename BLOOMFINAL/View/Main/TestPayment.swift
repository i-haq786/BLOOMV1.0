////
////  TestPayment.swift
////  BLOOMFINAL
////
////  Created by Inzamam on 21/07/23.
////
//
//import SwiftUI
//import Razorpay
//
//class RazorpayViewModel: ObservableObject, RazorpayPaymentCompletionProtocol {
//    @Published var paymentStatus: String = ""
//
//    private var razorpay: RazorpayCheckout!
//
//    init() {
//        // Initialize razorpay here with your key and delegate
//        razorpay = RazorpayCheckout.initWithKey("rzp_test_z5AbGgaNo0s89r", andDelegate: self)
//    }
//
//    func startPayment(amount: Double, description: String) {
//        let amountInPaise = amount * 100 // Razorpay accepts the amount in paise
//        let params: [String: Any] = [
//            "amount": amountInPaise,
//            "currency": "INR", // Replace with your desired currency code
//            "description": description
//        ]
//        razorpay.open(params)
//    }
//
//    // MARK: - RazorpayPaymentCompletionProtocol
//
//    func onPaymentSuccess(_ paymentId: String) {
//        paymentStatus = "Payment Successful! Payment ID: \(paymentId)"
//    }
//
//    func onPaymentError(_ code: Int32, description str: String) {
//        paymentStatus = "Payment Error: \(str)"
//    }
//}
//
//struct TestPayment: View {
//    @StateObject private var razorpayViewModel = RazorpayViewModel()
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                initiatePayment()
//                        
//            }) {
//                Text("Pay Now")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            Text(razorpayViewModel.paymentStatus)
//                .padding()
//        }
//    }
//
//    private func initiatePayment() {
//        razorpayViewModel.startPayment(amount: 100.0, description: "Test Payment")
//    }
//}
//
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        ContentView()
////    }
////}
