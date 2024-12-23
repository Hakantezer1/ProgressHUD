//
//  SheetState.swift
//  ProgressHUD
//
//  Created by user1000 on 19/12/2024.
//


import UIKit

private enum SheetState {
    case open
    case active
    case inactive
    case closing
}

class SheetView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SheetView
    
    @IBOutlet weak private var containerMain: UIView!{
        didSet {
            containerMain.layer.cornerRadius = 15
            containerMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerMain.clipsToBounds = true
        }
    }
    @IBOutlet weak private var iconcontainer: UIView!
    
    @IBOutlet weak private var iconImage: UIImageView!
    
    @IBOutlet weak private var iconActivity: UIActivityIndicatorView!
    
    @IBOutlet weak private var title: UILabel!
    
    @IBOutlet weak private var subtitle: UILabel!
    
    @IBOutlet weak private var statusContainer: UIView!{
        didSet {
            statusContainer.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak private var status: UILabel!
    
    @IBOutlet private var infoViews: [UIView]!{
        didSet {
            infoViews.forEach { $0.layer.cornerRadius = 10 }
        }
    }
    
    @IBOutlet private var infoActivities: [UIActivityIndicatorView]!
    @IBOutlet private var infoIcons0: [UIImageView]!

    @IBOutlet private var infoIcons: [UIImageView]!
    
    @IBOutlet weak private var progressView: UIProgressView!
    
    @IBOutlet weak private var goBTN: UIButton!{
        didSet {
            goBTN.layer.cornerRadius = 12
        }
    }
    
    private var timer: Timer?
    private var progress: Float = 0.0
    var dismissAction: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        change(.open)
    }
    
    
    
    var model: SheetObject?
    
    private var state: SheetState = .open {
        didSet {
            DispatchQueue.main.async {
                guard let model = self.model else { return }
                switch self.state {
                case .open:
                    
                    let imURL = URL(string: model.ic_1)!
                    
                    self.iconImage.kf.setImage(with: imURL, options: [.processor(SVGImgProcessor())])
                    
                    
                    self.iconcontainer.isHidden = false
                    self.iconActivity.isHidden = true
                    self.subtitle.isHidden = true
                    self.infoViews.forEach({$0.isHidden = true})
                    self.progressView.isHidden = true
                    self.goBTN.isHidden = false
                    self.statusContainer.backgroundColor = .systemRed
                    self.status.textColor = .white
                    
                    
                    self.status.text = model.status_1
                    self.goBTN.setTitle(model.btn_1, for: .normal)
                    self.title.text = model.title_1
                    
                case .active:
                    let imURL = URL(string: model.ic_2)!
                    
                    self.iconImage.kf.setImage(with: imURL, options: [.processor(SVGImgProcessor())])
                    self.iconActivity.isHidden = false
                    self.iconcontainer.isHidden = false
                    
                    self.iconActivity.startAnimating()
                    self.subtitle.isHidden = true
                    self.infoViews.forEach({$0.isHidden = true})
                    self.progressView.isHidden = false
                    self.startProgressAnimation()
                    self.goBTN.isHidden = true
                    self.statusContainer.backgroundColor = UIColor(hex: "#EFEFEF")
                    self.status.textColor = UIColor(hex: "#676767")
                    
                    self.status.text = model.status_2
                    self.title.text = model.title_1
                    
                case .inactive:
                    self.iconImage.isHidden = true
                    self.iconcontainer.isHidden = true
                    self.iconActivity.isHidden = true
                    self.subtitle.isHidden = true
                    self.infoViews.forEach({$0.isHidden = false})
                    self.progressView.isHidden = true
                    self.goBTN.isHidden = true
                    let imURL0 = URL(string: model.ic_3)!
                    let imURL = URL(string: model.ic_4)!

                    self.infoIcons0.forEach({
                        $0.kf.setImage(with: imURL0, options: [.processor(SVGImgProcessor())])
                    })
                    
                    self.infoIcons.forEach({
                        $0.kf.setImage(with: imURL, options: [.processor(SVGImgProcessor())])
                        $0.isHidden = true
                    })
                    
                    self.infoActivities.forEach({ (activity) in
                        activity.isHidden = false
                        activity.startAnimating()
                        self.switchActivitiToIcon(activity.tag){
                            self.change(.closing)
                        }
                    })
                    
                    self.title.textColor = .systemRed
                    self.statusContainer.backgroundColor = .systemRed
                    self.status.textColor = .white
                    
                    self.status.text = model.status_3
                    self.title.text = model.title_2
                    
                case .closing:
                    let imURL = URL(string: model.ic_5)!

                    self.iconImage.kf.setImage(with: imURL, options: [.processor(SVGImgProcessor())])
                    self.title.textColor = .black
                    self.iconImage.isHidden = false
                    self.iconcontainer.isHidden = false
                    self.iconActivity.isHidden = true
                    self.subtitle.isHidden = false
                    self.infoViews.forEach({$0.isHidden = true})
                    self.progressView.isHidden = true
                    self.subtitle.isHidden = true
                    self.goBTN.isHidden = false
                    self.statusContainer.backgroundColor = UIColor(hex: "#65D65C")
                    self.status.textColor = .white
                    
                    self.subtitle.text = model.subtitle
                    self.status.text = model.status_4
                    self.goBTN.setTitle(model.btn_2, for: .normal)
                    self.title.text = model.title_1
                    
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    private func switchActivitiToIcon(_ tag: Int, action: (() -> Void)?) {
        var duratiuon: TimeInterval = 0
        switch tag {
        case 0:
            duratiuon = 5.5
        case 1:
            duratiuon = 1.5
        case 2:
            duratiuon = 2.5
        default: break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duratiuon){
            self.infoActivities.first(where:{$0.tag == tag})?.stopAnimating()
            self.infoActivities.first(where:{$0.tag == tag})?.isHidden = true
            self.infoIcons.first(where:{$0.tag == tag})?.isHidden = false
            tag == 0 ? DispatchQueue.main.asyncAfter(deadline: .now() + 1) { action?() } : nil
        }
    }
    
    private func startProgressAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        if Bool.random() {
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startProgressAnimation()
            }
            return
        }
        
        progress += 0.02
        progressView.setProgress(progress, animated: true)
        
        if progress >= 0.3 {
            timer?.invalidate()
            change(.inactive)
        }
    }
    
    private func change(_ state: SheetState) {
        self.state = state
        
    }
    
    
    @IBAction func goBTNAction(_ sender: Any) {
        state == .open ? change(.active): dismissAction?()
    }
    
}
