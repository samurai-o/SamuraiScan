
import Foundation

enum Localizable {
    enum Global: String, LocalizableDelegate {
        case cancel, confirm, go
    }
 
    enum ScanMessage: String, LocalizableDelegate {
        case cameraPermisionNonOpen
        case scannerTitle
        case goImmediately
        case deviceNotSupport
    }
}
