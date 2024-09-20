
import UIKit
import RealmSwift
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        _ = RealmManager.shared
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "cannot open fileURL")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    // Handle notification presentation while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification as a banner, alert, and play sound
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification response (when user taps on the notification)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification response
        navigateToTask()
        
        completionHandler()
    }
    
    // Hàm điều hướng đến task cụ thể
    func navigateToTask() {
        // Tạo và hiển thị ViewController cho task
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "home") as? ViewController{
            navigationController?.pushViewController(vc, animated: true)
        }         
    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
}



