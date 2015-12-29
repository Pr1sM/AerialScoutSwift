//
//  FileUpload.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/27/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit

class FileUpload: NSObject, NSStreamDelegate {
    private var streamFromFile:NSInputStream?
    private var streamToHost:NSOutputStream?
    
    private var timeoutTimer:NSTimer?
    
    private var writeBuffer:[UInt8] = [UInt8](count: 2048, repeatedValue: 0)
    private var writeBufferOffset:Int = 0
    private var writeBufferLimit:Int = 0
    
    override init() {
        super.init()
    }
    
    func isBusy(state:Bool) {
        let newString:String = (state) ? "YES" : "NO"
        let info = ["Info" : newString]
        let note = NSNotification(name: "FileUpload.Busy", object: self, userInfo: info)
        NSNotificationCenter.defaultCenter().postNotification(note)
    }
    
    func statusUpdate(status:String) {
        let info = ["Info" : status]
        let note = NSNotification(name: "FileUpload.Status", object: self, userInfo: info)
        NSNotificationCenter.defaultCenter().postNotification(note)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch(eventCode) {
        case NSStreamEvent.OpenCompleted:
            print("Opened Connection")
            self.statusUpdate("Connection Opened")
            break
        case NSStreamEvent.HasBytesAvailable:
            print("Not Supposed to Happen")
            
            break
        case NSStreamEvent.HasSpaceAvailable:
            print("Sending")
            self.statusUpdate("Connected")
            
            if self.writeBufferLimit == self.writeBufferOffset {
                var bytesRead:Int
                bytesRead = streamFromFile!.read(UnsafeMutablePointer<UInt8>(self.writeBuffer), maxLength: 2048)
                if bytesRead == -1 {
                    // stop upload and update status
                    self.statusUpdate("File Read Error")
                    self.stopUpload()
                } else if bytesRead == 0 {
                    // stop upload and update status
                    self.statusUpdate("Upload Completed")
                    self.stopUpload()
                } else {
                    self.writeBufferOffset = 0
                    self.writeBufferLimit = bytesRead
                }
            }
            
            if self.writeBufferLimit != self.writeBufferOffset {
                var bytesWritten:Int
                bytesWritten = self.streamToHost!.write(&self.writeBuffer[self.writeBufferOffset], maxLength: self.writeBufferLimit - self.writeBufferOffset)
                if bytesWritten == -1 {
                    // stop upload and update status
                    self.statusUpdate("Network Write Error")
                    self.stopUpload()
                } else {
                    self.writeBufferOffset += bytesWritten
                }
            }
            break
        case NSStreamEvent.ErrorOccurred:
            // stop upload and update status
            self.stopUpload()
            self.statusUpdate("Connection Open Error")
            break
        case NSStreamEvent.EndEncountered:
            print("Ignore")
            break
        default: break
        }
    }
    
    func timeoutExpired(timer:NSTimer) {
        self.statusUpdate("Timeout Expired")
        self.stopUpload()
    }
    
    // Will Remove when using NSURLSession API
    @available(iOS, deprecated=9.0)
    func startUpload(filePath:String, toFtpServer server:String, username:String, passwd:String) {
        self.statusUpdate("Open Connection...")
        self.isBusy(true)
        
        self.timeoutTimer = NSTimer(timeInterval: 10, target: self, selector: "timeoutExpired:", userInfo: nil, repeats: false)
        
        self.streamFromFile = NSInputStream(fileAtPath: filePath)
        self.streamFromFile?.open()
        
        let url = self.urlForString(server)
        
        if(url == nil) {
            self.statusUpdate("Invalid URL")
            self.stopUpload()
            return
        }
        
        streamToHost = CFWriteStreamCreateWithFTPURL(nil, url!).takeUnretainedValue()
        
        streamToHost?.setProperty(username, forKey: kCFStreamPropertyFTPUserName as String)
        streamToHost?.setProperty(passwd, forKey: kCFStreamPropertyFTPPassword as String)
        
        streamToHost?.delegate = self
        streamToHost?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        streamToHost?.open()
    }
    
    func stopUpload() {
        timeoutTimer?.invalidate()
        self.isBusy(false)
        
        if streamToHost != nil {
            streamToHost?.delegate = nil
            streamToHost?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            streamToHost?.close()
            streamToHost = nil
        }
        
        if streamFromFile != nil {
            streamFromFile?.close()
            streamFromFile = nil
        }
        
        timeoutTimer = nil
        writeBufferLimit = 0
        writeBufferOffset = 0
    }
    
    func urlForString(str:String) -> NSURL? {
        var result:NSURL? = nil
        let trimmedStr:String? = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedStr != nil && trimmedStr?.characters.count != 0 {
            if (trimmedStr?.containsString("://") == false) {
                result = NSURL(string: "ftp://\(str)")
            } else if (trimmedStr?.containsString("ftp://") == true) {
                result = NSURL(string: str)
            }
        }
        
        return result!
    }
}
