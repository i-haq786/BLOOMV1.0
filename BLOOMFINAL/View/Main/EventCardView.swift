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
        VStack{
            Text(event.name)
                .font(.body)
                .fontWeight(.semibold)
            Text(event.date.formatted(date: .numeric, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)
            Text(event.description)
                .textSelection(.enabled)
                .padding(.vertical,8)
            
            if let eventImgURL = event.imgURL{
                GeometryReader{
                    let size = $0.size
                    WebImage(url: eventImgURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .frame(height: 200)
            }
        }
        .hAlign(.leading)
    }
}
