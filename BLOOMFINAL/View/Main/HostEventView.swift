//
//  HostEventView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI

struct HostEventView: View {
    @State private var createNewEvent: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .hAlign(.center).vAlign(.center)
            .overlay(alignment: .bottomTrailing){
                Button {
                    createNewEvent.toggle()
                } label:{
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(.black, in:Circle())
                }
                .padding (15)
            }
            .fullScreenCover(isPresented: $createNewEvent){
                CreateNewEvent{event in}
            }
    }
}

struct HostEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostEventView()
    }
}
