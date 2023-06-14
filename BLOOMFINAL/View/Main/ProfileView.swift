//
//  ProfileView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .center){
                if let myProfile{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            HStack {
                                HStack{
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color("background"))
                                    
                                    Text(myProfile.userName)
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("background"))
                                    
                                }
                                .padding()
                                
                                
                                Text("|")
                                    .font(.caption)
                                    .foregroundColor(Color("background"))
                                
                                HStack{
                                    Text(myProfile.userNumber)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Image(systemName: "pencil.circle")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color("background"))
                                }.padding()
                                
                            }
                            .frame(width: 370, height: 50)
                            .background(Color("highlight")).cornerRadius(20)
                            .vAlign(.top)
                            .refreshable {
                                //refresh user data
                                self.myProfile = nil
                                await fetchUserData()
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ProfileInfoRow(title: "My Account", description: "Bookmarks & Settings")
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                ProfileInfoRow(title: "Address", description: "Enter & Edit Address")
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                ProfileInfoRow(title: "Payment & refunds",description: "Payment history and refund status")
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                ProfileInfoRow(title: "Help",description: "FAQ's & updates")
                                
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                ProfileInfoRow(title: "Interests",description: "Edit & update your interests")
                            }
                            .padding()
                            .frame(width: 370)
                            .background(Color("highlight")).cornerRadius(30)
                            
                            VStack(alignment: .center, spacing: 10) {
                                
                                Text("Like our platform? Rate us")
                                    .foregroundColor(Color("background"))
                                    .font(.callout)
                                    .fontWeight(.medium)
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                Image("Image 41")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 380, height: 180)
                                    .background(Color("primary"))
                                
                                Divider()
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Text("Rate us on App Store")
                                        .foregroundColor(Color("background"))
                                        .font(.callout)
                                        .fontWeight(.medium)
                                    
                                    Image("Image 27")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 50)
                                    
                                }
                            }
                            .padding()
                            .frame(width: 370)
                            .background(Color("highlight")).cornerRadius(30)
                            
                            
                        }
                    }
                    
                }else{
                    ProgressView()
                }
            }
            .padding(15)
            .background(Color("background"))
            .navigationTitle("My Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("Logout", action: logout)
                        Button("Delete Account", role: .destructive,action: deleteAccount)
                    }label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect (0.8)
                    }
                }
            }
            .overlay{
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError, actions: {})
            .task {
                if myProfile != nil {return}
                //initial fetch
                await fetchUserData()
            }
            //  }
        }
    }
    
    func fetchUserData()async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    func logout(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                //delete user
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                //delete auth account and set log status
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            }catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error:Error)async{
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileBackgroundView: View {
    
    var body: some View {
        VStack{
            Image("Image 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .offset(x: 120,y: -270)
            
            Image("Image 29")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 300)
                .rotationEffect(Angle(degrees: -25))
                .offset(x: -120, y: 200)
            
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("background"))
    }
}

struct ProfileInfoRow: View {
    var title: String
    var description: String = "Lorem Ipsum"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color("background"))
                Text(description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color("background"))
            }
            
            Spacer()
            
            Image("Image 50")
                .resizable()
                .frame(width: 5, height: 10)
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
