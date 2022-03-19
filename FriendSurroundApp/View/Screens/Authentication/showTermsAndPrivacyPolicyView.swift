//
//  showTermstView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//

import SwiftUI

struct showTermsAndPrivacyPolicyView: View {
    var onDismiss: () -> ()

    var body: some View {

        NavigationView {
            VStack {
                Text("Our terms blablabla")
            }
            .navigationBarTitle("Terms and Privacy Policy", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                onDismiss()
            }){
                Text("Cancle")
            }
        )}
    }
}

struct showTermstView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
