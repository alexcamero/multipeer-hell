//
//  Connect.swift
//  MultipeerHell
//
//  Created by Alex Cameron on 4/21/21.
//

import Foundation
import MultipeerConnectivity

struct Other: Identifiable, Equatable {
    var id = UUID()
    var mcid: MCPeerID
}

class Connect: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, ObservableObject, MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        do {
            try self.mcSession.send(JSONEncoder().encode(self.numbers), toPeers: self.mcSession.connectedPeers, with: .reliable)
        } catch {
            print("pffft")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async(execute: {
            do {
                self.colorConnection[peerID] = try JSONDecoder().decode([Int].self, from: data)
            } catch {
                print("no no no no")
            }
            if !self.connected.contains(peerID) {
                self.connected = self.mcSession.connectedPeers
            }
        })
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
        DispatchQueue.main.async(execute: {
            do {
                if let data = context {
                    self.colorConnection[peerID] = try JSONDecoder().decode([Int].self, from: data)
                }
            } catch {
                print("Eeek")
            }
            self.connected.append(peerID)
        })
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        othersList.append(Other(mcid: peerID))
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        othersList = othersList.filter{ $0.mcid != peerID}
    }
    
    func isEqual(_ object: Any?) -> Bool {
        false
    }
    
    var hash: Int = 0
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func isProxy() -> Bool {
        false
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        false
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        false
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        false
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        false
    }
    
    var description: String = ""
    
    let service = "color-changer"
    var mcPeerID: MCPeerID
    var mcAdvertiser: MCNearbyServiceAdvertiser
    var mcBrowser: MCNearbyServiceBrowser
    var mcSession: MCSession
    @Published var othersList: [Other] = []
    @Published var connected: [MCPeerID] = []
    @Published var numbers: [Int] = [0,1,2,3,4,5,6,7,8,9]
    @Published var colorConnection: [MCPeerID:[Int]] = [MCPeerID(displayName: UIDevice.current.name):[0,1,2,3,4,5,6,7,8,9]]
    
    init() {
        mcPeerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: mcPeerID)
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: nil, serviceType: service)
        mcBrowser = MCNearbyServiceBrowser(peer: mcPeerID, serviceType: service)
        mcSession.delegate = self
        mcAdvertiser.delegate = self
        mcBrowser.delegate = self
        mcBrowser.startBrowsingForPeers()
        mcAdvertiser.startAdvertisingPeer()
    }
    
    func connect(_ id: MCPeerID) {
        do {
            try mcBrowser.invitePeer(id, to: mcSession, withContext: JSONEncoder().encode(numbers), timeout: 4)
        } catch {
            print("Uh oh!")
        }
    }
}
