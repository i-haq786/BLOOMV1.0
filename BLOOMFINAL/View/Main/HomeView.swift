//
//  HomeView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        //tab bar view
        TabView{
            Text("Home")
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            Text("Passes")
                .tabItem{
                    Image(systemName: "ticket")
                    Text("Passes")
                }
            Text("Explore")
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            Text("Host")
                .tabItem{
                    Image(systemName: "sparkle")
                    Text("Host")
                }
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
        }.tint(.black)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
