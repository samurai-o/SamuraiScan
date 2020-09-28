import Flutter
import UIKit

public class SwiftSamuraiScanPlugin: NSObject, FlutterPlugin {
  private var result: FlutterResult?
  private var registrar: FlutterPluginRegistrar!
  private var hostViewController: UIViewController!

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "samurai_scan", binaryMessenger: registrar.messenger())
    let instance = SwiftSamuraiScanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    if let delegate = UIApplication.shared.delegate, let window = delegate.window, let root = window?.rootViewController {
      instance.hostViewController = root
      instance.registrar = registrar
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "scan") {
      self.result = result
      let scanController = SamuraiScanController()
      scanController.delegate = self
      let navigationController = UINavigationController(rootViewController: scanController)
      navigationController.view.backgroundColor = UIColor.black
      scanController.modalPresentationStyle = .fullScreen
      navigationController.modalPresentationStyle = .fullScreen
      if hostViewController != nil {
          let backIconKey = registrar.lookupKey(forAsset: "assets/back.png", fromPackage: "samurai_scan")
          let flashIconKey = registrar.lookupKey(forAsset: "assets/flash.png", fromPackage: "samurai_scan")
          let cameraIconKey = registrar.lookupKey(forAsset: "assets/camea.png", fromPackage: "samurai_scan")
          let scanIconKey = registrar.lookupKey(forAsset: "assets/scan.png", fromPackage: "samurai_scan")
          let photoIconKey = registrar.lookupKey(forAsset: "assets/photo.png", fromPackage: "samurai_scan")
          if let backIconPath = Bundle.main.path(forResource: backIconKey, ofType: nil) {
              scanController.backImage = UIImage(imageLiteralResourceName: backIconPath)
          }
          if let flashIconPath = Bundle.main.path(forResource: flashIconKey, ofType: nil) {
              scanController.flashImage = UIImage(imageLiteralResourceName: flashIconPath)
          }
          if let cameraIconPath = Bundle.main.path(forResource: cameraIconKey, ofType: nil) {
              scanController.cameraImage = UIImage(imageLiteralResourceName: cameraIconPath)
          }
          if let scanIconPath = Bundle.main.path(forResource: scanIconKey, ofType: nil) {
              scanController.scanImage = UIImage(imageLiteralResourceName: scanIconPath)
          }
          if let photoIconPath = Bundle.main.path(forResource: photoIconKey, ofType: nil) {
              scanController.photoImage = UIImage(imageLiteralResourceName: photoIconPath)
          }
          hostViewController.present(navigationController, animated: true, completion: nil)
      }
    } else {
      result("iOS s1" + UIDevice.current.systemVersion)
    }
  }
}

extension SwiftSamuraiScanPlugin: SamuraiScanDelegate {
    func didQrCodeWithResult(code: String) {
        if let channelResult = result {
            channelResult(code as NSString)
        }
    }
    func didFailCodeWithResult(code: String) {
        if let channelResult = result {
            channelResult(code as NSString)
        }
    }
}
