//
//  MessageComponentView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 3/11/22.
//

import SwiftUI
import MessageUI

struct MessageComponentView: UIViewControllerRepresentable {
    typealias CompletionHandler = (_ messageSent: Bool) -> Void
    
    static var canSendText: Bool {
        MFMessageComposeViewController.canSendText()
    }
    
    let recicipents: [String]?
    let body: String?
    let completion: CompletionHandler?
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard Self.canSendText else {
            return UIHostingController(rootView: messageUnavailable)
        }
        
        let controller = MFMessageComposeViewController()
        
        controller.messageComposeDelegate = context.coordinator
        controller.recipients = recicipents
        controller.body = body
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        private let completion: CompletionHandler?
        
        init(completion: CompletionHandler?) {
            self.completion = completion
        }
        
        func messageComposeViewController (_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            completion?(result == .sent)
        }
    }
    
    var messageUnavailable : some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .font(.system(size: 64))
                .foregroundColor(.red)
            Text("Text messae unavailable")
                .font(.system(size:24))
        }
    }
}

//struct MessageComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageComponentView()
//    }
//}
