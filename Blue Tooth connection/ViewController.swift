//
//  ViewController.swift
//  Blue Tooth connection
//
//  Created by Jake Naughton on 13/03/2017.
//  Copyright © 2017 Jake Naughton. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager : CBCentralManager!
    var peripheral : CBPeripheral!
    let simbleeUuidConnect : CBUUID = CBUUID(string: "FE84")
    let simbleeUuidReceive : CBUUID = CBUUID(string: "2D30C082-F39F-4CE6-923F-3484EA480596")
    let simbleeUuidSend : CBUUID = CBUUID(string: "2D30C083-F39F-4CE6-923F-3484EA480596")
    let simbleeUuidDisconnect : CBUUID = CBUUID(string: "2D30C084-F39F-4CE6-923F-3484EA480596")
    
    let fuckYouOli = [CBUUID(string: "FE84")]

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil) // self refers to class: viewcontroller
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        // Here we check if the phone bluetooth is turned on. (poweredON = Bluetooth on in phone settings.)
        if central.state == CBManagerState.poweredOn {
            
            // Scan for bluetooth device (Must use nil, nil.)
            central.scanForPeripherals(withServices: fuckYouOli, options: nil)
            print("HERE")
        } else {
            print("Bluetooth not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Ballsack")
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
        
        // If the device is "Simblee" assign it to our peripheral.
        if device?.contains("Simblee") == true {
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            print(peripheral.identifier)
            print(RSSI)
            print(device ?? "")
            print(advertisementData)
            
            if let services = peripheral.services {
                for service in services {
                    print("service: ")
                    print(service)
                }
            } else {
                print("what the fuck?")
            }
            
            manager.connect(peripheral, options: nil)
        }
    }
    
    private func centralManager (central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        

    }
    
    
    // ????
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("1")
        peripheral.discoverServices(nil)
    }
    
    // ????
    private func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("2")
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == simbleeUuidConnect {
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    // ???
    private func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("3")
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == simbleeUuidReceive {
                self.peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
}

