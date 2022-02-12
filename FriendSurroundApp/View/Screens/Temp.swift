//
//  Temp.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/25/22.
//

import SwiftUI

struct Temp: View {
    var body: some View {
        Form {
            Section {
                List {
                    ZStack {
                        NavigationLink(destination: WhoIsCloseView().environmentObject(FriendViewModel()))
                        {
                            EmptyView()
                        }
                        .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                        
                        HStack {
                            Text("Who's Close").font(.system(size: 25, weight: .bold, design: .default))
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

struct Temp_Previews: PreviewProvider {
    static var previews: some View {
        Temp()
    }
}
