//
//  DetailView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 16/06/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct DetailView: View {
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var event: Event?
    @State private var animateContent: Bool = false
    @State private var offsetAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 15){
            Button{
                withAnimation(.easeInOut (duration: 0.2)) {
                    offsetAnimation = false
                }
                
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)){
                    animateContent = false
                    show = false
                }
            }label: {
                Image (systemName: "chevron.left")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .contentShape(Rectangle())
            }
            .hAlign(.leading)
            .padding([.leading, .vertical], 15)
            .opacity (animateContent ? 1 : 0)
            
            GeometryReader {
            let size = $0.size
                HStack(spacing: 20) {
                    WebImage(url: event?.imgURL)
                        .resizable ()
                        .aspectRatio (contentMode: .fill)
                        .frame (width: size.width/2, height: size.height)
                        .clipShape (CustomCorner (corners: [.topRight, .bottomRight],
                    radius: 20))
                        .matchedGeometryEffect(id: event?.id, in: animation)
                   
                    VStack(alignment: .leading, spacing: 8){
                        Text(event?.name ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .offset(y: offsetAnimation ? 0:100)
                    .opacity (offsetAnimation ? 1 : 0)
                    
                }
            }
            .frame(height: 220)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle ()
                .fill(.white)
                .ignoresSafeArea()
                .opacity (animateContent ? 1 : 0)
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.35)){
                animateContent = true
            }
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)){
                offsetAnimation = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
