import UIKit

open class NavigationDropdownMenu: UIView {
    fileprivate let configuration = NavDropDownConfiguration()
    fileprivate weak var navigationController: UINavigationController?
    fileprivate var topSeparator: UIView!
    fileprivate var menuButton: UIButton!
    fileprivate var menuTitle: UILabel!
    fileprivate var backgroundView: UIView!
    fileprivate var tableView: NavTableView!
    fileprivate var items: [String]!
    fileprivate var menuWrapper: UIView!
    fileprivate var menuArrow: UIImageView!
    open var didSelectItemAtIndexHandler: ((_ indexPath: Int) -> ())?
    open var isShown: Bool!

    open var menuTitleColor: UIColor! {
        get {
            return self.configuration.menuTitleColor
        }
        set(value) {
            self.configuration.menuTitleColor = value
        }
    }

    open var cellHeight: NSNumber {
        get {
            return self.configuration.cellHeight as NSNumber
        }
        set(value) {
            self.configuration.cellHeight = CGFloat(truncating: value)
        }
    }

    open var cellBackgroundColor: UIColor! {
        get {
            return self.configuration.cellBackgroundColor
        }
        set(color) {
            self.configuration.cellBackgroundColor = color
        }
    }

    open var cellSeparatorColor: UIColor! {
        get {
            return self.configuration.cellSeparatorColor
        }
        set(value) {
            self.configuration.cellSeparatorColor = value
        }
    }

    open var cellTextLabelColor: UIColor! {
        get {
            return self.configuration.cellTextLabelColor
        }
        set(value) {
            self.configuration.cellTextLabelColor = value
        }
    }

    open var selectedCellTextLabelColor: UIColor! {
        get {
            return self.configuration.selectedCellTextLabelColor
        }
        set(value) {
            self.configuration.selectedCellTextLabelColor = value
        }
    }

    open var cellTextLabelFont: UIFont! {
        get {
            return self.configuration.cellTextLabelFont
        }
        set(value) {
            self.configuration.cellTextLabelFont = value
        }
    }

    open var navigationBarTitleFont: UIFont! {
        get {
            return self.configuration.navigationBarTitleFont
        }
        set(value) {
            self.configuration.navigationBarTitleFont = value
            self.menuTitle.font = self.configuration.navigationBarTitleFont
        }
    }

    open var cellTextLabelAlignment: NSTextAlignment! {
        get {
            return self.configuration.cellTextLabelAlignment
        }
        set(value) {
            self.configuration.cellTextLabelAlignment = value
        }
    }

    open var cellSelectionColor: UIColor! {
        get {
            return self.configuration.cellSelectionColor
        }
        set(value) {
            self.configuration.cellSelectionColor = value
        }
    }

    open var checkMarkImage: UIImage! {
        get {
            return self.configuration.checkMarkImage
        }
        set(value) {
            self.configuration.checkMarkImage = value
        }
    }

    open var shouldKeepSelectedCellColor: Bool! {
        get {
            return self.configuration.shouldKeepSelectedCellColor
        }
        set(value) {
            self.configuration.shouldKeepSelectedCellColor = value
        }
    }

    open var animationDuration: TimeInterval! {
        get {
            return self.configuration.animationDuration
        }
        set(value) {
            self.configuration.animationDuration = value
        }
    }

    open var arrowPadding: CGFloat! {
        get {
            return self.configuration.arrowPadding
        }
        set(value) {
            self.configuration.arrowPadding = value
        }
    }

    open var maskBackgroundColor: UIColor! {
        get {
            return self.configuration.maskBackgroundColor
        }
        set(value) {
            self.configuration.maskBackgroundColor = value
        }
    }

    open var maskBackgroundOpacity: CGFloat! {
        get {
            return self.configuration.maskBackgroundOpacity
        }
        set(value) {
            self.configuration.maskBackgroundOpacity = value
        }
    }

    open var shouldChangeTitleText: Bool! {
        get {
            return self.configuration.shouldChangeTitleText
        }
        set(value) {
            self.configuration.shouldChangeTitleText = value
        }
    }
    
    open var arrowTintColor: UIColor! {
        get {
            return self.menuArrow.tintColor
        }
        set(color) {
            self.menuArrow.tintColor = color
        }
    }

    private func setMenuTitle(_ title: String) {
        self.menuTitle.text = title
    }

    private func rotateArrow() {
        UIView.animate(withDuration: self.configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(Double.pi/180))
            }
        })
    }

    private func showMenu() {
        self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY

        self.isShown = true

        // Table view header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView

        self.topSeparator.backgroundColor = self.configuration.cellSeparatorColor

        // Rotate arrow
        self.rotateArrow()

        // Visible menu view
        self.menuWrapper.isHidden = false

        // Change background alpha
        self.backgroundView.alpha = 0

        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300

        // Reload data to dismiss highlight color of selected cell
        self.tableView.reloadData()

        self.menuWrapper.superview?.bringSubviewToFront(self.menuWrapper)

        UIView.animate(
            withDuration: self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity },
            completion: nil
        )
    }

    override open func layoutSubviews() {
         self.menuTitle.sizeToFit()
         self.menuTitle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
         self.menuTitle.textColor = self.configuration.menuTitleColor
         self.menuArrow.sizeToFit()
         self.menuArrow.center = CGPoint(x: self.menuTitle.frame.maxX + self.configuration.arrowPadding, y: self.frame.size.height/2)
         self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
         self.tableView.reloadData()
    }

    open func hide() {
        if self.isShown == true {
            self.hideMenu()
        }
    }

    open func toggle() {
        if(self.isShown == true) {
            self.hideMenu();
        } else {
            self.showMenu();
        }
    }

    open func show() {
        if self.isShown == false {
            self.showMenu()
        }
    }

    open func updateItems(_ items: [String]) {
        if !items.isEmpty {
            self.tableView.items = items
            self.tableView.reloadData()
        }
    }

    open func setSelected(index: Int) {
        self.tableView.selectedIndexPath = index
        self.tableView.reloadData()

        if self.shouldChangeTitleText! {
            self.setMenuTitle("\(self.tableView.items[index])")
        }
    }

    func setupDefaultConfiguration() {
        self.menuTitleColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        self.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        self.cellSeparatorColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        self.cellTextLabelColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor

        self.arrowTintColor = self.configuration.arrowTintColor
    }

    @objc func close() {
        self.menuWrapper.removeFromSuperview()
    }

    @objc func hideMenu() {
        // Rotate arrow
        self.rotateArrow()

        self.isShown = false

        // Change background alpha
        self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        UIView.animate(
            withDuration: self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
            }, 
            completion: nil
        )

        // Animation
        UIView.animate(
            withDuration: self.configuration.animationDuration,
            delay: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
                self.backgroundView.alpha = 0 },
            completion: { _ in
                if self.isShown == false && self.tableView.frame.origin.y == -CGFloat(self.items.count) * self.configuration.cellHeight - 300 {
                    self.menuWrapper.isHidden = true
                }
        })
    }

    @objc func menuButtonTapped(_ sender: UIButton) {
        self.isShown == true ? hideMenu() : showMenu()
    }


    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(navigationController: UINavigationController? = nil, containerView: UIView = UIApplication.shared.keyWindow!, title: NavTitle, items: [String]) {
        // Key window
        guard let window = UIApplication.shared.keyWindow else {
            super.init(frame: CGRect.zero)
            return
        }

        // Navigation controller
        if let navigationController = navigationController {
            self.navigationController = navigationController
        } else {
            self.navigationController = window.rootViewController?.topMostViewController?.navigationController
        }

        // Get titleSize
        let titleSize: CGSize
        let titleToDisplay: String 

        switch title {
            case .index(let index):
                if index < items.count{
                    titleToDisplay = items[index]
                } else {
                    titleToDisplay = ""
                }
            case .title(let title):
                titleToDisplay = title
            default:
                titleToDisplay = ""
        }

        titleSize = (titleToDisplay as NSString).size(withAttributes: [NSAttributedString.Key.font:self.configuration.navigationBarTitleFont])

        // Set frame
        let frame = CGRect(x: 0, y: 0, width: titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage.size.width)*2, height: self.navigationController!.navigationBar.frame.height)

        super.init(frame:frame)

        self.isShown = false
        self.items = items

        // Init button as navigation title
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle.text = titleToDisplay
        self.menuTitle.textColor = self.menuTitleColor
        self.menuTitle.font = self.configuration.navigationBarTitleFont
        self.menuTitle.textAlignment = self.configuration.cellTextLabelAlignment
        
        self.menuButton = UIButton(frame: frame)
        self.menuButton.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.menuButton.setTitleColor(UIColor.blue, for: .normal)
        self.menuButton.addTarget(self, action: #selector(NavigationDropdownMenu.menuButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.menuButton.setImage(self.configuration.arrowImage, for: .normal)
        self.menuButton.addSubview(self.menuTitle)
        self.addSubview(self.menuButton)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage.withRenderingMode(.alwaysTemplate))
        self.menuButton.addSubview(self.menuArrow)

        let menuWrapperBounds = window.bounds

        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRect(x: menuWrapperBounds.origin.x, y: 0, width: menuWrapperBounds.width, height: menuWrapperBounds.height))
        self.menuWrapper.viewIdentifier = "NavigationDropdownMenu-MenuWrapper"
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]

        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor
        self.backgroundView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]

        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationDropdownMenu.hideMenu));
        self.backgroundView.addGestureRecognizer(backgroundTapRecognizer)

        // Init properties
        self.setupDefaultConfiguration()

        // Init table view
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableView = NavTableView(frame: CGRect(x: menuWrapperBounds.origin.x, y: menuWrapperBounds.origin.y + 0.5, width: menuWrapperBounds.width, height: menuWrapperBounds.height + 300 - navBarHeight - statusBarHeight), items: items, title: titleToDisplay, configuration: self.configuration)

        self.tableView.selectRowAtIndexPathHandler = { [weak self] (indexPath: Int) -> () in
            guard let selfie = self else {
                return
            }
            selfie.didSelectItemAtIndexHandler!(indexPath)
            if selfie.shouldChangeTitleText! {
                selfie.setMenuTitle("\(selfie.tableView.items[indexPath])")
            }
            self?.hideMenu()
            self?.layoutSubviews()
        }

        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.backgroundView)
        self.menuWrapper.addSubview(self.tableView)

        // Add Line on top
        self.topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: menuWrapperBounds.size.width, height: 0.5))
        self.topSeparator.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.menuWrapper.addSubview(self.topSeparator)

        // Remove MenuWrapper from container view to avoid leaks
        containerView.subviews
            .filter({$0.viewIdentifier == "NavigationDropdownMenu-MenuWrapper"})
            .forEach({$0.removeFromSuperview()})

        // Add Menu View to container view
        containerView.addSubview(self.menuWrapper)

        // By default, hide menu view
        self.menuWrapper.isHidden = true
    }

    public convenience init(navigationController: UINavigationController? = nil, containerView: UIView = UIApplication.shared.keyWindow!, title: String, items: [String]) {

        self.init(navigationController: navigationController, containerView: containerView, title: NavTitle.title(title), items: items)
    }
}
