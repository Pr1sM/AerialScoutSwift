//
//  FileUploadViewController.swift
//  AerialScoutSwift
//
//  Created by Srinivas Dhanwada on 12/20/15.
//  Copyright © 2015 dhanwada. All rights reserved.
//

import UIKit
import CoreBluetooth

class FileUploadViewController : UIViewController {
    
    private var titleView:TitleView?
    
    @IBOutlet var advertisingSwitch:UISwitch!
    
    private var peripheralManager:CBPeripheralManager?
    private var infoCharacteristic:CBMutableCharacteristic?
    
    private var dataToSend:NSData?
    private var sendDataIndex:Int?
    private var sendingEOM = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        titleView = storyboard.instantiateViewControllerWithIdentifier("TitleView") as? TitleView
        titleView?.matchLabel?.text = ""
        titleView?.view.frame = CGRect(x: 0, y: 0, width: 150, height: 33)
        self.navigationController?.navigationBar.addSubview((titleView?.view)!)
        self.navigationItem.title = ""
        titleView?.view.center = (self.navigationController?.navigationBar.center)!
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleView?.matchLabel?.text = "File Upload"
        advertisingSwitch.on = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        advertisingSwitch.on = false
        peripheralManager?.stopAdvertising()
    }
    
    @IBAction func done(sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func advertise(sender:AnyObject?) {
        if let adSwitch = sender as! UISwitch! {
            
            if(peripheralManager?.state != CBPeripheralManagerState.PoweredOn && adSwitch.on) {
                adSwitch.on = false
                let alertController = UIAlertController(title: "Bluetooth Advertising", message: "Before you can advertise data via bluetooth, you must enable it.  Go to the settings and turn Bluetooth on to start sending data", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            if(adSwitch.on) {
                peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [infoServiceUUID]])
            } else {
                peripheralManager?.stopAdvertising()
            }
        }
    }
    
    private func sendData() {
        if sendingEOM {
            let didSend = peripheralManager?.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: infoCharacteristic!, onSubscribedCentrals: nil)
            
            if didSend == true {
                sendingEOM = false
                
                print("Sent: EOM")
            }
            
            return
        }
        
        if sendDataIndex >= dataToSend?.length {
            return
        }
        
        var didSend = true
        
        while didSend {
            var amountToSend = dataToSend!.length - sendDataIndex!
            
            if(amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU
            }
            
            let chunk = NSData(bytes: dataToSend!.bytes + sendDataIndex!, length: amountToSend)
            
            didSend = (peripheralManager?.updateValue(chunk, forCharacteristic: infoCharacteristic!, onSubscribedCentrals: nil))!
            
            if !didSend {
                return
            }
            
            let stringFromData = NSString(data: chunk, encoding: NSUTF8StringEncoding)
            
            print("Sent: \(stringFromData)")
            
            sendDataIndex! += amountToSend
            
            if(sendDataIndex! >= dataToSend!.length) {
                sendingEOM = true
                
                let eomSent = peripheralManager!.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: infoCharacteristic!, onSubscribedCentrals: nil)
                
                if eomSent {
                    sendingEOM = false
                    print("Sent: EOM")
                }
                
                return
            }
        }
    }
}

extension FileUploadViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if(peripheral.state != .PoweredOn) {
            return
        }
        
        print("self.peripheralManager powered on")
        
        infoCharacteristic = CBMutableCharacteristic(type: infoCharacteristicUUID, properties: .NotifyEncryptionRequired, value: nil, permissions: .ReadEncryptionRequired)
        let infoService = CBMutableService(type: infoServiceUUID, primary: true)
        
        infoService.characteristics = [infoCharacteristic!]
        
        peripheralManager!.addService(infoService)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
        
        let device = "\(UIDevice.currentDevice().name)    \r\n"
        var csvFileString = device
        csvFileString += Match.writeHeader()
        
        for m in MatchStore.sharedStore.allMatches! {
            if let _:Match = m {
                csvFileString += m.writeMatch()
            }
        }
        
        dataToSend = csvFileString.dataUsingEncoding(NSUTF8StringEncoding)
        
        sendDataIndex = 0
        sendData()
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        sendData()
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if let error = error {
            print(error)
        }
    }
}