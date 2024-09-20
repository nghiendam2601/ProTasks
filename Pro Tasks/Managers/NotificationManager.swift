

import Foundation
import UserNotifications

class NotificationManager{
    static let shared = NotificationManager()
    private var center:UNUserNotificationCenter
    private init(){
        center = UNUserNotificationCenter.current()
    }
    func AddNotification(newid: String, title titleTextField: String, note textView:String, dueDate dateAndTime: Date){
        //MARK: - Add Notification
        let content = UNMutableNotificationContent()
        content.title = titleTextField
        content.body = textView
        content.sound = UNNotificationSound.default
        
        // Thêm dữ liệu tùy chỉnh vào thông báo
        let userInfo = ["taskID": newid]
        content.userInfo = userInfo
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateAndTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: newid, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }else{
                print("remind success!")
            }
        }
        
    }
    func removeNotification(id: String){
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    func updateNotification(id: String, title titleTextField: String, note textView:String, dueDate dateAndTime: Date){
        removeNotification(id: id)
        AddNotification(newid: id, title: titleTextField, note: textView, dueDate: dateAndTime)
    }
}
