//
//  Match.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/22/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import Foundation

class Match : NSObject, NSCoding {
    
    static var maxCycleCount = 0
    
    var teamNumber  : Int?
    var matchNumber : Int?
    var isCompleted : Int?
    var hasViewed   : Int?
    var alliance    : Int?
    
    // Auto
    
    var autoStart   : Int?
    var autoMoved   : Int?
    var autoHotHigh : Int?
    var autoHotLow  : Int?
    var autoHigh    : Int?
    var autoLow     : Int?
    var autoMissed  : Int?
    
    // Teleop - Scoring
    
    var scoreHigh        : Int?
    var scoreLow         : Int?
    var scoreTrussPass   : Int?
    var scoreTrussCatch  : Int?
    var scoreCycles      : Int?
    var scoreAssists     : Int?
    var scoreTeamAssist1 : Int?
    var scoreTeamAssist2 : Int?
    var scoreTeamAssist3 : Int?
    var scoreDrops       : Int?
    var scoreMissedHigh  : Int?
    var scoreMissedTruss : Int?
    
    // Cycle Data
    var cycles : [Int]?
    
    // Teleop - Qualitative
    
    var teleDefenseAbility : Int?
    var teleDriveRole      : Int?
    var teleDriveQuality   : Int?
    var teleTravelSpeed    : Int?
    var telePickupSpeed    : Int?
    var teleInboundSpeed   : Int?
    
    // Final
    
    var finalScore : Int?
    var finalPenaltyScore : Int?
    var finalResult : Int?
    var finalPenalty : Int?
    var finalRobot : Int?
    
    override init() {
        super.init()
        self.setToDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.teamNumber  = aDecoder.decodeIntegerForKey("Match.teamNumber")
        self.matchNumber = aDecoder.decodeIntegerForKey("Match.matchNumber")
        self.isCompleted = aDecoder.decodeIntegerForKey("Match.isCompleted")
        self.hasViewed   = aDecoder.decodeIntegerForKey("Match.hasViewed")
        self.alliance    = aDecoder.decodeIntegerForKey("Match.alliance")
        
        // Auto
        
        self.autoStart   = aDecoder.decodeIntegerForKey("Match.autoStart")
        self.autoMoved   = aDecoder.decodeIntegerForKey("Match.autoMoved")
        self.autoHotHigh = aDecoder.decodeIntegerForKey("Match.autoHotHigh")
        self.autoHotLow  = aDecoder.decodeIntegerForKey("Match.autoHotLow")
        self.autoHigh    = aDecoder.decodeIntegerForKey("Match.autoHigh")
        self.autoLow     = aDecoder.decodeIntegerForKey("Match.autoLow")
        self.autoMissed  = aDecoder.decodeIntegerForKey("Match.autoMissed")
        
        // Teleop - Scoring
        
        self.scoreCycles      = aDecoder.decodeIntegerForKey("Match.scoreCycles")
        self.scoreHigh        = aDecoder.decodeIntegerForKey("Match.scoreHigh")
        self.scoreLow         = aDecoder.decodeIntegerForKey("Match.scoreLow")
        self.scoreTrussCatch  = aDecoder.decodeIntegerForKey("Match.scoreTrussCatch")
        self.scoreTrussPass   = aDecoder.decodeIntegerForKey("Match.scoreTrussPass")
        self.scoreAssists     = aDecoder.decodeIntegerForKey("Match.scoreAssists")
        self.scoreTeamAssist1 = aDecoder.decodeIntegerForKey("Match.scoreTeamAssist1")
        self.scoreTeamAssist2 = aDecoder.decodeIntegerForKey("Match.scoreTeamAssist2")
        self.scoreTeamAssist3 = aDecoder.decodeIntegerForKey("Match.scoreTeamAssist3")
        self.scoreDrops       = aDecoder.decodeIntegerForKey("Match.scoreDrops")
        self.scoreMissedHigh  = aDecoder.decodeIntegerForKey("Match.scoreMissedHigh")
        self.scoreMissedTruss = aDecoder.decodeIntegerForKey("Match.scoreMissedTruss")
        
        // Teleop - Cycle Data
        var count = 0
        let ptr = aDecoder.decodeBytesForKey("Match.cycles", returnedLength: &count)
        let buf = UnsafeBufferPointer<Int>(start: UnsafePointer(ptr), count: count/sizeof(Int))
        self.cycles = Array(buf)
        
        // Teleop - Qualitative
        
        self.teleDefenseAbility = aDecoder.decodeIntegerForKey("Match.teleDefenseAbility")
        self.teleDriveQuality   = aDecoder.decodeIntegerForKey("Match.teleDriveQuality")
        self.teleDriveRole      = aDecoder.decodeIntegerForKey("Match.teleDriveRole")
        self.teleInboundSpeed   = aDecoder.decodeIntegerForKey("Match.teleInboundSpeed")
        self.telePickupSpeed    = aDecoder.decodeIntegerForKey("Match.telePickupSpeed")
        self.teleTravelSpeed    = aDecoder.decodeIntegerForKey("Match.teleTravelSpeed")
        
        // Final
        
        self.finalScore        = aDecoder.decodeIntegerForKey("Match.finalScore")
        self.finalPenaltyScore = aDecoder.decodeIntegerForKey("Match.finalPenaltyScore")
        self.finalResult       = aDecoder.decodeIntegerForKey("Match.finalResult")
        self.finalPenalty      = aDecoder.decodeIntegerForKey("Match.finalPenalty")
        self.finalRobot        = aDecoder.decodeIntegerForKey("Match.finalRobot")
    }
    
    init(withCopy copy:Match) {
        super.init()
        self.teamNumber            = copy.teamNumber;
        self.matchNumber           = copy.matchNumber;
        self.isCompleted           = copy.isCompleted;
        self.hasViewed             = copy.hasViewed;
        self.alliance              = copy.alliance;
        
        // Auto
        
        self.autoStart             = copy.autoStart;
        self.autoMoved             = copy.autoMoved;
        self.autoHotHigh           = copy.autoHotHigh;
        self.autoHotLow            = copy.autoHotLow;
        self.autoHigh              = copy.autoHigh;
        self.autoLow               = copy.autoLow;
        self.autoMissed            = copy.autoMissed;
        
        // Teleop - Scoring
        
        self.scoreCycles           = copy.scoreCycles;
        self.scoreHigh             = copy.scoreHigh;
        self.scoreLow              = copy.scoreLow;
        self.scoreTrussCatch       = copy.scoreTrussCatch;
        self.scoreTrussPass        = copy.scoreTrussPass;
        self.scoreAssists          = copy.scoreAssists;
        self.scoreTeamAssist1      = copy.scoreTeamAssist1;
        self.scoreTeamAssist2      = copy.scoreTeamAssist2;
        self.scoreTeamAssist3      = copy.scoreTeamAssist3;
        self.scoreDrops            = copy.scoreDrops;
        self.scoreMissedHigh       = copy.scoreMissedHigh;
        self.scoreMissedTruss      = copy.scoreMissedTruss;
        
        // Teleop - Cycle Data
        
        self.cycles = copy.cycles
        
        // Teleop - Qualitative
        
        self.teleDefenseAbility    = copy.teleDefenseAbility
        self.teleDriveQuality      = copy.teleDriveQuality
        self.teleDriveRole         = copy.teleDriveRole
        self.teleInboundSpeed      = copy.teleInboundSpeed
        self.telePickupSpeed       = copy.telePickupSpeed
        self.teleTravelSpeed       = copy.teleTravelSpeed
        
        // Final
        
        self.finalScore            = copy.finalScore
        self.finalPenaltyScore     = copy.finalPenaltyScore
        self.finalResult           = copy.finalResult
        self.finalPenalty          = copy.finalPenalty
        self.finalRobot            = copy.finalRobot
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(teamNumber!,  forKey: "Match.teamNumber")
        aCoder.encodeInteger(matchNumber!, forKey: "Match.matchNumber")
        aCoder.encodeInteger(isCompleted!, forKey: "Match.isCompleted")
        aCoder.encodeInteger(hasViewed!,   forKey: "Match.hasViewed")
        aCoder.encodeInteger(alliance!,    forKey: "Match.alliance")
        
        // Auto
        
        aCoder.encodeInteger(autoStart!,   forKey: "Match.autoStart")
        aCoder.encodeInteger(autoMoved!,   forKey: "Match.autoMoved")
        aCoder.encodeInteger(autoHotHigh!, forKey: "Match.autoHotHigh")
        aCoder.encodeInteger(autoHotLow!,  forKey: "Match.autoHotLow")
        aCoder.encodeInteger(autoHigh!,    forKey: "Match.autoHigh")
        aCoder.encodeInteger(autoLow!,     forKey: "Match.autoLow")
        aCoder.encodeInteger(autoMissed!,  forKey: "Match.autoMissed")
        
        // Teleop - Scoring
        
        aCoder.encodeInteger(scoreCycles!,      forKey: "Match.scoreCycles")
        aCoder.encodeInteger(scoreHigh!,        forKey: "Match.scoreHigh")
        aCoder.encodeInteger(scoreLow!,         forKey: "Match.scoreLow")
        aCoder.encodeInteger(scoreTrussCatch!,  forKey: "Match.scoreTrussCatch")
        aCoder.encodeInteger(scoreTrussPass!,   forKey: "Match.scoreTrussPass")
        aCoder.encodeInteger(scoreAssists!,     forKey: "Match.scoreAssists")
        aCoder.encodeInteger(scoreTeamAssist1!, forKey: "Match.scoreTeamAssist1")
        aCoder.encodeInteger(scoreTeamAssist2!, forKey: "Match.scoreTeamAssist2")
        aCoder.encodeInteger(scoreTeamAssist3!, forKey: "Match.scoreTeamAssist3")
        aCoder.encodeInteger(scoreDrops!,       forKey: "Match.scoreDrops")
        aCoder.encodeInteger(scoreMissedHigh!,  forKey: "Match.scoreMissedHigh")
        aCoder.encodeInteger(scoreMissedTruss!, forKey: "Match.scoreMissedTruss")
        
        // Teleop - Cycle Data
        
        aCoder.encodeBytes(UnsafePointer(cycles!), length: cycles!.count * sizeof(Int), forKey: "Match.cycles")
        
        // Teleop - Qualitative
        
        aCoder.encodeInteger(teleDefenseAbility!, forKey: "Match.teleDefenseAbility")
        aCoder.encodeInteger(teleDriveQuality!,   forKey: "Match.teleDriveQuality")
        aCoder.encodeInteger(teleDriveRole!,      forKey: "Match.teleDriveRole")
        aCoder.encodeInteger(teleInboundSpeed!,   forKey: "Match.teleInboundSpeed")
        aCoder.encodeInteger(telePickupSpeed!,    forKey: "Match.telePickupSpeed")
        aCoder.encodeInteger(teleTravelSpeed!,    forKey: "Match.teleTravelSpeed")
        
        // Final
        
        aCoder.encodeInteger(finalScore!,        forKey: "Match.finalScore")
        aCoder.encodeInteger(finalPenaltyScore!, forKey: "Match.finalPenaltyScore")
        aCoder.encodeInteger(finalResult!,       forKey: "Match.finalResult")
        aCoder.encodeInteger(finalPenalty!,      forKey: "Match.finalPenalty")
        aCoder.encodeInteger(finalRobot!,        forKey: "Match.finalRobot")
    }
    
    private func setToDefaults() {
        self.teamNumber  = 0
        self.matchNumber = 0
        self.isCompleted = 0
        self.hasViewed   = 0
        self.alliance    = -1
        
        // Auto
        
        self.autoStart   = -1
        self.autoMoved   = -1
        self.autoHotHigh = -1
        self.autoHotLow  = -1
        self.autoHigh    = -1
        self.autoLow     = -1
        self.autoMissed  = -1
        
        // Teleop - Scoring
        
        self.scoreCycles      = 0
        self.scoreHigh        = 0
        self.scoreLow         = 0
        self.scoreTrussCatch  = 0
        self.scoreTrussPass   = 0
        self.scoreAssists     = 0
        self.scoreTeamAssist1 = 0
        self.scoreTeamAssist2 = 0
        self.scoreTeamAssist3 = 0
        self.scoreDrops       = 0
        self.scoreMissedHigh  = 0
        self.scoreMissedTruss = 0
        
        // Teleop - Cycle Data
        
        self.cycles = [Int]()
        
        // Teleop - Qualitative
        
        self.teleDefenseAbility = 0
        self.teleDriveQuality   = 0
        self.teleDriveRole      = 0
        self.teleInboundSpeed   = 0
        self.telePickupSpeed    = 0
        self.teleTravelSpeed    = 0
        
        // Final
        
        self.finalScore        = -1
        self.finalPenaltyScore = -1
        self.finalResult       = -1
        self.finalPenalty      = 0
        self.finalRobot        = 0
    }
    
    static func writeHeader() -> String {
        let match:String = "Team, Match, isCompleted, Start Position, Auto Moved, Auto Hot High, Auto How Low, Auto High, Auto Low, Auto Missed, Cycles, 1 Assist, 2 Assist, 3 Assist, Truss Pass, Truss Catch, High Goal, Low Goal, Ball Drops, High Missed, Truss Missed, Drive Quality, Travel Speed, Defense Ability, Pickup Speed, Inbound Speed, Final Score, Penalty Score, Result, Penalty, Robot"
        var cycles:String = ""
        for var i = 1; i <= Match.maxCycleCount; ++i {
            cycles += ", Cycle\(i)"
        }
        
        return match + cycles + "    \r\n"
    }
    
    func writeMatch() -> String {
        let match:String = "\(self.teamNumber), "       + "\(self.matchNumber), "        +
                           "\(self.isCompleted), "      + "\(self.autoStart), "          +
                           "\(self.autoMoved), "        + "\(self.autoHotHigh), "        +
                           "\(self.autoHotLow), "       + "\(self.autoHigh), "           +
                           "\(self.autoLow), "          + "\(self.autoMissed), "         +
                           "\(self.scoreCycles), "      + "\(self.scoreTeamAssist1), "   +
                           "\(self.scoreTeamAssist2), " + "\(self.scoreTeamAssist3), "   +
                           "\(self.scoreTrussPass), "   + "\(self.scoreTrussCatch), "    +
                           "\(self.scoreHigh), "        + "\(self.scoreLow), "           +
                           "\(self.scoreDrops), "       + "\(self.scoreMissedHigh), "    +
                           "\(self.scoreMissedTruss), " + "\(self.teleDriveQuality), "   +
                           "\(self.teleTravelSpeed), "  + "\(self.teleDefenseAbility), " +
                           "\(self.telePickupSpeed), "  + "\(self.teleInboundSpeed), "   +
                           "\(self.finalScore), "       + "\(self.finalPenaltyScore), "  +
                           "\(self.finalResult), "      + "\(self.finalPenalty), "       +
                           "\(self.finalRobot)"
        var cycles:String = ""
        for var i = 0; i < self.cycles?.count; ++i {
            cycles += ", \(self.cycles?[i])"
        }
        return match + cycles + "    \r\n"
    }
}
