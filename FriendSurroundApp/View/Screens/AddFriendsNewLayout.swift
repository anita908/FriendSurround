//
//  ContentView.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/10/22.
//

import SwiftUI

struct AddFriendsNewLayout: View {

    @EnvironmentObject var contactsManager: ContactsManager

    @ScaledMetric(relativeTo: .largeTitle) var scale: CGFloat = 1.0

    var locationService = LocationService.shared
    var apiGateway = ApiGateway()

    @ViewBuilder
    var body: some View {

        subHeader(content: "Contacts with FriendSurround")
        massFriendRequest
            .frame(maxWidth: .infinity, alignment: .leading)
        contacts
            .onAppear(perform: contactsManager.updateContacts)
            

        Spacer()
            .navigationTitle("Add Friends")
    }
    
    @ViewBuilder
    func subHeader(content: String) -> some View {
        Text(content.uppercased())
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
    }

    var massFriendRequest: some View {
            Button("SEND REQUEST TO ALL", action: {
                contactsManager.massFriendRequst(from: locationService.currentUser, for: contactsManager.contacts)
            })
                .font(.system(size: 10 * scale, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 100 * scale, height: 30 * scale)
                .background(Color(0xFFB186))
                .cornerRadius(5.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .padding(.leading)
    }

    var inviteAllContacts: some View {
        NavigationLink("INVITE ALL CONTACTS", destination: {
        })
            .font(.system(size: 10 * scale, weight: .semibold))
            .foregroundColor(.black)
            .frame(width: 100 * scale, height: 30 * scale)
            .background(Color.white)
            .cornerRadius(5.0)
            .shadow(radius: 5.0, x: 10, y: 5)
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(0xFFB186), lineWidth: 2))
            .padding(.leading)

    }

    
    var contacts: some View {

//        DisclosureGroup("Contacts on FriendSurround"){
        NavigationView {
//            Section(header: Text("Contacts on FriendSurround")){
            ScrollView(.vertical){
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]){
    //                acceptRequestButton("mickey", "chris")
                        listContacts(thatAreAppUsers: true)
                        inviteAllContacts
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                LazyVStack(alignment: .leading){
    //                acceptRequestButton("mickey", "chris")
                    listContacts(thatAreAppUsers: true)
                    inviteAllContacts
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
    }
    }
    
    @ViewBuilder
    func listContacts(thatAreAppUsers: Bool) -> some View{
        ForEach(contactsManager.contacts.sorted{$0.friendshipStatus < $1.friendshipStatus}, id: \.self) { contact in
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
                        inviteToAppButton
                    }
                    else if contact.friendshipStatus == .notFriends {
                        friendRequestButton(locationService.currentUser, contact.username ?? "")
                    }
                    else if contact.friendshipStatus == .requestSent {
                        requestSentText
                    }
                }
            }
        }
    }

    var inviteToAppButton: some View{
        NavigationLink("INVITE TO APP", destination: {
        })
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

struct AddFriendsNewLayout_Previews: PreviewProvider {
    static var previews: some View {
        AddFriends()
    }
}
