//
//  Feedback.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 19/07/23.
//



import SwiftUI

struct Review: Identifiable {
    let id = UUID()
    var rating: Int
    var rating2: Int
    var comment: String
}

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
        
        
    }
}

struct FeedbackView: View {
    @State private var reviews: [Review] = []
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var rating2: Int = 0
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your booking experience:")
                StarRatingView(rating: $rating, maxRating: 5)
                
                
                Spacer()
            }
            .padding()
            
            HStack {
                Text("Your event experience:")
                StarRatingView(rating: $rating2, maxRating: 5)
                
                
                Spacer()
            }
            .padding()
            
            VStack {
                Text("Write a comment:")
                    .font(.headline)
                    .padding(.bottom, 8)
                TextEditor(text: $comment)
                    .frame(height: 100)
                    .border(Color.gray, width: 1)
                   
            }
            .padding()
            
            Button(action: addReview) {
                Text("Submit")
                    .padding()
                    .background(Color("accent"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.leading, 150)
            
            List(reviews) { review in
                VStack(alignment: .leading) {
                    HStack {
                        StarRatingView(rating: .constant(review.rating), maxRating: 5)
                        Spacer()
                    }
                    Text(review.comment)
                        .padding(.vertical, 4)
                }
                .padding()
            }
        }
    }
    
    private func addReview() {
        let newReview = Review(rating: (rating+rating2)/2, rating2: rating2, comment: comment)
        
        reviews.append(newReview)
        
        rating = 0
        rating2 = 0
        comment = ""
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
