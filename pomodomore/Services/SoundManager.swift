//
//  SoundManager.swift
//  pomodomore
//
//  Created on 01/15/26.
//

import Foundation
import AVFoundation
import AppKit
import Combine

/// Manages sound playback for timer notifications
@MainActor
final class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published private(set) var isPlaying = false

    private var currentPlayer: NSSound?

    private init() {}

    /// Play a sound of the specified type
    func play(_ type: SoundType) {
        // Stop any currently playing sound
        stop()

        guard let player = NSSound(named: type.systemSoundName) else {
            return
        }

        currentPlayer = player
        player.play()
        isPlaying = true

        // Reset playing state when sound finishes
        DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) { [weak self] in
            self?.isPlaying = false
        }
    }

    /// Stop the currently playing sound
    func stop() {
        currentPlayer?.stop()
        currentPlayer = nil
        isPlaying = false
    }

    /// Test play a sound (for preview in settings)
    func testPlay(_ type: SoundType) {
        play(type)
    }
}
