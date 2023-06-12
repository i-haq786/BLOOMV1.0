//
//  LoginView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 11/06/23.
//

import SwiftUI
import iPhoneNumberField
import Firebase

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
    
    //MARK: user defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        VStack(spacing: 10){
            Text ("BLOOM")
                .font (.largeTitle.bold ())
                .hAlign( .leading)
            
            Text ("Create Account")
                .font (.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Username", text: $userName)
                    .textContentType(.name)
                    .border(1, .black)
                    .padding(.top, 25)
                
                iPhoneNumberField("Mobile number", text: $phoneNum)
                    .border(1, .black)
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .black)
                
                SecureField( "Password", text: $password)
                    .textContentType (.password )
                    .border(1, .black)  
            
                Button(action: registerUser){
                    Text("Sign up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .disableWithOpacity(userName == "" || password == "" || emailID == "" || phoneNum == "" )
                .padding(.top)
            }
            
            HStack{
            Text ("Already have an account?")
                    .foregroundColor(.gray)
                
                Button ("Login Now"){
                    dismiss()
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
        .padding(15)
        .alert(errorMessage, isPresented: $showError, actions: {})
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View{
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition: Bool)-> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
        
    }
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    // Border View With Padding
    func border(_ width: CGFloat, _ color: Color)->some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    // Fill View With Padding
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    
}
