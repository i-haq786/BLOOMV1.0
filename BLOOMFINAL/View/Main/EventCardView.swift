//
//  EventCardView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventCardView: View {
    
    var event: Event
    var onUpdate: (Event)->()
    var onDelete: ()->()
    
    var body: some View {
        VStack(alignment: .leading){
            if let eventImage = event.imgURL{
                GeometryReader{
                    let size = $0.size
                    WebImage(url: eventImage)
                        .resizable ()
                        .aspectRatio (contentMode: .fill)
                        .frame (width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .clipped()
                .frame(height: 220)
            }
            
            VStack(alignment: .leading){
                Text(event.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack{
                    Image(systemName: "location")
                        .font(.system(size: 16))
                        .foregroundColor(Color("accent"))
                    Text(event.venue)
                        .font(.callout)
                        .textSelection(.enabled)
                        .padding(.vertical,8)
                }
                HStack{
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(Color("accent"))
                    Text(event.date.formatted(date: .numeric, time: .shortened))
                        .font(.callout)
                        .foregroundColor(Color("primary"))
                }
                
                HStack{
                    Image(systemName: "text.bubble")
                        .font(.system(size: 16))
                        .foregroundColor(Color("accent"))
                    Text(event.description)
                        .textSelection(.enabled)
                        .font(.callout)
                        .padding(.vertical,8)
                   
                }
               
               
            }
        }
        .hAlign(.leading)
    }
}
