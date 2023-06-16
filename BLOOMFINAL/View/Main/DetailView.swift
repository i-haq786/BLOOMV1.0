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
                .foregroundColor(Color("otab"))
                                    
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
                            .foregroundColor(Color("otab"))
                        Text(event?.date.formatted(date: .numeric, time: .shortened) ?? "")
                            .font(.caption)
                            .foregroundColor(Color("otab"))
                        
                        Text(event?.venue ?? "")
                            .font(.caption)
                            .foregroundColor(Color("otab"))
                    }
                    .padding(.trailing, 10)
                    .offset(y: offsetAnimation ? 0:100)
                    .opacity (offsetAnimation ? 1 : 0)
                    
                }
            }
            .frame(height: 220)
            .zIndex(1)
            Rectangle()
                .ignoresSafeArea ()
//                .background(.black)
                .overlay(alignment: .top, content:{
                    EventDetails()
                })
               // .padding (.leading, 5)
                .padding (.top, -180)
                .zIndex (0)
                .opacity (animateContent ? 1:0)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle ()
              // .fill(Color("otab"))
                .ignoresSafeArea()
//                .background(Color("otab"))
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
    
    @ViewBuilder
    func EventDetails() -> some View{
        VStack(){
            HStack(){
                Button {
                } label: {
                    Label("Reviews", systemImage: "text.alignleft")
                        .font (.callout)
                        .foregroundColor (.gray)
                }
                .frame (maxWidth: .infinity)
                
                Button {
                } label: {
                    Label ("Share", systemImage: "square.and.arrow.up")
                        .font (.callout)
                        .foregroundColor(.gray)
                }
                .frame (maxWidth: .infinity)
            }
            .hAlign(.center)
            
            Divider()
                .padding(.top, 25)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    
                    
                    VStack(spacing: 15){
                        Text ("About the event")
                            .foregroundColor(Color("otab"))
                            .font (.title3)
                            .fontWeight (.semibold)
                            .hAlign(.leading)
                        
                        
                        Text(event?.description ?? "")
                            .foregroundColor(Color("otab"))
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .hAlign(.leading)
                    
                    Spacer()
                    
                    Button{}
                label: {
                    Text("Book event")
                        .fontWeight (.bold)
                        .padding (.vertical,8)
                        .padding (.horizontal, 20)
                        .background{
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .foregroundColor(Color("otab"))
                        }
                }
                }
            }
        }
        .hAlign(.leading)
        .padding (.top, 200)
        .offset(y: offsetAnimation ? 0 : 100)
        .opacity (offsetAnimation ? 1: 0)
        
    }
        
    }

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
