//
//  HomeView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedView = 0
    @State var selectedFilterTagIndex = 0

    
    var body: some View {
        //tab bar view
        TabView(selection: $selectedView){
            LandingScreen(selectedView: $selectedView, selectedFilterTagIndex: $selectedFilterTagIndex)
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
           PassesView()
                .tabItem{
                    Image(systemName: "ticket")
                    Text("Passes")
                }
                .tag(1)
            ExploreView(activeTagIndex: $selectedFilterTagIndex)
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .tag(2)
            HostEventView()
                .tabItem{
                    Image(systemName: "sparkle")
                    Text("Host")
                }
                .tag(3)
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .tint(Color("tab"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
