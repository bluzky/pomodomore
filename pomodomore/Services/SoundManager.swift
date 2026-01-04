//
//  SoundManager.swift
//  pomodomore
//
//  Created on 01/15/26.
//

import Foundation
import AVFoundation
import AVFAudio
import AppKit
import Combine

#if DEBUG
private let isDebug = true
#else
private let isDebug = false
#endif

/// Manages sound playback for timer notifications
@MainActor
final class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published private(set) var isPlayingTick = false
    @Published private(set) var isPlayingAmbient = false

    private var tickPlayer: AVAudioPlayer?
    private var ambientPlayer: AVAudioPlayer?
    private var lifecyclePlayer: AVAudioPlayer?
    private var previewTask: Task<Void, Never>?

    private init() {
        // No audio session setup needed on macOS
    }

    // MARK: - Tick Sounds (Looping)

    /// Start looping tick sound for Pomodoro
    func startTickLoop(soundName: String) {
        guard soundName != "None" else { return }

        stopTickLoop()

        guard let player = createPlayer(for: soundName, type: .tick) else {
            return
        }

        tickPlayer = player
        player.numberOfLoops = -1 // Loop infinitely
        player.play()
        isPlayingTick = true
        if isDebug { print("🎵 Tick loop started: \(soundName)") }
    }

    /// Stop tick loop
    func stopTickLoop() {
        tickPlayer?.stop()
        tickPlayer = nil
        isPlayingTick = false
        if isDebug { print("🎵 Tick loop stopped") }
    }

    // MARK: - Ambient Sounds (Looping)

    /// Start looping ambient sound
    func startAmbient(_ sound: AmbientSound) {
        guard sound != .none else { return }

        stopAmbient()

        guard let player = createAmbientPlayer(for: sound) else {
            return
        }

        ambientPlayer = player
        player.numberOfLoops = -1 // Loop infinitely
        player.play()
        isPlayingAmbient = true
        if isDebug { print("🎵 Ambient started: \(sound.displayName)") }
    }

    /// Stop ambient sound
    func stopAmbient() {
        ambientPlayer?.stop()
        ambientPlayer = nil
        isPlayingAmbient = false
        if isDebug { print("🎵 Ambient stopped") }
    }

    // MARK: - Lifecycle Sounds (One-shot)

    /// Play start sound
    func playStart() {
        playLifecycleSound(.start)
    }

    /// Play stop/pause/reset sound
    func playStop() {
        playLifecycleSound(.stop)
    }

    private func playLifecycleSound(_ sound: LifecycleSound) {
        // Stop any currently playing lifecycle sound first (memory leak fix)
        lifecyclePlayer?.stop()
        lifecyclePlayer = nil

        guard let player = createLifecyclePlayer(for: sound) else {
            return
        }
        lifecyclePlayer = player
        player.play()
        if isDebug { print("🎵 Lifecycle sound played: \(sound.rawValue)") }
    }

    // MARK: - Completion Sounds (One-shot)

    /// Play completion sound from bundled resources
    func playCompletionSound(_ sound: BundledCompletionSound) {
        // Stop any currently playing lifecycle sound first (memory leak fix)
        lifecyclePlayer?.stop()
        lifecyclePlayer = nil

        guard let player = createCompletionPlayer(for: sound) else {
            return
        }
        lifecyclePlayer = player
        player.play()
        if isDebug { print("🎵 Completion sound played: \(sound.rawValue)") }
    }

    // MARK: - Preview Sounds

    /// Preview a tick sound (cancels any existing preview)
    func previewTickSound(soundName: String) {
        guard soundName != "None" else { return }

        // Cancel any existing preview task
        previewTask?.cancel()
        stopTickLoop()

        guard let player = createPlayer(for: soundName, type: .tick) else {
            return
        }

        tickPlayer = player
        player.numberOfLoops = 2 // Play a few times for preview
        player.play()
        isPlayingTick = true

        // Cancel task after 2 seconds
        previewTask = Task {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            stopTickLoop()
        }
        if isDebug { print("🎵 Tick preview started: \(soundName)") }
    }

    // MARK: - Utility

    /// Stop all looping sounds (tick, ambient) - doesn't stop lifecycle sounds
    func stopLoopingSounds() {
        stopTickLoop()
        stopAmbient()
    }

    /// Stop all sounds including lifecycle sounds
    func stopAll() {
        stopLoopingSounds()
        lifecyclePlayer?.stop()
        lifecyclePlayer = nil
    }

    // MARK: - Private Helpers

    private enum SoundBundleType {
        case tick
        case ambient
    }

    private func createPlayer(for soundName: String, type: SoundBundleType) -> AVAudioPlayer? {
        // Determine resource path
        var resourcePath: String?
        switch type {
        case .tick:
            resourcePath = Bundle.main.path(forResource: "tick \(soundName.replacingOccurrences(of: "Tick ", with: ""))", ofType: "mp3")
        case .ambient:
            return nil
        }

        guard let path = resourcePath else {
            if isDebug { print("⚠️ Sound file not found: \(soundName)") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(soundName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }

    private func createAmbientPlayer(for sound: AmbientSound) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: sound.fileName, ofType: "mp3")

        guard let path = path else {
            if isDebug { print("⚠️ Ambient sound file not found: \(sound.fileName).mp3") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(sound.displayName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }

    private func createLifecyclePlayer(for sound: LifecycleSound) -> AVAudioPlayer? {
        let fileName = sound.rawValue.lowercased() // "start" or "stop"
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            if isDebug { print("⚠️ Lifecycle sound file not found: \(fileName).mp3") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(fileName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }

    private func createCompletionPlayer(for sound: BundledCompletionSound) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: sound.fileName, ofType: sound.fileExtension)

        guard let path = path else {
            if isDebug { print("⚠️ Completion sound file not found: \(sound.fileName).\(sound.fileExtension)") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(sound.fileName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }
}

// MARK: - Available Sound Lists

extension SoundManager {
    /// List of available tick sound names
    static let availableTickSounds: [String] = [
        "None",
        "Tick 1",
        "Tick 2",
        "Tick 3",
        "Tick 4",
        "Tick 5",
        "Tick 6",
        "Tick 7"
    ]

    /// List of available ambient sound names
    static let availableAmbientSounds: [AmbientSound] = AmbientSound.allCases

    /// List of available completion sound options
    static let availableCompletionSounds: [BundledCompletionSound] = BundledCompletionSound.allCases
}
