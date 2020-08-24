import UIKit
import AVFoundation


enum SQError: Error {
    case authorizationDenied(message: String)
    case deviceNotFound(message: String)
}


enum ApplicationStatus {
    case success
    case notAuthorized
    case configurationFailed
}

protocol SamuraiScanDelegate: class{
    func didQrCodeWithResult(code: String)
    func didFailCodeWithResult(code: String)
}

class SamuraiScanController: UIViewController {
    private let session: AVCaptureSession = AVCaptureSession()
    private var applicationStatus: ApplicationStatus = .success
    private let taskQueue = DispatchQueue(label: "ScanTask queue")
    private let backButton: UIButton = UIButton(type: .custom)
    private let flashButton: UIButton = UIButton(type: .custom)
    private let screenW = UIScreen.main.bounds.size.width
    private let screenH = UIScreen.main.bounds.size.height
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var blurEffect: UIVisualEffectView!
    private var rectOfInterest: CGRect!
    private var tools: UIView!
    public weak var delegate: SamuraiScanDelegate?
    public var backImage: UIImage!
    public var flashImage: UIImage!
    public var cameraImage: UIImage!
    public var photoImage: UIImage!
    public var scanImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingNavigation()
        initialView()
        checkAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskQueue.async {
            switch self.applicationStatus {
            case .success:
                self.session.startRunning()
            case .notAuthorized:
                DispatchQueue.main.async {
                    let askController = UIAlertController(title: "扫码", message: "前往设置相机权限", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "前往", style: .default) { (action) in
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        self.dismiss(animated: true, completion: nil)
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    askController.addAction(confirmAction)
                    askController.addAction(cancelAction)
                    self.present(askController, animated: true)
                }
            case .configurationFailed:
                DispatchQueue.main.async {
                    let askController = UIAlertController(title: "扫码", message: "前往设置相机权限", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "取消", style: .default) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    askController.addAction(confirmAction)
                    self.present(askController, animated: true)
                }
            }
        }
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 闪光灯控制
    @objc func flashAction() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashButton.isSelected = false
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    flashButton.isSelected = true
                } catch {
                    return
                }
            }
            device.unlockForConfiguration()
        } catch {
            return
        }
    }
    
    // 打开相册
    @objc func photoAction() {
        let photo = PhotoController()
        photo.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(photo, animated: true)
    }
    
    private func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let scale = width / image.size.width
        let height = image.size.height * scale
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // 权限检查
    private func checkAuth() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            taskQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.applicationStatus = .notAuthorized
                }
                self.taskQueue.resume()
            })
        default:
            applicationStatus = .notAuthorized
        }
        taskQueue.async {
            self.settingCamera()
        }
    }
    
    // 设置导航栏
    private func settingNavigation() {
        backButton.setImage(resizeImage(image: backImage, width: 24), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        flashButton.setImage(resizeImage(image: flashImage, width: 24), for: .normal)
        flashButton.setTitle("", for: .normal)
        flashButton.setTitleColor(UIColor.white, for: .normal)
        flashButton.addTarget(self, action: #selector(flashAction), for: .touchUpInside)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flashButton)
    }
    
    private func settingTabbar() -> UIView {
        let Tools = UIView(frame: CGRect(x: 0, y: (screenH - 100), width: screenW, height: 26))
        let interval = (screenW - 26 * 3) / (3 + 1);
        
        let CameraTab = UIButton(type: .custom)
        CameraTab.frame = CGRect(x: interval, y: 0, width: 26, height: 26)
        CameraTab.setImage(resizeImage(image: cameraImage, width: 26), for: .normal)
        CameraTab.setTitle("", for: .normal)
        CameraTab.setTitleColor(UIColor.white, for: .normal)
        
        let ScanTab = UIButton(type: .custom)
        ScanTab.frame = CGRect(x: (interval * 2 + 26), y: 0, width: 26, height: 26)
        ScanTab.setImage(resizeImage(image: scanImage, width: 26), for: .normal)
        ScanTab.setTitle("", for: .normal)
        ScanTab.setTitleColor(UIColor.white, for: .normal)
        
        let PhotoTab = UIButton(type: .custom)
        PhotoTab.frame = CGRect(x: (interval * 3 + 52), y: 0, width: 26, height: 26)
        PhotoTab.setImage(resizeImage(image: photoImage, width: 26), for: .normal)
        PhotoTab.setTitle("", for: .normal)
        PhotoTab.setTitleColor(UIColor.white, for: .normal)
        PhotoTab.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        
        Tools.addSubview(CameraTab)
        Tools.addSubview(ScanTab)
        Tools.addSubview(PhotoTab)
        
        return Tools
    }
 
    // 初始化视图
    private func initialView() {
        let w = screenW * 0.6, h = screenW * 0.6
        let scanningArea = CGRect(x: (screenW - w) / 2, y: (screenH - h) * 0.4, width: w, height: h)
        let path = UIBezierPath(roundedRect: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), cornerRadius: 0)
        let scan = UIBezierPath(roundedRect: scanningArea, cornerRadius: 10).reversing()
        let blur = UIBlurEffect(style: .dark)
        let shapeLayer = CAShapeLayer()
        blurEffect = UIVisualEffectView(effect: blur)
        rectOfInterest = CGRect(x: ((screenH - h) * 0.4)/screenH, y: ((screenW - w) / 2)/screenW, width: h/screenH, height: w/screenW)
        path.append(scan)
        shapeLayer.path = path.cgPath
        shapeLayer.borderWidth = 10
        shapeLayer.borderColor = UIColor.black.cgColor
        blurEffect.layer.mask = shapeLayer
        blurEffect.frame = view.bounds
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
    }

    private func settingCamera() {
        if applicationStatus != .success {
            return
        }
        session.beginConfiguration()
        do {
            guard let device = try? AVCaptureDevice.default(for: .video) else {  backAction(); return }
            guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { backAction(); return }
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
                DispatchQueue.main.async {
                    self.view.layer.addSublayer(self.previewLayer)
                    self.view.addSubview(self.blurEffect)
                    self.view.addSubview(self.settingTabbar())
                }
            } else {
                applicationStatus = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            applicationStatus = .configurationFailed
            session.commitConfiguration()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.rectOfInterest = rectOfInterest
        } else {
            applicationStatus = .configurationFailed
            session.commitConfiguration()
            return
        }
        session.commitConfiguration()
    }
    
}

extension SamuraiScanController: AVCaptureMetadataOutputObjectsDelegate{
    @objc func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didQrCodeWithResult(code: stringValue)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
