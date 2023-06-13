//
//  LoginView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 11/06/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import iPhoneNumberField

struct LoginView: View {
    //user details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //MARK: user defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    var body: some View {
        
      ZStack {
            LoginBackgroundView()
            VStack(spacing: 10){
                Text ("BLOOM")
                    .font (.largeTitle.bold ())
                    .hAlign( .trailing)
                    .padding(.top, 30)
                
                Image("Image 15")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                
//                Text ("Login")
//                    .font (.title3)
//                    .hAlign(.leading)
                
                Text ("Login to your account")
                    .font (.title3.bold())
                    .hAlign(.leading)
                    .padding(.bottom, 20)
                
                VStack(spacing: 12){
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 55)
                        
                        Text ("Email ID")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 120, height: 20)
                            .background(Color("background"))
                            .offset(x:20, y: -10)
                        
                        TextField("example@email. com", text: $emailID)
                            .padding(.top, 15)
                            .padding(.leading, 30)
                            .autocapitalization(.none)
                    }
                    .padding(.bottom, 20)
                    
//                    TextField("Email", text: $emailID)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.top, 25)
//                        .autocapitalization(.none)
                    
                    ZStack(alignment: .topLeading) {
                        
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("myGray"), lineWidth: 2)
                            .frame(width: 370, height: 55)
                        
                        Text ("Password")
                            .font (.title3)
                            .fontWeight(.medium)
                            .frame(width: 120, height: 20)
                            .background(Color("background"))
                            .offset(x:20, y: -10)
                        
                        SecureField( "***********", text: $password)
                            .textContentType (.emailAddress)
                            .padding(.top, 19)
                            .padding(.leading, 30)
                            .autocapitalization(.none)
                    }
//                    SecureField( "Password", text: $password)
//                        .textContentType (.emailAddress )
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .autocapitalization(.none)
                    
                    Button ("Reset password?", action: resetPassword)
                        .foregroundColor(Color("accent"))
                        .font(.callout)
                        .fontWeight (.medium)
                        .tint (.black)
                        .hAlign(.trailing)
                    
//                    Button ("Reset password?", action: resetPassword)
//                        .font (.callout)
//                        .fontWeight (.medium)
//                        .tint (.black)
//                        .hAlign(.trailing)
                    
                    Button(action: loginUser){
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(Color("background"))
                            .hAlign(.center)
                            .fillView(Color("primary"))
                            .cornerRadius(15)
                    }
                    .frame(width: 130)
                    
//                    Button(action: loginUser){
//                        Text("Login")
//                            .foregroundColor(.white)
//                            .hAlign(.center)
//                            .fillView(.black)
//                    }
//                    .padding(.top)
                }
                
                VStack{
                Text ("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    Button ("Register Now"){
                        createAccount.toggle()
                    }
                    .fontWeight (.bold)
                    .foregroundColor(Color("accent"))
                }
                .font(.callout)
//                .vAlign(.bottom)
            }
            .vAlign(.top)
            .padding (15)
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .fullScreenCover(isPresented: $createAccount){
                RegisterView()
            }
        .alert(errorMessage, isPresented: $showError, actions: {})
        }
    }
    
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("user found")
                try await fetchUser()
            }
            catch{
                await setError(error)
            }
        }
    }
    
    //MARK: fetch user, if found
    func fetchUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        //ui update
        await MainActor.run(body: {
            //set user defaults and change app's auth status
            userUID = userID
            userNameStored = user.userName
            logStatus = true
        })
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent!")
            }
            catch{
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

struct LoginBackgroundView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Image("Image 20")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .offset(x: -80,y: -290)
            
            Image("Image 29")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 300)
                .rotationEffect(Angle(degrees: -25))
                .offset(x: 180, y: 420)
                
          
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("background"))
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
