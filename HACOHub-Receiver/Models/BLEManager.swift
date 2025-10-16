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
  @Published var weekPeripheralInfos = [PeripheralInfo]()
  @Published var peripheralInfos = [PeripheralInfo]()
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

  // TODO: 会場だと違う機器に繋いでしまうかも。ある程度指定しておきたい。
  func startScanning() {
    print("BLEスキャンを開始")
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }

  // スキャン中、BLEデバイスを見つけるごとに呼ばれる関数
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    let deviceName = peripheral.name ?? "名前なしデバイス"
    let uuidString = peripheral.identifier.uuidString
    let peripheral = PeripheralInfo(peripheral: peripheral, rssi: RSSI)

    if RSSI.intValue >= -50 {
      if !peripheralInfos.contains(where: { $0.id == peripheral.peripheral.identifier }) {
        print("BLEデバイスNo: \(peripheralInfos.count)")
        print("接続可能: \(deviceName), UUID: \(uuidString), RSSI: \(RSSI)")
        peripheralInfos.append(peripheral)
      }
    } else {
      if !weekPeripheralInfos.contains(where: { $0.id == peripheral.peripheral.identifier }) {
        print("BLEデバイスNo: \(weekPeripheralInfos.count)")
        print("接続不可（信号弱）: \(deviceName), UUID: \(uuidString), RSSI: \(RSSI)")
        weekPeripheralInfos.append(peripheral)
      }
    }
  }

  func connectPeripheral(peripheral: CBPeripheral) {
    print("Connect peripheral")
    print(peripheral)
    centralManager.stopScan()
    centralManager.connect(peripheral, options: nil)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("✅ 接続成功: \(peripheral.name ?? "名前なし"), UUID: \(peripheral.identifier.uuidString)")
    if let index = peripheralInfos.firstIndex(where: { $0.peripheral == peripheral }) {
      peripheralInfos[index].isConnected = true
    }
    // 意外とこれがないとサービスの登録がうまくいかなかった
    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }

  // 接続失敗時に呼ばれる
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    print("❌ 接続失敗: \(peripheral.name ?? "名前なし"), UUID: \(peripheral.identifier.uuidString), error: \(error?.localizedDescription ?? "なし")")
  }

  // Service探索完了後に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("enter didDiscoverService")
    print("peripheral.services.count: \(peripheral.services?.count ?? 0)")
    guard let services = peripheral.services else { return }

    guard let settingServiceUUID = uuidWithAlias(alias: 0x0100) else { return }
    guard let deviceNumberUUID = uuidWithAlias(alias: 0x0101) else { return }

    for service in services {
      print("service: \(service)")
      if service.uuid == settingServiceUUID {
        print("Setting Service を発見")
        peripheral.discoverCharacteristics([deviceNumberUUID], for: service)
      } else {
        print("BLE Base UUIDが設定されていません")
      }
    }
  }

  // Characteristic探索完了後に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    print("enter didDiscoevrCharacteristics")
    print(service)
    guard let characteristics = service.characteristics else { return }

    let deviceNumberUUID = uuidWithAlias(alias: 0x0101)

    for characteristic in characteristics {
      if characteristic.uuid == deviceNumberUUID {
        print("DEVICE_NUMBER キャラクタリスティックを発見")

        // 送信データを作成（8文字以下を0x00埋め）
        let name = "HACOHub1" // デバイス名
        var data = name.data(using: .utf8) ?? Data()
        if data.count < 8 {
          data.append(contentsOf: Array(repeating: 0x00, count: 8 - data.count))
        }

        // 書き込み
        peripheral.writeValue(data, for: characteristic, type: .withResponse)

        // 読み込み
        peripheral.readValue(for: characteristic)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("読み取りエラー: \(error.localizedDescription)")
      return
    }

    guard let data = characteristic.value else { return }

    // データを文字列に変換（UTF-8の場合）
    if let stringValue = String(data: data, encoding: .utf8) {
      print("読み取り成功: \(stringValue)")
    } else {
      print("読み取り成功、バイナリ: \(data)")
    }
  }

  // 切断時に呼ばれる処理
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    if let error = error {
      print("❌ 切断（エラーあり）: \(peripheral.name ?? "Unknown"), UUID: \(peripheral.identifier.uuidString), error: \(error.localizedDescription)")
    } else {
      print("⚠️ 切断（エラーなし）: \(peripheral.name ?? "Unknown"), UUID: \(peripheral.identifier.uuidString)")
    }

    // 状態更新
    if let index = peripheralInfos.firstIndex(where: { $0.peripheral == peripheral }) {
      peripheralInfos[index].isConnected = false
    }
    if let index = weekPeripheralInfos.firstIndex(where: { $0.peripheral == peripheral }) {
      weekPeripheralInfos[index].isConnected = false
    }
  }

  // 書き込み完了
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("書き込み失敗: \(error.localizedDescription)")
    } else {
      print("書き込み成功: \(characteristic.uuid)")
    }
  }
}

