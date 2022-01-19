import UIKit
import Flutter
import SwiftCBOR
import SwiftProtobuf
import NodleSDK
import SQLite
import CoreLocation
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let nodle = Nodle.sharedInstance
    Nodle().start("ss58:5CYDxNUNrRJU3s6fb1VPhNpNPwyTcFLQuTzmJg5mioBe2eN1");
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
