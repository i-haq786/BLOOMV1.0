//
//  ContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 10/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        //redirecting users based on log status
        if logStatus{
            Text("Main View")
        }else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
