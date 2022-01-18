//
//  ButtonStyle.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//
import SwiftUI

struct CustomButtonStyle: ButtonStyle {

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration)
    }

    struct MyButton: View {

        let configuration: ButtonStyle.Configuration

        @Environment(\.isEnabled) private var isEnabled: Bool


        var body: some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 70)
                .background(Color.orange)
                .cornerRadius(15.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .padding()
                .disabled(!isEnabled)
        }
    }
}
