import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

//     GMSServices.provideAPIKey("AIzaSyAy2tmmHCmR0pej48ZGs6Grhjd-vI34EFg")
    GMSServices.provideAPIKey("AIzaSyDGvpd0TiZ8YtuLWlpZ8ZYzSZEtasSUrEs")
    FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
