//
//  BLEManager.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/14.
//

import CoreBluetooth
import SwiftUI
import Combine

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  var centralManager: CBCentralManager!
  @Published var isSwitchedOn = false
  @Published var peripherals = [CBPeripheral]()

  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
    let bleBaseUUIDString = Bundle.main.object(forInfoDictionaryKey: "BLEBaseUUID") as? String ?? ""
    let bleBaseUUID = CBUUID(string: bleBaseUUIDString)
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      isSwitchedOn = true
    } else {
      isSwitchedOn = false
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if !peripherals.contains(peripheral) {
      peripherals.append(peripheral)
    }
  }

  func startScanning() {
    print("Scanning...")
    centralManager.scanForPeripherals(withServices: nil, options: nil)
    print(peripherals)
  }

  func connectPeripheral(peripheral: CBPeripheral) {
    print("Connect peripheral")
    print(peripheral)
    centralManager.stopScan()
    centralManager.connect(peripheral, options: nil)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Enter didConnect")
    // 意外とこれがないとサービスの登録がうまくいかなかった
    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("enter didDiscoverService")
    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    print("enter didDiscoevrCharacteristics")
    print(service)
    guard let characteristics = service.characteristics else { return }
    for characteristic in characteristics {
      if characteristic.properties.contains(.notify) {
        peripheral.setNotifyValue(true, for: characteristic)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    print("enter didUpdateValue")
    if let data = characteristic.value {
      // ここでデータを処理
    }
    print(characteristic)
  }
}

