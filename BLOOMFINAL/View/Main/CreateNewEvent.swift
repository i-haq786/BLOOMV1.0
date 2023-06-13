//
//  HostEventView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 12/06/23.
//

import SwiftUI
import PhotosUI
import MapItemPicker
import FirebaseStorage
import Firebase

struct CreateNewEvent: View {
    //callbacks
    var onEvent: (Event)->()
    //event properties
    @State private var eventName : String = ""
    @State private var eventID: String = ""
    @State private var eventImage: Data?
    @State private var eventDesc: String = ""
    @State private var eventVenue: String = ""
    @State private var eventInterests: [String] = []
    @State private var eventTime: Date = Date()
    
    //user defaults
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    //properties
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss
    @State var isLoading: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    @State private var showingPicker = false
    
    var body: some View {
        VStack{
            HStack{
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                .hAlign(.leading)
                Button (action: createEvent){
                    Text("Host")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical,6)
                        .background(.black, in: Capsule())
                }
            }
            .padding (.horizontal, 15)
            .padding (.vertical, 10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    
                    if let eventImage, let image = UIImage(data: eventImage){
                        GeometryReader{
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable ()
                                .aspectRatio (contentMode: .fill)
                                .frame (width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            //delete button
                                .overlay(alignment: .topTrailing){
                                    Button{
                                        withAnimation(.easeInOut(duration: 0.25)){
                                            self.eventImage = nil
                                        }
                                    }label: {
                                        Image(systemName: "trash")
                                            .fontWeight(.bold)
                                            .tint(.white)
                                    }
                                    .padding(8)
                                    .background(Circle().fill(.white.opacity(0.4)))
                                    .padding(10)
                                }
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                    
                    TextField("Event Name", text: $eventName, axis: .vertical)
                        .border(0.5, .black.opacity(0.2)).focused($showKeyboard)
                    
                    TextField("About the event", text: $eventDesc, axis: .vertical)
                        .frame(minHeight: 100, alignment: .top)
                        .border(0.5, .black.opacity(0.2)).focused($showKeyboard)
                    
                    HStack{
                        TextField("Event Venue", text: $eventVenue, axis: .vertical)
                        
                        Button{
                            showingPicker = true
                        }label: {
                            Image(systemName: "location.fill")
                                .font(.title3).tint(.black)
                        }
                        .mapItemPicker(isPresented: $showingPicker) { item in
                            if let name = item?.name {
                                eventVenue = name
                            }
                        }
                    }
                    .border(0.5, .black.opacity(0.2))
                    
                    //datepicker
                    DatePicker(selection: $eventTime){
                        Text("Event date")
                        
                    }
                }
                .padding()
            }
            
            Divider()
            
            HStack{
                Button{
                    showImagePicker.toggle()
                }label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
                .hAlign(.leading)
                Button("Done"){
                    showKeyboard = false
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal,15)
            .padding(.vertical, 10)
        }
        .vAlign(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem){ newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5){
                        await MainActor.run(body: {
                            eventImage = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay{
            LoadingView(show: $isLoading)
        }
    }
    //post content to firebase
    func createEvent(){
        isLoading = true
        showKeyboard = false
        Task{
            do{
                let imageReferenceID = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("EventBannerImage").child(imageReferenceID)
                if let eventImage{
                    let _ = try await storageRef.putDataAsync(eventImage)
                    let downloadURL = try await storageRef.downloadURL()
                    //event data without image
                    let event = Event(name: eventName, imgID:imageReferenceID, venue: eventVenue, description: eventDesc, date: eventTime, userName: userNameStored, userUID: userUID)
                    try await createDocumentAtFirebase(event)
                }else{
                    //without images
                    let event = Event(name: eventName, venue: eventVenue, description: eventDesc, date: eventTime, userName: userNameStored, userUID: userUID)
                    try await createDocumentAtFirebase(event)
                    
                }
            }
            catch{
                await setError(error)
            }
        }
    }
    
    
    func createDocumentAtFirebase(_ event: Event )async throws{
        let _ = try Firestore.firestore().collection("Events").addDocument(from: event, completion:{ error in
            if error == nil{
                //event successfully updated
                isLoading = false
                onEvent(event)
                dismiss()
            }
        })
    }
    
    func setError(_ error:Error)async{
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

struct CreateNewEvent_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewEvent{_ in

        }
    }
}
