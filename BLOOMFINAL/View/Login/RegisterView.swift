//
//  RegisterView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import iPhoneNumberField

struct RegisterView: View{
    //user details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var phoneNum: String = ""
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss
    @State var isLoading: Bool = false
    @State private var isAccepted = false

    
    //MARK: user defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        ZStack {
            RegisterBackgroundView()
            VStack(spacing: 10){
                Text ("BLOOM")
                    .font (.largeTitle.bold())
                    .hAlign( .leading)
                    .padding(.top, 20)
                
                Image("Image 19")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 270, height: 270)
                
                Text ("Create Account")
                    .font (.title3.bold())
                    .hAlign(.leading)
                    .padding(.bottom, 10)
                
                VStack(spacing: 20){
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 44)
                        
                        Text ("User Name")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 120, height: 20)
                            .background(Color("background"))
                            .foregroundColor(Color("primary"))
                            .offset(x:20, y: -10)
                        
                        TextField("Allen123", text: $userName)
                            .textContentType(.name)
                            .padding(.top, 15)
                            .padding(.leading, 30)
                    }
                    
//                    TextField("Username", text: $userName)
//                        .textContentType(.name)
//                        .border(1, .black)
//                        .padding(.top, 25)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 44)
                        
                        Text ("Phone Number")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 150, height: 20)
                            .background(Color("background"))
                            .offset(x:20, y: -10)
                        
                        iPhoneNumberField("+91 78******16", text: $phoneNum)
                            .textContentType(.name)
                            .padding(.top, 15)
                            .padding(.leading, 30)
                    }
                    
//                    iPhoneNumberField("Mobile number", text: $phoneNum)
//                        .border(1, .black)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 44)
                        
                        Text ("Email Address")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 150, height: 20)
                            .background(Color("background"))
                            .offset(x:20, y: -10)
                        
                        TextField("example@email .com", text: $emailID)
                            .textContentType(.emailAddress)
                            .padding(.top, 15)
                            .padding(.leading, 30)
                            .autocapitalization(.none)
                    }
                    
//                    TextField("Email", text: $emailID)
//                        .textContentType(.emailAddress)
//                        .border(1, .black)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 44)
                        
                        Text ("Password")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 100, height: 20)
                            .background(Color("background"))
                            .offset(x:20, y: -10)
                        
                        SecureField("********", text: $password)
                            .textContentType (.password )
                            .padding(.top, 15)
                            .padding(.leading, 30)
                            .autocapitalization(.none)
                    }
                    
                    HStack {
                        Image(systemName: isAccepted ? "checkmark.square.fill" : "square")
                            .foregroundColor(isAccepted ? Color("accent") : .gray)
                            .onTapGesture {
                                isAccepted.toggle()
                            }

                            Text("I accept the Terms and Conditions.")
                                .font(.headline)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    isAccepted.toggle()
                            
                        }
                    }
                    
//                    SecureField( "Password", text: $password)
//                        .textContentType (.password )
//                        .border(1, .black)
//
                    Button(action: registerUser){
                        Text("Sign up")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                            .cornerRadius(15)
                    }
                    .padding(.top)
                    .frame(width: 130)
                    .disableWithOpacity(userName == "" || password == "" || emailID == "" || phoneNum == "" || !isAccepted )
                    
                    
                }
                
                VStack{
                Text ("Already have an account?")
                        .foregroundColor(Color("primary"))
                    
                    Button ("Login Now"){
                        dismiss()
                    }
                    .fontWeight (.bold)
                    .foregroundColor(Color("accent"))
                }
                .font(.callout)
                .vAlign(.topLeading)
            }
            .vAlign(.top)
            .padding(15)
            .alert(errorMessage, isPresented: $showError, actions: {})
            .overlay(content: {
                LoadingView(show: $isLoading)
        })
        }
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                let user = User(userName: userName, userEmail: emailID, userUID: userUID, userNumber: phoneNum)
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil{
                        print("saved successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        logStatus = true
                    }
                })
            }catch{
                await setError(error)
            }
        }
    }
    func setError(_ error:Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct RegisterBackgroundView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Image("Image 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .offset(x: 150,y: -320)
            
            Image("Image 29")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 300)
                .rotationEffect(Angle(degrees: -25))
                .offset(x: -205, y: 400)
                
          
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("background"))
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
