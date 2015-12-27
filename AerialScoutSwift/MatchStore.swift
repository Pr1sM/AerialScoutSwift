//
//  MatchStore.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/24/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import Foundation
import UIKit

class MatchStore : NSObject {
    
    static let sharedStore:MatchStore = MatchStore()
    
    var allMatches:[Match]?
    
    override init() {
        super.init()
        
        allMatches = NSKeyedUnarchiver.unarchiveObjectWithFile(self.matchArchivePath()) as? [Match]
        
        if allMatches == nil {
            allMatches = [Match]()
        }
    }
    
    func createMatch() -> Match {
        let newMatch:Match = Match()
        allMatches?.append(newMatch)
        return newMatch
    }
    
    func csvFilePath() -> String {
        let documentFolder = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentFolder.stringByAppendingString("Match data - \(UIDevice.currentDevice().name).csv")
    }
    
    func matchArchivePath() -> String {
        let documentFolder = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentFolder.stringByAppendingString("Match.archive")
    }
    
    func removeMatch(thisMatch:Match) {
        for var i = 0; i < allMatches?.count; ++i {
            if let m:Match = allMatches?[i] {
                if m === thisMatch {
                    allMatches?.removeAtIndex(i)
                    break
                }
            }
        }
        self.saveChanges()
    }
    
    func replaceMatch(oldMatch:Match, withNewMatch newMatch:Match) {
        let index:Int? = allMatches?.indexOf(oldMatch)
        if index != nil {
            allMatches![index!] = newMatch
        }
    }
    
    func writeCSVFile() -> Bool {
        let device = "\(UIDevice.currentDevice().name)    \r\n"
        var csvFileString = device
        csvFileString += Match.writeHeader()
        
        for m in allMatches! {
            if let _:Match = m {
                if m.isCompleted == 31 {
                    csvFileString += m.writeMatch()
                }
            }
        }
        
        do {
            try csvFileString.writeToFile(self.csvFilePath(), atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            return false
        }
        
        return true
    }
    
    func saveChanges() -> Bool {
        if !self.writeCSVFile() {
            return false
        }
        
        let path = self.matchArchivePath()
        
        return NSKeyedArchiver.archiveRootObject(allMatches!, toFile: path)
    }
}