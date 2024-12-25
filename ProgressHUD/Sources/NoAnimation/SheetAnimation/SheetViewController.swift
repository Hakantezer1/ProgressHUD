import UIKit

class SheetViewController: UIViewController {
    
    let    sheetAlert = SheetView.instanceFromNib()
    public var model: SheetObject?
    
    override func loadView() {
        sheetAlert.model = self.model
        view = sheetAlert
    }
    
    public init(_ model: SheetObject? = nil) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

