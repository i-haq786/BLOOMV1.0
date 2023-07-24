//
//  ContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 10/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("interest_set") var interestSet: Bool = false
    
    var body: some View {
        //redirecting users based on log status
        if logStatus, interestSet{
            HomeView()
        } else if !interestSet{
            InterestView()
        }
        else{
            LoginView()
        }
//        CreateNewEvent{_ in
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
