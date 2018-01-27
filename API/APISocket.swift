//
//  APISocket.swift
//  Linky
//
//  Created by Alican Yilmaz on 16/12/2017.
//  Copyright © 2017 Alican Yilmaz. All rights reserved.
//

import Foundation
import SocketIO
import NotificationBannerSwift
/// This is the TCP socket wrapper of the app.
class APISocket {
    private let manager = SocketManager(socketURL: URL(string:"http://104.45.22.103:4000")!)
    static let shared = APISocket()
    var socket:SocketIOClient
    private init(){
        self.socket = manager.defaultSocket
        self.socket.on("localchatnotif", callback: {(data, ack) in
            do {
                let dataFromString = String(describing: data[0]).data(using: .utf8)
                let modeledNotif = try JSONDecoder().decode(NotifMessage.self, from: dataFromString!)
                let banner = NotificationBanner(title: modeledNotif.sender!, subtitle: modeledNotif.msg!, leftView: UIImageView(image:UIImage(named:"msg")), rightView: nil, style: .success, colors: nil)
                banner.show()

            } catch  {
                let banner = StatusBarNotificationBanner(title: error.localizedDescription)
                banner.show()
            } 
            

        })
    }
    /// Use this method to establish a connection to the socket.io server.
    /// - Parameter token: Json web token that obtained from login() method.
    /// - returns: Void
    func establishConnection(token:String){
        if(self.socket.status != .connected){
            self.socket = self.manager.defaultSocket
            self.manager.config = SocketIOClientConfiguration(arrayLiteral: .compress,.extraHeaders(["Authorization": token]))
            self.socket.connect()
        }
    }
    /// Use this method to deisconnect client from socket.io server.
    /// - returns: Void
    func disconnectSocket(){
        if(self.socket.status == .connected){
            self.manager.disconnect()
        }
    }
    
    
    
}
