import Foundation
import MultipeerConnectivity

final class NearbyService: NSObject, ObservableObject {
    private let serviceType = "applingonearby"

    private let session: NearbySession
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!

    @Published var receivedMessage: String?

    override init() {
        self.session = NearbySession()
        super.init()

        session.onReceiveMessage = { [weak self] msg in
            self?.receivedMessage = msg
        }

        advertiser = MCNearbyServiceAdvertiser(peer: session.peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

        browser = MCNearbyServiceBrowser(peer: session.peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
    }

    func sendHello() {
        session.send("hello")
    }
}

extension NearbyService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext _: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session.session)
    }
}

extension NearbyService: MCNearbyServiceBrowserDelegate {
    func browser(_: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo _: [String: String]?) {
        browser.invitePeer(peerID, to: session.session, withContext: nil, timeout: 10)
    }

    func browser(_: MCNearbyServiceBrowser, lostPeer _: MCPeerID) {}
}
