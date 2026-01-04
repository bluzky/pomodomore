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

        guard let player = createTickPlayer(for: soundName) else {
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
    func startAmbient(_ sound: AmbientSoundItem) {
        guard sound.fileName.isEmpty == false else { return }

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
    func playCompletionSound(_ sound: BundledSound) {
        // Stop any currently playing lifecycle sound first (memory leak fix)
        lifecyclePlayer?.stop()
        lifecyclePlayer = nil

        guard let player = createCompletionPlayer(for: sound) else {
            return
        }
        lifecyclePlayer = player
        player.play()
        if isDebug { print("🎵 Completion sound played: \(sound.name)") }
    }

    // MARK: - Preview Sounds

    /// Preview a tick sound (cancels any existing preview)
    func previewTickSound(soundName: String) {
        guard soundName != "None" else { return }

        // Cancel any existing preview task
        previewTask?.cancel()
        stopTickLoop()

        guard let player = createTickPlayer(for: soundName) else {
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

    private func createTickPlayer(for soundName: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3", inDirectory: "Sounds/ticks") else {
            if isDebug { print("⚠️ Tick sound file not found: Sounds/ticks/\(soundName).mp3") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(soundName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }

    private func createAmbientPlayer(for sound: AmbientSoundItem) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: sound.fileName, ofType: "mp3", inDirectory: "Sounds/ambient") else {
            if isDebug { print("⚠️ Ambient sound file not found: Sounds/ambient/\(sound.fileName).mp3") }
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
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp3", inDirectory: "Sounds") else {
            if isDebug { print("⚠️ Lifecycle sound file not found: Sounds/\(fileName).mp3") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(fileName)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }

    private func createCompletionPlayer(for sound: BundledSound) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: sound.fileName, ofType: sound.fileExtension, inDirectory: "Sounds/notification") else {
            if isDebug { print("⚠️ Completion sound file not found: Sounds/notification/\(sound.fileName).\(sound.fileExtension)") }
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
            if isDebug { print("⚠️ Failed to create audio player for: \(sound.name)") }
            return nil
        }

        player.prepareToPlay()
        return player
    }
}

// MARK: - Available Sound Lists

extension SoundManager {
    /// List of available tick sound names (dynamically loaded)
    static var availableTickSounds: [String] {
        ["None"] + SoundLoader.loadTickSoundNames()
    }

    /// List of available completion sounds (dynamically loaded)
    static var availableCompletionSounds: [BundledSound] {
        SoundLoader.loadCompletionSounds()
    }

    /// List of available ambient sounds (dynamically loaded)
    static var availableAmbientSounds: [AmbientSoundItem] {
        [AmbientSoundItem.none] + SoundLoader.loadAmbientSounds()
    }
}

// MARK: - Lifecycle Sound Enum

enum LifecycleSound: String, Codable {
    case start = "Start"
    case stop = "Stop"
}
