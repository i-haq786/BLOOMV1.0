//
//  BLOOMFINALApp.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 10/06/23.
//

import SwiftUI
import Firebase

@main
struct BLOOMFINALApp: App {
   
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
              
        }
    }
}

