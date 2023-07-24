//
//  InterestUI.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 20/07/23.
//
import SwiftUI

struct InterestUI: View {
    let interests: [String] = ["Gardening", "Pottery", "Techshop", "Art", "Cooking", "Wellness", "Other"]
    
    @State var selectedInterests: [String]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(interests, id: \.self) { interest in
                    Button(action: {
                        // Toggle selection
                        if selectedInterests.contains(interest) {
                            selectedInterests.removeAll { $0 == interest }
                        } else {
                            selectedInterests.append(interest)
                        }
                    }) {
                        Text(interest)
                            .font(.system(size: 12))
                            .frame(width: 70, height: 25)
                            .padding(5)
                            .background(selectedInterests.contains(interest) ? Color("accent") : Color("highlight"))
                            .foregroundColor(Color("background"))
                            .cornerRadius(35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(Color("accent"), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                //                Button(action: {
                //                    // Submit action
                //                    print("Selected interests: \(selectedInterests)")
                //                }) {
                //                    Text("Submit")
                //                        .padding()
                //                        .background(Color.blue)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(10)
                //                }
                //                .buttonStyle(PlainButtonStyle())
                
            }
            .padding()
        }
    }
}

//struct InterestUI_Previews: PreviewProvider {
//    static var previews: some View {
//        InterestUI()
//    }
//}
