//
//  ScrollSection.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 15/07/23.
//

import SwiftUI

struct ScrollSection: View {
    
    @State var posters: [Poster]
    @State var selectedView: Binding<Int>
    @State var selectedFilterTagIndex: Binding<Int>
    
    var body: some View {
        VStack {
            Text("")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20.0) {
                   
                    ForEach(posters.indices, id: \.self) { index in
                        Button(action: {
                            selectedView.wrappedValue = 2
                            selectedFilterTagIndex.wrappedValue = posters[index].index
                        }) {
                            Image(posters[index].image)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .cornerRadius (20)
                        }
                    }
                }
                .offset(x: 20)
                .padding(.trailing, 40)
            }
        }
    }
}

//struct ScrollSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollSection().background(.black)
//    }
//}

struct Poster {
    var image: String
    var index: Int
}
