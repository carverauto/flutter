import UIKit
import Flutter
import GoogleCast
import Network
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, GCKLoggerDelegate{
  // Cast Code
  let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
  let kDebugLoggingEnabled = true
  // End Cast Code

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     // Cast Code
    GeneratedPluginRegistrant.register(with: self)
    let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
    let options = GCKCastOptions(discoveryCriteria: criteria)
    GCKCastContext.setSharedInstanceWith(options)
    GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
    GCKLogger.sharedInstance().delegate = self 
    // End Cast Code 
    // GeneratedPluginRegistrant.register(with: self)
    //For LNA channel
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    let channel = FlutterMethodChannel(name: "local_network_authorization", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
            case "requestLocalNetworkAuthorization":
                self?.requestLocalNetworkAuthorization(completion: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
    // End LNA channel

    //For airplay paltform view

    weak var registrar = self.registrar(forPlugin: "airplay_view_plugin")

    let factory = AirPlayViewFactory(messenger: registrar!.messenger())
    registrar!.register(
            factory,
            withId: "aiplay_view")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      

  }

  private func requestLocalNetworkAuthorization(completion: @escaping FlutterResult) {
    // Create parameters, and allow browsing over peer-to-peer link.
        // Create a LocalNetworkAuthorization instance.
    let localNetworkAuthorization = LocalNetworkAuthorization()
    
    // Request local network authorization using the instance.
    localNetworkAuthorization.requestAuthorization(completion: completion)
  }
    
    // private func startNodle(result: FlutterResult) {
    //     nodle?.start(devKey: "ss58:5CYDxNUNrRJU3s6fb1VPhNpNPwyTcFLQuTzmJg5mioBe2eN1", tags: "", "")
    // }

}


// Call check
@available(iOS 14.0, *)
public class LocalNetworkAuthorization: NSObject {
    private var browser: NWBrowser?
    private var netService: NetService?
    private var completion: ((Bool) -> Void)?
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        print("Called requestAuthorization");
        self.completion = completion
        
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        // Browse for a custom service type.
        let browser = NWBrowser(for: .bonjour(type: "_bonjour._tcp", domain: nil), using: parameters)
        print("Browsing for service type")
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                print(error.localizedDescription)
            case .ready, .cancelled:
                break
            case let .waiting(error):
                print("Local network permission has been denied: \(error)")
                self.reset()
                self.completion?(false)
            default:
                break
            }
        }
         print("Starting NetService")
        self.netService = NetService(domain: "local.", type:"_lnp._tcp.", name: "LocalNetworkPrivacy", port: 1100)
        self.netService?.delegate = self
        
        self.browser?.start(queue: .main)
        self.netService?.publish()
        print("NetService Published")
    }
    
    private func reset() {
        self.browser?.cancel()
        self.browser = nil
        self.netService?.stop()
        self.netService = nil
    }
}

@available(iOS 14.0, *)
extension LocalNetworkAuthorization : NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        self.reset()
        print("Local network permission has been granted")
        completion?(true)
    }
}


//aireplay view

 class AirPlayViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return AirPlayView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

 class AirPlayView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        var buttonView: UIView? = nil
    let buttonFrame = CGRect(x: 0, y: 0, width: 44, height: 44)

    // It's highly recommended to use the AVRoutePickerView in order to avoid AirPlay issues after iOS 11.
    if #available(iOS 11.0, *) {
        let airplayButton = AVRoutePickerView(frame: buttonFrame)
        airplayButton.activeTintColor = UIColor.blue
        airplayButton.tintColor = UIColor.gray
        buttonView = airplayButton
    } 

    // If there are no AirPlay devices available, the button will not be displayed.
    let buttonItem = UIBarButtonItem(customView: buttonView!)
    // let viewController = UIViewController()
    // viewController.navigationItem.setRightBarButton(buttonItem, animated: true)
//     _view.backgroundColor = UIColor.blue
//         let nativeLabel = UILabel()
//         nativeLabel.text = "Native text from iOS"
//         nativeLabel.textColor = UIColor.white
//         nativeLabel.textAlignment = .center
//         nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
//   _view.addSubview(nativeLabel)
    // Return the view controller's view.
    _view.addSubview(buttonView!)
    }
}
