import UIKit

// Content view of table view cell
class NavTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        context?.setStrokeColor(self.separatorColor.cgColor)
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: 0, y: self.bounds.size.height))
        context?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        context?.strokePath()
    }
}
