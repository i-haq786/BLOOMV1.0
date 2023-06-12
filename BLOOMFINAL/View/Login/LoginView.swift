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
        
        VStack(spacing: 10){
            Text ("BLOOM")
                .font (.largeTitle.bold ())
                .hAlign( .leading)
            
            Text ("Login")
                .font (.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Email", text: $emailID)
                    .border(1, .black)
                    .padding(.top, 25)
                
                SecureField( "Password", text: $password)
                    .textContentType (.emailAddress )
                    .border(1, .black)
                
                Button ("Reset password?", action: resetPassword)
                    .font (.callout)
                    .fontWeight (.medium)
                    .tint (.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser){
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top)
            }
            
            HStack{
            Text ("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button ("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight (.bold)
                .foregroundColor (.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .vAlign(.top)
        .padding (15)
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
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



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
