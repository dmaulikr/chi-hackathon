//
//  GameCenterManager.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class GameCenterManager: NSObject {
    
    static let sharedInstance = GameCenterManager()
    static let PresentAuthenticationViewController = "PresentAuthenticationViewController"
    static let Authenticated = "Authenticated"
    
    var enabled = false
    var authVC: UIViewController?
    
    var matchStarted = false
    var match: GKMatch?
    
    var players: [GKPlayer]?
    var playersRandomNumbers = Dictionary<String, UInt32>()
    var playerAssignments = Array<String>()
    
    var playerAssignment:String?
    var runner1Assignment: String?
    var runner2Assignment: String?
    
    var gameVC: GameViewController?
    var gameScene: GameScene?
    
    var navVC: UINavigationController? {
        get {
            if let navVC = UIApplication.shared.windows[0].rootViewController as? UINavigationController {
                return navVC
            }
            else {
                return nil
            }
        }
    }
    
    // MARK: Auth
    func authenticateLocalPlayer() {
        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) in
            self.enabled = false
            
            if error != nil {
                let alertVC = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.navVC?.present(alertVC, animated: true, completion: nil)
            }
            else if viewController != nil {
                self.authVC = viewController
                NotificationCenter.default.post(name: NSNotification.Name(GameCenterManager.PresentAuthenticationViewController), object: self)
            }
            else if GKLocalPlayer.localPlayer().isAuthenticated {
                self.enabled = true
                NotificationCenter.default.post(name: NSNotification.Name(GameCenterManager.Authenticated), object: self)
                
                self.findMatch(minPlayers: 2, maxPlayers: 4)
            }
        }
    }
    
    // MARK: Matchmaking
    func findMatch(minPlayers: Int, maxPlayers: Int) {
        if enabled {
            matchStarted = false
            match = nil
            
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = minPlayers
            matchRequest.maxPlayers = maxPlayers
            
            let matchVC = GKMatchmakerViewController(matchRequest: matchRequest)
            matchVC!.matchmakerDelegate = self
            
            navVC?.present(matchVC!, animated: true, completion: nil)
        }
    }
    
    func startMatch() {
        if !matchStarted && match != nil && match!.expectedPlayerCount == 0 {
            print("Ready to start match!")
            getOtherPlayers()
        }
    }
    
    func endMatch() {
        matchStarted = false
        // TODO - end match
    }
    
    // MARK: Player Assignment
    func getOtherPlayers() {
        print("Looking up players...")
        
        GKPlayer.loadPlayers(forIdentifiers: match!.playerIDs) { players, error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                self.navVC?.present(alertVC, animated: true, completion: nil)
            }
            else if players != nil {
                for player in players! {
                    print("Found player: \(player.alias) - \(player.playerID)")
                }
                self.players = players
                
                self.sendRandomNumberForAssignment()
            }
        }
    }
    
    func sendRandomNumberForAssignment() {
        let randomNumber = arc4random()
        if let localPlayerID = GKLocalPlayer.localPlayer().playerID {
            playersRandomNumbers[localPlayerID] = randomNumber
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: playersRandomNumbers)
        sendData(data: data)
    }
    
    func assignPlayers() {
        print("Assigning players...")
        
        let randomNumbers = playersRandomNumbers.values
        let sortedNumbers = randomNumbers.sorted()
        
        var index = 0
        for number in sortedNumbers {
            for playerRandomNumber in playersRandomNumbers {
                if playerRandomNumber.value == number {
                    playerAssignments.append(playerRandomNumber.key)
                }
            }
            
            index += 1
        }
        
        print("Starting game...")
        gameVC?.presentGameScene()
    }
    
    // MARK: Send Data
    func sendData(data: Data) {
        do {
            try match!.sendData(toAllPlayers: data, with: .reliable)
        }
        catch {
            print("Error sending data: \(error.localizedDescription)")
            endMatch()
        }
    }
    
    func sendDataFast(data: Data) {
        do {
            try match!.sendData(toAllPlayers: data, with: .unreliable)
        }
        catch {
            print("Error sending data: \(error.localizedDescription)")
            //endMatch()
        }
    }
    
}

extension GameCenterManager: GKMatchmakerViewControllerDelegate {
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        navVC?.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        navVC?.dismiss(animated: true, completion: nil)

        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        
        navVC?.present(alertVC, animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        navVC?.dismiss(animated: true, completion: nil)

        self.match = match
        self.match!.delegate = self
        
        startMatch()
    }
    
}

extension GameCenterManager: GKMatchDelegate {
    
    func match(_ match: GKMatch, didReceive data: Data, forRecipient recipient: GKPlayer, fromRemotePlayer player: GKPlayer) {
        if match != self.match {
            return
        }
        
        if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary<String, UInt32> {
            if let playerID = player.playerID {
                playersRandomNumbers[playerID] = dictionary[playerID]
                
                // TODO - fix nil crash
                if players != nil {
                    if playersRandomNumbers.count == players!.count + 1 {
                        assignPlayers()
                    }
                }
            }
        }
        else if let message = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
            checkForJumpMessage(message: message)
            checkForJumpBoostMessage(message: message)
            checkForSpeedBoostMessage(message: message)
            //checkForRespawnMessage(message: message)
        }
    }
    
    private func checkForJumpMessage(message: String) {
        if (message.range(of: "runner1DidJump") != nil) {
            if let force = Double(message.components(separatedBy: ":").last!) {
                gameScene?.runner1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat(force)))
            }
        }
        else if (message.range(of: "runner2DidJump") != nil) {
            if let force = Double(message.components(separatedBy: ":").last!) {
                gameScene?.runner2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat(force)))
            }
        }
        else if (message.range(of: "runner3DidJump") != nil) {
            if let force = Double(message.components(separatedBy: ":").last!) {
                gameScene?.runner2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat(force)))
            }
        }
        else if (message.range(of: "runner3DidJump") != nil) {
            if let force = Double(message.components(separatedBy: ":").last!) {
                gameScene?.runner2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat(force)))
            }
        }
    }
    
    private func checkForJumpBoostMessage(message: String) {
        if message == "runner1DidUseJumpBoost" {
            gameScene?.runner1.applyJumpBoost()
        }
        else if message == "runner2DidUseJumpBoost" {
            gameScene?.runner2.applyJumpBoost()
        }
        else if message == "runner3DidUseJumpBoost" {
            gameScene?.runner3.applyJumpBoost()
        }
        else if message == "runner4DidUseJumpBoost" {
            gameScene?.runner4.applyJumpBoost()
        }
    }
    
    private func checkForSpeedBoostMessage(message: String) {
        if message == "runner1DidUseSpeedBoost" {
            gameScene?.runner1.applySpeedBoost()
        }
        else if message == "runner2DidUseSpeedBoost" {
            gameScene?.runner2.applySpeedBoost()
        }
        else if message == "runner3DidUseSpeedBoost" {
            gameScene?.runner3.applySpeedBoost()
        }
        else if message == "runner4DidUseSpeedBoost" {
            gameScene?.runner4.applySpeedBoost()
        }
    }
    
    private func checkForRespawnMessage(message: String) {
        if (message.range(of: "runner1DidRespawn") != nil) {
            if let positionString = message.components(separatedBy: ":").last {
                let position = CGPointFromString(positionString)
                gameScene?.runner1.respawn()
                gameScene?.runner1.position = position
            }
        }
        else if (message.range(of: "runner2DidRespawn") != nil) {
            if let positionString = message.components(separatedBy: ":").last {
                let position = CGPointFromString(positionString)
                gameScene?.runner2.respawn()
                gameScene?.runner2.position = position
            }
        }
        else if (message.range(of: "runner3DidRespawn") != nil) {
            if let positionString = message.components(separatedBy: ":").last {
                let position = CGPointFromString(positionString)
                gameScene?.runner3.respawn()
                gameScene?.runner3.position = position
            }
        }
        else if (message.range(of: "runner4DidRespawn") != nil) {
            if let positionString = message.components(separatedBy: ":").last {
                let position = CGPointFromString(positionString)
                gameScene?.runner4.respawn()
                gameScene?.runner4.position = position
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if match != self.match {
            return
        }
        
        switch state {
        case .stateConnected:
            print("Player connected!")
            startMatch()
        case .stateDisconnected:
            print("Player disconnected!")
            endMatch()
        case .stateUnknown:
            print("Player disconnected!")
            endMatch()
        }
    }

    func match(_ match: GKMatch, didFailWithError error: Error?) {
        if match != self.match {
            return
        }
        
        print("Failed to connect to player with error: \(error?.localizedDescription)")
        endMatch()
    }
    
}
