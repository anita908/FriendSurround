//
//  MyAccountView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//

import SwiftUI

struct MyAccountView: View {
    var body: some View {
        Form {
            Text("It's meeeee")
        }
        .navigationBarTitle("My Account", displayMode: .inline)
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
