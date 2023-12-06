//
//  MyOrderDetailStatusCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit

class MyOrderDetailStatusCell: UICollectionViewCell {
    //MARK: - Properties
    var atTheStoreBullet = MyOrderDetailStatusCellBullet(status: .completed, string: appDele!.isForArabic ? At_the_Store_ar : At_the_Store_en )
    var beingWrappedUpBullet = MyOrderDetailStatusCellBullet(status: .incomplete, string: appDele!.isForArabic ? Being_Wrapped_Up_ar : Being_Wrapped_Up_en)
    var onTheWayBullet = MyOrderDetailStatusCellBullet(status: .incomplete, string: appDele!.isForArabic ? On_the_Way_ar : On_the_Way_en)
    var deliveredBullet = MyOrderDetailStatusCellBullet(status: .incomplete, string: appDele!.isForArabic ? Delivered_ar : Delivered_en)
    
    //MARK: - UI Elements
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else { return }
            if orderItem.orderStatus == "At the Store" {
                atTheStoreBullet.status = .active
            }
            if orderItem.orderStatus == "Being Wrapped Up" || orderItem.orderStatus == "Reached at warehouse" || orderItem.orderStatus == "En Route to Warehouse" || orderItem.orderStatus == "Ready for pickup" {
                atTheStoreBullet.status = .completed
                beingWrappedUpBullet.status = .active
            }
            if orderItem.orderStatus == "On the Way" {
                atTheStoreBullet.status = .completed
                beingWrappedUpBullet.status = .completed
                onTheWayBullet.status = .active
            }
            if orderItem.orderStatus == "Delivered" {
                atTheStoreBullet.status = .completed
                beingWrappedUpBullet.status = .completed
                onTheWayBullet.status = .completed
                deliveredBullet.status = .active
            }
        }
    }
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .appBackgroundColor
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        atTheStoreBullet.isTopHidden = true
        deliveredBullet.isBottomHidden = true
        
        let mainStack = UIStackView(arrangedSubviews: [atTheStoreBullet, beingWrappedUpBullet, onTheWayBullet, deliveredBullet])
        mainStack.axis = .vertical
        mainStack.spacing = 0
        mainStack.alignment = .leading
        mainStack.distribution = .fillEqually
        
        addSubview(mainStack)
        mainStack.fillSuperview()
    }
}





enum MyOrderDetailStatusCellBulletStatus {
    case completed
    case active
    case incomplete
}


class MyOrderDetailStatusCellBullet: UIView {
    let titleString: String
    var status: MyOrderDetailStatusCellBulletStatus
    
    var isTopHidden: Bool? {
        didSet {
            guard let bool = isTopHidden else { return }
            topDottedView.alpha = bool ? 0 : 1
        }
    }
    
    var isBottomHidden: Bool? {
        didSet {
            guard let bool = isBottomHidden else { return }
            bottomDottedView.alpha = bool ? 0 : 1
        }
    }
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = titleString
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private lazy var colorView: CircularPulsatingView = {
        let view = CircularPulsatingView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.setDimensions(height: 20, width: 20)
        view.layer.cornerRadius = 20/2
        view.pulsatingLayer.strokeColor = UIColor.appPrimaryColor.cgColor
        switch status {
        case .completed:
            view.pulsatingLayer.strokeColor = UIColor.systemGreen.withAlphaComponent(0.35).cgColor
        case .active:
            view.pulsatingLayer.strokeColor = UIColor.appPrimaryColor.withAlphaComponent(0.35).cgColor
            view.animatePulsatingLayer()
            view.setProgressWithAnimation(duration: 10, value: 3) {}
        case .incomplete:
            view.pulsatingLayer.strokeColor = UIColor.clear.cgColor

        }
        
        return view
    }()
    
    private lazy var bulletView: UIView = {
        let view = UIView()
        view.setDimensions(height: 45, width: 45)
        view.layer.cornerRadius = 45/2
        
        let bulletView = UIView()
        bulletView.backgroundColor = status == .completed ? .systemGreen : .appPrimaryColor
        bulletView.setDimensions(height: 18, width: 18)
        bulletView.layer.cornerRadius = 18/2
        
        bulletView.layer.borderColor = UIColor.white.cgColor
        bulletView.layer.borderWidth = 3
        
        view.addSubview(colorView)
        colorView.centerX(inView: view)
        colorView.centerY(inView: view)
        
        view.addSubview(bulletView)
        bulletView.centerX(inView: view)
        bulletView.centerY(inView: view)
        
        return view
    }()
    
    private let topDottedView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    private let bottomDottedView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    init(status: MyOrderDetailStatusCellBulletStatus, string: String) {
        self.status = status
        self.titleString = string
        super.init(frame: .zero)
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Function
    func configureView() {
        let stack = UIStackView(arrangedSubviews: [bulletView, statusLabel])
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.fillSuperview()
        
        
        addSubview(topDottedView)
        topDottedView.anchor(top: topAnchor, bottom: bulletView.topAnchor, paddingBottom: 3, width: 1)
        topDottedView.centerX(inView: bulletView)
        
        addSubview(bottomDottedView)
        bottomDottedView.anchor(top: bulletView.bottomAnchor, bottom: bottomAnchor, paddingTop: 3, width: 1)
        bottomDottedView.centerX(inView: bulletView)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
