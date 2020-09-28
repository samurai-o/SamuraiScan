import UIKit
import Photos

struct PhotoTableItem {
    var title: String?
    var assets: PHFetchResult<PHAsset>
}

class PhotoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    // 相册配置
    private var configuration: PhotoConfiguration!
    // 选中后回调
    private var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> ())?
    private var items: [PhotoTableItem] = []
    private indexPath: Int?

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 初始化
    init(frame: CGRect, items: [PhotoTableItem], title: PhotoTableItem, configuration: PhotoConfiguration) {
        super.init(frame: frame, style: UITableView.Style.plain)

        self.items = items;
        self.indexPath = items.index(of: title)
        self.configuration = configuration
        // table及数据代理
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView.isKind(of: PhotoTableCellContentView.self) {
            return hitView
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return self.items.count;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NavTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell", configuration: self.configuration)
    }
}