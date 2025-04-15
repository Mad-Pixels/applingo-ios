import Foundation
import MultipeerConnectivity

final class NearbySession: NSObject {
    let peerID: MCPeerID
    let session: MCSession

    var onReceiveMessage: ((String) -> Void)?

    init(displayName: String = UIDevice.current.name) {
        self.peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }

    func send(_ string: String) {
        guard !session.connectedPeers.isEmpty,
              let data = string.data(using: .utf8) else { return }

        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension NearbySession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Optionally handle connection changes
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let msg = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.onReceiveMessage?(msg)
            }
        }
    }

    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}
    func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}
    func session(_: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}
}
