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
        
            if let eventImage = event.imgURL{
                GeometryReader{
                    let size = $0.size
                    let rect = $0.frame(in: .named("SCROLLVIEW") )
                
                    //New design
                    HStack(spacing: -25){
                        // detail card
                        VStack(alignment: .leading, spacing: 6){
                          
                        }
                        .padding()
                        .frame(width: size.width / 2, height: size.height * 0.8)
                        .background {
                            RoundedRectangle (cornerRadius: 10, style: .continuous)
                                .fill(.white)
                            // Applying Shadow
                                .shadow (color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                        }
                        .zIndex(1)
                        
                        ZStack(){
                            WebImage(url: eventImage)
                                .resizable ()
                                .aspectRatio (contentMode: .fill)
                                .frame (width: size.width/2, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow (color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: size.width)
//                    .rotation3DEffect(.init(degrees: convertoffsetToRotation(rect)), axis: (x:1, y:0, z:0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
                }
                .frame(height: 220)
               
            }
        
    }
    
//    func convertoffsetToRotation(_ rect: CGRect) -> CGFloat {
//        let cardHeight = rect.height
//        let minY = rect.minY - 20
//        let progress = minY < 0 ? (minY / cardHeight) : 0
//        let constrainedProgress = min( -progress, 1.0)
//        return constrainedProgress * 90
//    }
}
                    //old design
                    //                    WebImage(url: eventImage)
                    //                        .resizable ()
                    //                        .aspectRatio (contentMode: .fill)
                    //                        .frame (width: size.width, height: size.height)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    //                }
                    //                .clipped()
                    //                .frame(height: 220)
                    //            }
                    //
                    //            VStack(alignment: .leading){
                    //                Text(event.name)
                    //                    .font(.title2)
                    //                    .fontWeight(.semibold)
                    //                HStack{
                    //                    Image(systemName: "location")
                    //                        .font(.system(size: 16))
                    //                        .foregroundColor(Color("accent"))
                    //                    Text(event.venue)
                    //                        .font(.callout)
                    //                        .textSelection(.enabled)
                    //                        .padding(.vertical,8)
                    //                }
                    //                HStack{
                    //                    Image(systemName: "calendar")
                    //                        .font(.system(size: 16))
                    //                        .foregroundColor(Color("accent"))
                    //                    Text(event.date.formatted(date: .numeric, time: .shortened))
                    //                        .font(.callout)
                    //
                    //                }
                    //
                    //                HStack{
                    //                    Image(systemName: "text.bubble")
                    //                        .font(.system(size: 16))
                    //                        .foregroundColor(Color("accent"))
                    //                    Text(event.description)
                    //                        .textSelection(.enabled)
                    //                        .font(.callout)
                    //                        .padding(.vertical,8)
                    //
                    //                }
                    //
                    //
                    //            }
//                }
//                .hAlign(.leading)
//            }
//        }
