//
//  NotificationManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 01.06.2024.
//

import SwiftUI
import UserNotifications

final class NotificationManager {
    var titleNotifications = ["Claim Your Daily Bonus! 🎁", "Jackpot Alert: Win Big! 🎰", "Double Your Coins! 💰", "New Slot: Mythic Treasures! 🏺", "Weekend Tournament! 🏆", "Free Spins Available! 🌀", "VIP Rewards Await! 🌟", "Mystery Box Event! 🎁", "Invite Friends & Earn! 🎉", "Special Jackpot Frenzy! ⚡️"]
    var descriptionNotifications = ["Log in now for bonus coins. Spin and win big!", "Spin today for a chance to hit the jackpot!", "Limited time offer: Double coins on your next purchase!", "Play Mythic Treasures now and unlock epic prizes!", "Compete this weekend for amazing prizes. Play now!", "Claim your free spins today and win big!", "Check out your VIP rewards now!", "Open your box for a chance at amazing prizes!", "Invite friends and earn big bonuses!", "Join now and increase your chances to win big!"]
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleDailyNotification() -> Void {
        let randomTitle = titleNotifications.randomElement()!
        let randomBody = descriptionNotifications.randomElement()!
        
        let content = UNMutableNotificationContent()
        content.title = randomTitle
        content.body = randomBody
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func timeNotification() -> Void {
        let content = UNMutableNotificationContent()
        content.title = "🤑 You've Got Free Spin Coins! 🤑"
        content.subtitle = "Unlock Your Bonus Spins Now and Win Big!"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() -> Void {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
