//
//  PlayFanfare.swift
//  HACOHub-Receiver
//
//  Created by TakuyaAsaoka on 2025/10/28.
//

import AVFoundation

private var audioPlayer: AVAudioPlayer?

func playFanfare() {
	DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
		guard let url = Bundle.main.url(forResource: "fanfare", withExtension: "m4a") else {
				print("fanfare.m4a が見つかりません")
				return
		}

		do {
				audioPlayer = try AVAudioPlayer(contentsOf: url)
				audioPlayer?.prepareToPlay()
				audioPlayer?.play()
				print("🎵 fanfare 再生開始")
		} catch {
				print("音声の再生に失敗しました: \(error.localizedDescription)")
		}
	}
}
