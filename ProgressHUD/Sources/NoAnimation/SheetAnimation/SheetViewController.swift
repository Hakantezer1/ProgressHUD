import UIKit

class SheetViewController: UIViewController {
    
    let    sheetAlert = SheetView.instanceFromNib()
    
    override func loadView() {
        view = sheetAlert
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetAlert.dismissAction = {
            self.dismiss(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isOpaque = false
        view.backgroundColor = .clear
        sheetAlert.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.sheetAlert.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.3) {
            self.sheetAlert.alpha = 0
        }
    }
    
}

