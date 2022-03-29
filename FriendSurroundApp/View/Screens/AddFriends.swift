//
//  ContentView.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/10/22.
//

import SwiftUI

struct AddFriends: View {

    @EnvironmentObject var contactsManager: ContactsManager
    
    @ScaledMetric(relativeTo: .largeTitle) var scale: CGFloat = 1.0
    
    @State private var showMessageModel = false
    @State private var invitePhoneNumber = ""
    @State private var searchText = ""
    
    var locationService = LocationService.shared
    var apiGateway = ApiGateway()
    
    @ViewBuilder
    var body: some View {
        mass_invite_options
        contacts
            .onAppear(perform: contactsManager.updateContacts)
        Spacer()
            .navigationTitle("Add Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        contactsManager.updateContacts()
                    }
                }
            }
            .sheet(isPresented: $showMessageModel) {
                MessageComponentView(
                    recicipents: [invitePhoneNumber],
                    body: "\(UserData.shared.firstName) is inviting you to try out FriendSurround! This app is currently in the testing phase so you will have to download it through Apple TestFlight at this link. https://testflight.apple.com/join/LFdUYZCj Thanks for your support!"
                ) {
                    messageSent in
                    showMessageModel = false
                }
            }
    }
    
    var mass_invite_options: some View {
        HStack {
            Button("SEND REQUEST TO ALL", action: {
                contactsManager.massFriendRequst(from: locationService.currentUser, for: contactsManager.contacts)
            })
                .font(.system(size: 10 * scale, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 100 * scale, height: 30 * scale)
                .background(Color(0xFFB186))
                .cornerRadius(5.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .padding()
            Spacer()
//            NavigationLink("INVITE ALL CONTACTS", destination: {
//            })
//                .font(.system(size: 10 * scale, weight: .semibold))
//                .foregroundColor(.black)
//                .frame(width: 100 * scale, height: 30 * scale)
//                .background(Color.white)
//                .cornerRadius(5.0)
//                .shadow(radius: 5.0, x: 10, y: 5)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color(0xFFB186), lineWidth: 2))
//                .padding()
        }
    }
    
    var contacts: some View {
            ScrollView(.vertical){
                LazyVStack(alignment: .leading){
                    ForEach(UserData.shared.potentialFriends) { user in
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50 * scale, height: 50 * scale)
                                .accessibility(hidden: true)
                            Text(user.username)
                            Spacer()
                            VStack(alignment: .trailing){
                                if user.friendshipStatus == .requestReceived {
                                    acceptRequestButton(locationService.currentUser, user.username)
                                }
                            }
                        }
                        
                    }
                    if searchResults.count == 0 {
                        Text("No match")
                          .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(searchResults.sorted{$0.friendshipStatus < $1.friendshipStatus}, id: \.self) { contact in
                            HStack {
                                if contact.profileImage != nil {
                                    Image(uiImage: UIImage(data: contact.profileImage!)!)
                                                        .resizable()
                                                        .frame(width: 50 * scale, height: 50 * scale)
                                                        .accessibility(hidden: true)
                                }
                                else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 50 * scale, height: 50 * scale)
                                        .accessibility(hidden: true)
                                }
                                VStack(alignment: .leading){
                                    Text(contact.fullName)
                                    Text(contact.phoneNumber ?? "")
                                }
                                .accessibilityElement(children: .combine)

                                Spacer()
                                VStack(alignment: .trailing){
                                    if contact.friendshipStatus == .notAnAppUser {
                                        inviteToAppButton(contact.phoneNumberDigits!)
                                    }
                                    else if contact.friendshipStatus == .notFriends {
                                        friendRequestButton(locationService.currentUser, contact.username ?? "")
                                    }
                                    else if contact.friendshipStatus == .requestSent {
                                        requestSentText
                                    }
                                    else if contact.friendshipStatus == .requestReceived {
                                        acceptRequestButton(locationService.currentUser, contact.username ?? "")
                                    }
                                    else if contact.friendshipStatus == .friends {
                                        viewProfile(contact.username ?? "")
                                    }
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search name")
                .padding()
        }
    }
    
    @ViewBuilder
    func inviteToAppButton(_ phoneNumber: String) -> some View {
        Button("Invite to app") {
            invitePhoneNumber = phoneNumber
            showMessageModel = true
        }
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.black)
            .frame(width: 85 * scale, height: 30 * scale)
            .background(Color.white)
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(0xFFB186), lineWidth: 2))
    }
    
    var searchResults: [ContactsApp.Contact] {
        if searchText.isEmpty {
            return contactsManager.contacts
        } else {
            return contactsManager.contacts.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
//    var inviteToAppButton: some View{
//        NavigationLink("INVITE TO APP", destination: {
//        })
//            .font(.system(size: 10 * scale, weight: .semibold))
//            .foregroundColor(.black)
//            .frame(width: 85 * scale, height: 30 * scale)
//            .background(Color.white)
//            .cornerRadius(5.0)
//            .shadow(radius: 5.0, x: 10, y: 5)
//            .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color(0xFFB186), lineWidth: 2))
//    }
    
    @ViewBuilder
    func viewProfile(_ username: String) -> some View {
        let friend = contactsManager.getFriend(from: username)
        
        NavigationLink("View Profile", destination: {
            FriendDetailView(user: friend).environmentObject(FriendViewModel())
        })
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.black)
            .frame(width: 85 * scale, height: 30 * scale)
            .background(Color(0xFFB186))
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
                
    }
    
    
    var requestSentText: some View{
        Text("REQUEST SENT")
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 85 * scale, height: 30 * scale)
            .multilineTextAlignment(.center)
            .background(Color(0x00AD11))
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
    }
    
    @ViewBuilder
    func friendRequestButton(_ username: String, _ friendUsername: String)-> some View {
        Button("SEND REQUEST", action: {
            contactsManager.sendFriendRequest(from: username, to: friendUsername)
        })
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.black)
            .frame(width: 85 * scale, height: 30 * scale)
            .background(Color(0xFFB186))
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
    }
    
    @ViewBuilder
    func acceptRequestButton(_ username: String, _ friendUsername: String)-> some View {
        Button("ACCEPT REQUEST", action: {
            contactsManager.acceptFriendRequest(from: username, to: friendUsername)
        })
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 85 * scale, height: 30 * scale)
            .multilineTextAlignment(.center)
            .background(Color(0x00AD11))
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
    }
    
    
}

struct AddFriends_Previews: PreviewProvider {
    static var previews: some View {
        AddFriends()
    }
}
