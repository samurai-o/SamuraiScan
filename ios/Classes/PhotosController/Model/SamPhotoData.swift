import UIKit
import Photos

class SamPhotoData: NSObject {
    var isChange = false
    var optCell = [Bool]() {
        didSet {
            self.isChange = true
        }
    }
    var assets = [PHAsset]()
    var seletedAssetArray = [PHAsset]()
}

public class SamPhotoModel: NSObject {
    public var thumbnailImage: UIImage?
    public var originImage: UIImage?
    public var imageURL: String?
    public convenience override init() {
        self.init(thumbnailImage: nil, originImage: nil, imageURL: nil)
    }
    
    public init(thumbnailImage: UIImage?, originImage: UIImage?, imageURL: String?) {
        self.thumbnailImage = thumbnailImage
        self.originImage = originImage
        self.imageURL = imageURL
    }
}
