import UIKit
import Flutter
import UserNotifications
import GoogleMaps
import FirebaseMessaging
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD0HpQe3U7tDlOpS1vrjhFnob0xmmQJQDo")
    UNUserNotificationCenter.current().delegate = self

let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
UNUserNotificationCenter.current().requestAuthorization(
  options: authOptions,
  completionHandler: { _, _ in }
)

   application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
