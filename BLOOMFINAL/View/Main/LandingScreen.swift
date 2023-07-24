//
//  LandingScreen.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 14/06/23.
//

import SwiftUI

struct LandingScreen: View {
    
    @State private var event: [Event] = []
    @State var currentItem: Today?
    @State var showDetailPage: Bool = false
    @Namespace var animation
    @State var animateView: Bool = false
    @State var selectedView: Binding<Int>
    @State var selectedFilterTagIndex: Binding<Int>
    
//    ["Image 52","Image 53","Image 54","Image 55","Image 56","Image 57"]
//    var tags: [String] = [
//        "All", "Art", "Pottery", "Gardening", "Cooking", "Wellness", "Techshop", "Other"
//    ]
    
    var posters = [
        Poster(image: "Image 52", index: 3),
        Poster(image: "Image 53", index: 1),
        Poster(image: "Image 54", index: 4),
        Poster(image: "Image 55", index: 5),
        Poster(image: "Image 56", index: 2),
        Poster(image: "Image 57", index: 6),
    ]
    // @State var animateContent: Bool = false
    // @State var scrollOffset: CGFloat = 0
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMMM"
        return formatter
    }()
    
    
    var body: some View {
        //NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Text("Today")
                                .font(.largeTitle.bold())
                            Text(dateFormatter.string(from: Date()))
                                .font(.body)
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                            
                        }.hAlign(.leading)
                        
                        NavigationLink{
                            ProfileView()
                        }label:
                            {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .tint(Color("tab"))
                            }
                        
//                        NavigationLink(destination:ProfileView()){
//                            Button{
//                            }label: {
//                                Image(systemName: "person.circle.fill")
//                                    .font(.largeTitle)
//                                    .tint(Color("tab"))
//                            }
//                        }
                    }
                    .padding([.horizontal, .bottom])
                    .opacity(showDetailPage ? 0 : 1)
                    ZStack(alignment: .top){
                        Image("Image 51")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(.leading)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("Today")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, -70)
                                    .padding(.trailing, 170)
                                
                                
                                Button(action: {
                                    // Action to perform when the button is tapped
                                    print("Button tapped")
                                }) {
                                    HStack(spacing: 8) {
                                        Text("Swipe")
                                            .font(.headline)
                                        Image(systemName: "chevron.right")
                                            .font(.headline)
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    
                                    .cornerRadius(10)
                                }
                                
                                
                            }
                            .offset(y: -19)
                            
                            
                            ScrollSection(posters: posters, selectedView: selectedView, selectedFilterTagIndex: selectedFilterTagIndex)
                                .offset(x: -101, y: -10)
                            
                        }
                        .frame(height: 240, alignment: .leading)
                    }
                    
                    Text("Explore")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .top])
                    
                    ForEach(todayItems){item in
                        Button{
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction:0.7, blendDuration: 0.7)){
                                currentItem = item
                                showDetailPage = true
                            }
                        }
                    label:{
                        CardView(item: item)
                            .scaleEffect(currentItem?.id == item.id && showDetailPage ? 1 : 0.93)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ?( currentItem?.id == item.id ? 1 : 0):1)
                    }
                }
            }
            .overlay{
                if let currentItem = currentItem, showDetailPage{
                    DetailedView(item: currentItem)
                        .ignoresSafeArea(.container, edges: .top)
                }
            }
            .background(alignment: .top) {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("dark"))
                    .frame(height: animateView ? nil: 350, alignment: .top)
                    .opacity(animateView ? 1 : 0)
                    .ignoresSafeArea()
                    .scaleEffect(animateView ? 1 : 0.93)
            }
        }
        
        func shareEvent() {
            
            let shareText = "Please download BLOOM app to register for this Pottery Event.\nEvent: Pottery Making\nPotters Street\n30 June 2023"
            
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
        
        func DetailedView(item:Today)-> some View{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    CardView(item: item)
                        .scaleEffect(animateView ? 1 : 0.93)
                    
                    VStack(spacing: 15){
                        Text(item.description)
                            .foregroundColor(.white)
                            .padding()
                            .multilineTextAlignment (.leading)
                            .lineSpacing (10)
                            .padding(.bottom, 20)
                        
                        Divider()
                        
                        Button{
                            shareEvent()
                        }label:{
                            Label {
                                Text ("Share Event")
                            } icon: {
                                Image(systemName: "square.and.arrow.up.fill")
                            }
                            .foregroundColor(.primary)
                            .padding (.vertical, 10)
                            .padding (.horizontal, 25)
                            .background{
                                RoundedRectangle (cornerRadius: 5, style:.continuous)
                                    .fill(.ultraThinMaterial)
                            }
                        }
                    }
                    // .opacity(animateContent ? 1: 0)
                    .scaleEffect (animateView ? 1 : 0, anchor: .top)
                }
                //            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
                //            .offset(offset: $scrollOffset)
            }
            .coordinateSpace (name: "SCROLL")
            .overlay(alignment: .topTrailing, content: {
                Button {
                    
                    //closing views
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                        animateView = false
                        //  animateContent = false
                    }
                    withAnimation(.interactiveSpring (response: 0.6, dampingFraction: 0.7,
                                                      blendDuration: 0.7) .delay (0.05)){
                        currentItem = nil
                        showDetailPage = false
                    }
                } label: {
                    Image (systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                // .offset(y:-10)
                .opacity(animateView ? 1 : 0)
                .padding(.top, safeArea().top)
                .padding(.top, -5)
            })
            .onAppear{
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    animateView = true
                }
                
            }
            .transition(.identity)
        }
        
        //card view
        @ViewBuilder
        func CardView(item: Today)-> some View{
            VStack(alignment: .leading, spacing: 15){
                ZStack(alignment: .topLeading){
                    GeometryReader{proxy in
                        let size = proxy.size
                        
                        Image(item.pic)
                            .resizable()
                            .aspectRatio (contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
                        //  .clipShape(RoundedRectangle(cornerRadius: 15), style: .continuous)
                        
                    }.frame(height: 400)
                    LinearGradient(colors: [.black.opacity(0.3), .black.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom).clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text(item.organiserTitle.uppercased())
                            .font (.callout).foregroundColor(.white)
                            .fontWeight (.semibold)
                        Text (item.bannerTitle)
                            .font (.largeTitle.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }.padding()
                        .offset(y:currentItem?.id == item.id && animateView ? safeArea().top:0)
                }
                HStack{
                    VStack(alignment: .leading, spacing: 4){
                        Text(item.name)
                            .fontWeight(.bold).foregroundColor(.white)
                        Text(item.venue).font(.callout).foregroundColor(.gray)
                    }
                    Spacer()
                    Button{}
                label: {
                    Text("INFO")
                        .fontWeight (.bold)
                        .foregroundColor(Color("tab"))
                        .padding (.vertical,8)
                        .padding (.horizontal, 20)
                        .background{
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }
                }.padding([.horizontal, .bottom])
            }
            .background{
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("dark"))
                
            }
            .matchedGeometryEffect(id: item.id, in: animation)
        }
    }
//}

//struct LandingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingScreen()
//    }
//}

struct ScaledButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
