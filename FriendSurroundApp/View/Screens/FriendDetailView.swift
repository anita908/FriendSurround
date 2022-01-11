//
//  FriendDetailView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import SwiftUI

struct FriendDetailView: View {
    
    var user: User
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State private var editMode: EditMode = .inactive

    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                Form {
                    Text(user.name)
                    
                    HStack {
                        Text("How you know them: ")
                        EditableText(
                            text: "\(user.connection)",
                            isEditing: editMode.isEditing,
                            textAlignment: .trailing
                        ) { updatedText in
                            friendViewModel.updateConnection(connection: updatedText, for: user)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("\(user.name)"), displayMode: .inline)
        .navigationBarItems(
            trailing: EditButton()
        )
        .environment(\.editMode, $editMode)

    }
}

//struct FriendDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailView(user:User)
//    }
//}
