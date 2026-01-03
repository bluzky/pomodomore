//
//  NotificationManager.swift
//  pomodomore
//
//  Created on 01/03/26.
//

import Foundation
import UserNotifications

/// Manages macOS user notifications for timer completion
final class NotificationManager: NSObject {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        center.delegate = self
    }

    /// Request notification permission on first launch
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("⚠️ Notification permission denied")
            }
            return granted
        } catch {
            print("❌ Error requesting notification permission: \(error)")
            return false
        }
    }

    /// Check current permission status
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    /// Show notification when Pomodoro completes
    func showPomodoroComplete(sessionsCompleted: Int, totalInSet: Int) async {
        // Only show notification if timer window is not visible
        guard !WindowManager.shared.isTimerWindowVisible else {
            print("🔔 Notification suppressed: Timer window is visible")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Complete!"
        content.body = "Time for a break. (\(sessionsCompleted) of \(totalInSet) complete)"

        // Use user's selected completion sound from bundled resources
        let sound = SettingsManager.shared.settings.sound.completionSound
        let soundFileName = "\(sound.fileName).\(sound.fileExtension)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(soundFileName))

        await showNotification(content: content)
    }

    /// Show notification when break completes
    func showBreakComplete() async {
        // Only show notification if timer window is not visible
        guard !WindowManager.shared.isTimerWindowVisible else {
            print("🔔 Notification suppressed: Timer window is visible")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Break Complete!"
        content.body = "Ready to start another Pomodoro?"

        // Use user's selected completion sound from bundled resources
        let sound = SettingsManager.shared.settings.sound.completionSound
        let soundFileName = "\(sound.fileName).\(sound.fileExtension)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(soundFileName))

        await showNotification(content: content)
    }

    /// Show notification with custom content
    func showNotification(content: UNMutableNotificationContent) async {
        // Check if notifications are enabled in settings
        guard SettingsManager.shared.settings.sound.notificationsEnabled else {
            print("🔔 Notifications disabled in settings")
            return
        }

        // Check permission before showing
        let status = await checkPermissionStatus()
        guard status == .authorized else {
            print("⚠️ Cannot show notification: permission not granted")
            return
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        do {
            try await center.add(request)
            print("📣 Notification shown: \(content.title)")
        } catch {
            print("❌ Error showing notification: \(error)")
        }
    }

    /// Remove all pending notifications
    func removeAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    /// Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is foreground
        completionHandler([.banner, .sound])
    }

    /// Handle notification when user interacts
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap if needed
        print("👆 Notification tapped: \(response.notification.request.content.title)")
        completionHandler()
    }
}
