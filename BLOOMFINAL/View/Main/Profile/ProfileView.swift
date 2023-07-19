//
//  ProfileView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import StoreKit

struct ProfileView: View {
    
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //    @State private var selectedMenuItem: MenuItem?
    //    @StateObject private var profileData = ProfileData()
    @State private var isProfileExpanded = false
    @State private var isShowingDislikePopover = false
    
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .center){
                
                if let myProfile{
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ZStack{
                            VStack {
                                HStack(spacing: 26) {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color("accent"))
                                        .padding(.top, 24)
                                        .background(Color("myGray"))
                                        .clipShape(Circle())
                                    
                                    VStack {
                                        Text(myProfile.userName)
                                            .font(.system(size: 24))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color("primary"))
                                        
                                        Text(myProfile.userNumber)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(radius: 0)
                            }
                            //.vAlign(.top)
                            .frame(width: 360, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 2)
                            
                        }
                        .padding()
                        .refreshable {
                            //refresh user data
                            self.myProfile = nil
                            await fetchUserData()
                        }
                        
                        // Bottom Menu
                        VStack(alignment: .leading, spacing: 20) {
                            NavigationLink(destination:AccountDetailView(pro: myProfile )){
                                ProfileInfoRow(title: "My Account", description: "Your Personal Profile")
                            }
                            
                            Divider()
                            
                            NavigationLink(destination:BookmarkPage()){
                                ProfileInfoRow(title: "Bookmarks", description: "Bookmarks & Settings")
                            }
                            
                            Divider()
                            
                            
                            NavigationLink(destination:address(pro: myProfile)){
                                ProfileInfoRow(title: "Addresses", description: "Enter and edit your address")
                            }
                            
                            Divider()
                            
                            NavigationLink(destination:FAQView()){
                                ProfileInfoRow(title: "Help & FAQs", description: "FAQ's & updates")
                            }
                            
                            Divider()
                            
                        }.padding()
                        
                        
                        VStack(alignment: .center) {
                            
                            Text("Like our platform? Rate us")
                                .foregroundColor(Color("background"))
                                .font(.callout)
                                .fontWeight(.medium)
                            
                            
                            ZStack {
                                Color("primary").edgesIgnoringSafeArea(.all)
                                
                                HStack {
                                    Image("Image 45")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 180, height: 180)
                                        .padding([.leading, .trailing], 15)
                                    
                                    
                                    VStack(alignment: .leading) {
                                        Text("Give us your feedback!")
                                            .foregroundColor(Color("background"))
                                            .font(.callout)
                                            .fontWeight(.bold)
                                        
                                        Text("Your word makes Bloom a better place.")
                                            .foregroundColor(Color("background"))
                                            .font(.footnote)
                                        
                                        
                                        HStack {
                                            Button(action: {
                                                // Handle like button action
                                                requestAppRating()
                                            }) {
                                                Image("Image 46")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                            }
                                            .foregroundColor(.green)
                                            
                                            Button(action: {
                                                // Handle dislike button action
                                                isShowingDislikePopover = true
                                            }) {
                                                Image("Image 47")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                            }
                                            .foregroundColor(.red)
                                            .sheet(isPresented: $isShowingDislikePopover) {
                                                DislikeFeedbackView(isShowing: $isShowingDislikePopover)
                                            }
                                        }.padding(.leading, 20)
                                        
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 380, height: 200)
                            
                            
                            HStack {
                                Text("Rate us on App Store")
                                    .foregroundColor(Color("background"))
                                    .font(.callout)
                                    .fontWeight(.medium)
                                
                                Button(action: {
                                    // Handle button action here
                                    requestAppRating()
                                    
                                }) {
                                    Image("Image 27")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 50)
                                }
                                
                            }
                        }
                        .padding()
                        .frame(width: 370)
                        .background(Color("dark")).cornerRadius(30)
                        
                        
                        //                        }
                    }
                    
                }else{
                    ProgressView()
                }
            }
            // .padding()
            .navigationTitle("My Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("Logout", action: logout)
                        Button("Delete Account", role: .destructive,action: deleteAccount)
                    }label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(Color("tab"))
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
        }.background(.white)
    }
    
    func requestAppRating() {
        SKStoreReviewController.requestReview()
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
                    .foregroundColor(Color("primary"))
                Text(description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(Color("primary"))
            }
            
            Spacer()
            
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.primary)
            
        }.frame(width: 370)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
