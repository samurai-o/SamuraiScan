import UIKit

class PhotoTableViewCell: UITableViewCell {


    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, configuration: PhotoConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configuration = configuration
        // 绘制矩形list的展示框
        cellContentFrame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: self.configuration.cellHeight)
        // 背景色
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        // 选中时的颜色
        self.selectionStyle = UITableViewCell.SelectionStyle.node
        // 标题文本颜色
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        // 对齐方式
        self.textLabel!.textAlignment = self.configuration.cellTextLabelAlignment
        if self.textLabel!.textAlignment == .center {

        }
    }
 
}