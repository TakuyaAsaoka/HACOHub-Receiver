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
  @Published var isSwitchedOn = false
  @Published var peripherals = [CBPeripheral]()
  var centralManager: CBCentralManager!
  var bleBaseUUID: CBUUID?
  var data: Data = Data()

  override init() {
    super.init()

    #if targetEnvironment(simulator)
    print("⚠️ Running on simulator — BLE not initialized")
    #else
    centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    if let bleBaseUUIDString = Bundle.main.object(forInfoDictionaryKey: "BLEBaseUUID") as? String {
      bleBaseUUID = CBUUID(string: bleBaseUUIDString)
    }
    #endif
  }



  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      isSwitchedOn = true
    } else {
      isSwitchedOn = false
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    guard RSSI.intValue >= -50 else {
      print("データ転送に十分な信号強度がないので接続できません。")
      return
    }

    if !peripherals.contains(peripheral) {
      peripherals.append(peripheral)
    }
  }

  // TODO: 会場だと違う機器に繋いでしまうかも。ある程度指定しておきたい。
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
    // TODO: 会場だと違う機器に繋いでしまうかも。ある程度指定しておきたい。
    peripheral.discoverServices(nil)
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("enter didDiscoverService")
    guard let services = peripheral.services else { return }
    for service in services {
      if let bleBaseUUID = bleBaseUUID {
        centralManager.scanForPeripherals(withServices: [bleBaseUUID], options: nil)
      } else {
        print("BLE Base UUIDが設定されていません")
      }
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

    if let error = error {
      print("Error discovering characteristics: \(error.localizedDescription)")
//      cleanup()
      return
    }

    guard let characteristicData = characteristic.value,
          let stringFromData = String(data: characteristicData, encoding: .utf8) else {
      return
    }

    print("Received \(characteristicData.count) bytes: \(stringFromData)")

    if stringFromData == "EOM" {
//      message = String(data: data, encoding: .utf8) ?? ""
//      writeData()
    } else {
      data.append(characteristicData)
    }
    print(characteristic)
  }
}

