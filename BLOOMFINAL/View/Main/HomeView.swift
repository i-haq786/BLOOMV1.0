//
//  HomeView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI

struct HomeView: View {
//    init() {
//           // Customize the appearance of the UITabBar
//
//       }
    var body: some View {
        //tab bar view
        TabView{
            LandingScreen()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
           PassesView()
                .tabItem{
                    Image(systemName: "ticket")
                    Text("Passes")
                }
            ExploreView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            HostEventView()
                .tabItem{
                    Image(systemName: "sparkle")
                    Text("Host")
                }
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(Color("tab"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
