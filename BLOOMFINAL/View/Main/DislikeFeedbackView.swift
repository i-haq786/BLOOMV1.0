//
//  DislikeFeedbackView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 16/06/23.
//

import SwiftUI

struct DislikeFeedbackView: View {
    @Binding var isShowing: Bool
    @State private var feedbackText = ""
    
    var body: some View {
        VStack {
            Text("Provide Feedback")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            Text("We absolutely value your feedback and are indebted to continuous improvement, as customer insights fuel progress and together, we strive to build a better future.")
                .font(.callout)
                .fontWeight(.regular)
                .padding()
            TextField("Enter your suggestions.", text: $feedbackText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                submitFeedback()
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("accent"))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func submitFeedback() {
        // Perform the logic to handle the submitted feedback here
        
        // Close the popover
        isShowing = false
    }
}
