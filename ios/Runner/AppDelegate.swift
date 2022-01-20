import UIKit
import Flutter
import SwiftCBOR
import SwiftProtobuf
import NodleSDK
import SQLite
import CoreLocation
import CoreBluetooth
import simd
import grpc

//let nodle = Nodle.sharedInstance
private var nodle: Nodle?

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

      let nodleChannel = FlutterMethodChannel(name: "com.carverauto.chaseapp/nodle",
                                              binaryMessenger: controller.binaryMessenger)
      nodleChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          switch call.method {
            case "init":
              nodle = Nodle.sharedInstance
            case "start":
              self?.startNodle(result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func startNodle(result: FlutterResult) {
        nodle?.start(devKey: "ss58:5CYDxNUNrRJU3s6fb1VPhNpNPwyTcFLQuTzmJg5mioBe2eN1", tags: "", "")
    }

}

