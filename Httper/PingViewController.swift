//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class PingViewController: UIViewController, SimplePingDelegate, UITableViewDataSource, UITableViewDelegate {

    let hostName = "www.apple.com"
    
    var pinger: SimplePing?
    var sendTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - SimplePingDelegate
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        NSLog("pinging %@", hostName)
        
        // Send the first ping straight away.
        
        self.sendPing()
        
        // And start a timer to send the subsequent pings.
        
        assert(self.sendTimer == nil)
        
        self.sendTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(sendPing),
                                              userInfo: nil,
                                              repeats: true)
    }

    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        NSLog("failed: ")
        
        self.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
         NSLog("#%u sent", sequenceNumber)
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        NSLog("#%u send failed: ", sequenceNumber)
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        NSLog("#%u received, size=%zu", sequenceNumber, packet.count)
    }

    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        NSLog("unexpected packet, size=%zu", packet.count)
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        return cell
    }
    
    // MARK: - Action
    @IBAction func startPing(_ sender: Any) {
        self.start(forceIPv4: false, forceIPv6: false)
    }
    
    
    func start(forceIPv4: Bool, forceIPv6: Bool) {
        self.pingerWillStart()
        
        NSLog("start")
        
        let pinger = SimplePing(hostName: self.hostName)
        self.pinger = pinger
        
        // By default we use the first IP address we get back from host resolution (.Any)
        // but these flags let the user override that.
        
        if (forceIPv4 && !forceIPv6) {
            pinger.addressStyle = .icmPv4
        } else if (forceIPv6 && !forceIPv4) {
            pinger.addressStyle = .icmPv6
        }
        
        pinger.delegate = self
        pinger.start()
    }
    
    /// Called by the table view selection delegate callback to stop the ping.
    
    func stop() {
        NSLog("stop")
        self.pinger?.stop()
        self.pinger = nil
        
        self.sendTimer?.invalidate()
        self.sendTimer = nil
        
        self.pingerDidStop()
    }
    
    func sendPing() {
        self.pinger!.send(with: nil)
    }
    
    func pingerWillStart() {
        print("Start…")
    }
    
    func pingerDidStop() {
        print("Stop…")
    }
}
