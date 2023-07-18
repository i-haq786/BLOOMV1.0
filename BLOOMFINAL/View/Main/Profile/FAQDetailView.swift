//
//  FAQDetailView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 16/06/23.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        NavigationView {
            List(faqData) { faqItem in
                NavigationLink(destination: FAQDetail(faqItem: faqItem)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(faqItem.question)
                            .font(.headline)
                        
                        Text(faqItem.answer)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("FAQ's")
        }
    }
}

struct FAQDetail: View {
    var faqItem: FAQItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(faqItem.question)
                .font(.headline)
            
            Text(faqItem.answer)
                .font(.body)
            
           // Spacer()
        }
        
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

let faqData: [FAQItem] = [
    FAQItem(question: "How do I book an event?", answer: "You can book an event by visiting our app's homepage and following the simple booking process. You can even host your own small events"),
    FAQItem(question: "What payment methods do you accept?", answer: "We accept all major credit cards and online payment platforms such as Gpay, Paytm etc."),
    FAQItem(question: "Can I cancel my booking?", answer: "Yes, you can cancel your booking, but please refer to our cancellation policy for any applicable fees."),
    FAQItem(question: "Do you offer refunds?", answer: "Refunds are subject to our refund policy. Please check our terms and conditions for more information."),
    FAQItem(question: "Can I modify my booking details?", answer: "In most cases, you can modify your booking details. However to do so you will have to reach out to us on custom.support@bloom.com."),
    FAQItem(question: "How far in advance should I host an event?", answer: "We recommend hosting your event at least a month in advance to ensure availability."),
    FAQItem(question: "Is there a minimum or maximum number of attendees for an event?", answer: "The minimum and maximum number of attendees vary depending on the event. Please check the event details for more information."),
    FAQItem(question: "Are there any age restrictions for events?", answer: "Age restrictions may apply to certain events. Please check the event details for any age requirements."),
    FAQItem(question: "Can I request a specific event date?", answer: "You can indicate your preferred event date during the booking process, and we will do our best to accommodate your request."),
    FAQItem(question: "What happens if the event gets canceled?", answer: "In the event of a cancellation, we will notify you and provide alternative options or a refund as per our cancellation policy."),
    FAQItem(question: "Are food and beverages included in the event?", answer: "Food and beverage arrangements vary for each event. Please check the event details for information on catering services."),
    FAQItem(question: "Is parking available at the event venue?", answer: "Parking facilities may be available at some event venues. Please check the event details for parking information."),
    FAQItem(question: "Can I bring my own camera or recording equipment to the event?", answer: "Camera and recording policies differ for each event. Please check the event details for any restrictions or guidelines."),
    FAQItem(question: "Is there a dress code for events?", answer: "Dress codes may apply to certain events. Please check the event details for any specific dress code requirements."),
    FAQItem(question: "Can I transfer my event booking to someone else?", answer: "In some cases, event bookings can be transferred to another person. Please contact our customer support for assistance."),
    FAQItem(question: "Do you offer group discounts for events?", answer: "Group discounts may be available for certain events. Please check the event details or contact our customer support for more information."),
    FAQItem(question: "Are there any hidden fees in the event booking?", answer: "We strive for transparency, and there are no hidden fees in our event bookings. The total cost will be clearly displayed during the booking process."),
    FAQItem(question: "Can I get a refund if I miss the event?", answer: "Unfortunately, we cannot provide refunds for missed events. Please ensure you check the event date and plan accordingly."),
    FAQItem(question: "Do you offer event planning services?", answer: "We specialize in event bookings and event planning."),
    FAQItem(question: "Are events wheelchair accessible?", answer: "Accessibility options vary for each event")
]

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
