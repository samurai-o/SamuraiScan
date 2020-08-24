import UIKit

class NavTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: NavDropDownConfiguration!
    var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> ())?
    
    // Private properties
    var items: [String] = []
    var selectedIndexPath: Int?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [String], title: String, configuration: NavDropDownConfiguration) {
        super.init(frame: frame, style: UITableView.Style.plain)
        
        self.items = items
        self.selectedIndexPath = items.index(of: title)
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        //        self.separatorEffect = UIBlurEffect(style: .Light)
        self.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView.isKind(of: NavTableCellContentView.self) {
            return hitView
        }
        return nil;
    }
    
    // Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NavTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[(indexPath as NSIndexPath).row]
        cell.checkmarkIcon.isHidden = ((indexPath as NSIndexPath).row == selectedIndexPath) ? false : true
        return cell
    }
    
    // Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = (indexPath as NSIndexPath).row
        self.selectRowAtIndexPathHandler!((indexPath as NSIndexPath).row)
        self.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as? NavTableViewCell
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
        cell?.textLabel?.textColor = self.configuration.selectedCellTextLabelColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? NavTableViewCell
        cell?.checkmarkIcon.isHidden = true
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
        cell?.textLabel?.textColor = self.configuration.cellTextLabelColor
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.configuration.shouldKeepSelectedCellColor == true {
            cell.backgroundColor = self.configuration.cellBackgroundColor
            cell.contentView.backgroundColor = ((indexPath as NSIndexPath).row == selectedIndexPath) ? self.configuration.cellSelectionColor : self.configuration.cellBackgroundColor
        }
    }
}