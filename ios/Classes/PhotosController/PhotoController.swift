import UIKit
import Photos

class PhotoController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    private let backButton: UIButton = UIButton(type: .custom)
    private let flashButton: UIButton = UIButton(type: .custom)
    private let manager: PHCachingImageManager!
    private var menuView: NavigationDropdownMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        openPhoto()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        menuView.close()
    }
    
    
    private func settingNavigation(titles: [String]) {
        //backButton.setTitle("返回", for: .normal)
       // backButton.setTitleColor(UIColor.blue, for: .normal)
        //backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        menuView = NavigationDropdownMenu(title: NavTitle.index(1), items: titles)
        menuView.maskBackgroundColor = UIColor.white
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = menuView
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func fromAlbum(_ sender: AnyObject) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            //设置是否允许编辑
//            picker.allowsEditing = editSwitch.isOn
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }

    private func conversionTitleEnToZn(title:String?) -> String? {
         if title == "Slo-mo" {
             return "慢动作"
         } else if title == "Panoramas" {
             return "全景照片"
         } else if title == "Recently Added" {
             return "最近添加"
         } else if title == "Favorites" {
             return "个人收藏"
         } else if title == "Recently Deleted" {
             return "最近删除"
         } else if title == "Videos" {
             return "视频"
         } else if title == "All Photos" {
             return "所有照片"
         } else if title == "Selfies" {
             return "自拍"
         } else if title == "Screenshots" {
             return "屏幕快照"
         } else if title == "Camera Roll" {
             return "相机胶卷"
         } else if title == "Animated" {
             return "动图"
         } else if title == "Live Photos" {
             return "实况照片"
         } else if title == "Recents" {
             return "最近"
         }
        return title
    }
    
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>) -> [String]{
        var smartAlbumTitles: [String] = []
         
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return [] }
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                            print(assetsFetchResult[0])
                let title = conversionTitleEnToZn(title: c.localizedTitle)
                smartAlbumTitles.append(title!);
            }
        }
        return smartAlbumTitles
    }
    
    private func openPhoto() {
        PHPhotoLibrary.requestAuthorization({(status) in
            if (status != .authorized) {
                return
            }
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
            let titles = self.convertCollection(collection: smartAlbums)
            print(titles)
            DispatchQueue.main.async{
                self.settingNavigation(titles: titles)
            }
        })
    }
}
