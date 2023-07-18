//
//  AccountDetailView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 16/06/23.
//
//


import SwiftUI

struct AccountDetailView: View {
    @State  var pro: User
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    //@AppStorage("user_Number") var userNumber: String = ""

    @State private var name: String = ""
    @State private var isUserNameEditing: Bool = false
    @State private var isPhoneEditing: Bool = false
    

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                if isUserNameEditing {
                    TextField("Input Name here", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    Text(userNameStored)
                        .font(.title2)
                        .fontWeight(.medium)
                        
                }
                Spacer()
                Button(action: {
                    isUserNameEditing.toggle()
                }) {
                    if isUserNameEditing {
                        Text("Done")
                            .fontWeight(.bold)
                    } else {
                        Text("Edit")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .frame(height: 40)
                .cornerRadius(10)
            }
            .padding()
            
            
            HStack {
                
                if isPhoneEditing {
                    TextField("Input Name here", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    Text(pro.userNumber)
                        .font(.title2)
                        .fontWeight(.medium)
                        
                }
                Spacer()
                Button(action: {
                    isPhoneEditing.toggle()
                }) {
                    if isPhoneEditing {
                        Text("Done")
                            .fontWeight(.bold)
                    } else {
                        Text("Edit")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .frame(height: 40)
                .cornerRadius(10)
            }
            .padding()
            
        }
        .frame(width: 370)
        .vAlign(.top)
    }
}

//struct AccountDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountDetailView()
//    }
//}
