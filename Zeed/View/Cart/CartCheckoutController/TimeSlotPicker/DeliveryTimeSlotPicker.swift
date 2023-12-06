//
//  DeliveryTimeSlotPicker.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/09/21.
//
import UIKit

protocol DeliveryTimeSlotPickerDelegate: AnyObject {
    func deliveryTimeSlotPicker(_ deliveryTimeSlotPicker: DeliveryTimeSlotPicker, didSelectTimeSlot timeSlot: TimeSlot, at indexPath: IndexPath)
}

private let reuseIdentifier = "DeliveryTimeSlotCell"

class DeliveryTimeSlotPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    var collectionView: UICollectionView!
    
    weak var delegate: DeliveryTimeSlotPickerDelegate?
    
    var allTimeSlots: [TimeSlot]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? "حدد فترة زمنية" : "Select Time Slot"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DeliveryTimeSlotCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 45, paddingLeft: 4, paddingRight: 4)
        
        configureUI()
    
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().trasfoamView(self)
            titleLabel.transform = trnForm_Ar
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Funtions
    func configureUI() {
        collectionView.backgroundColor = .clear
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 12)
        titleLabel.centerX(inView: self)
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTimeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DeliveryTimeSlotCell
        cell.timeSlot = allTimeSlots[indexPath.row]
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 38), height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 8, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.deliveryTimeSlotPicker(self, didSelectTimeSlot: allTimeSlots[indexPath.row], at: indexPath)
    }
}



