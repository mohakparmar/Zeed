//
//  NewXYZController.swift
//  Zeed
//
//  Created by Shrey Gupta on 23/08/21.
//

import UIKit

enum VariantAttributeType {
    case variantOne
    case variantTwo
}

class AddVariantController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    let parentController: CreateController
    
    lazy var allVariants: [CreateItemVariant] = parentController.itemVariants {
        didSet {
             checkVariantStats()
            collectionView.reloadData()
        }
    }
    
    var fetchedAttributes = [ItemAttribute]()
    var attributePicker = AttributePicker()
    var blackView = UIView()
    
    //MARK: - UI Elements
    private lazy var addMoreVarientsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Add_More_Variant_ar : Add_More_Variant_en, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleTapAddMore), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Done_ar : Done_en, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .appPrimaryColor
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    private let addVariantsLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? This_product_has_no_variants_ar : This_product_has_no_variants_en
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Lifecycle
    init(fromController: CreateController) {
        self.parentController = fromController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Add_Variant", str_nib_name: self.nibName ?? "")

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: appDele!.isForArabic ? Go_back_ar : Go_back_en, style: .plain, target: self, action: #selector(handleBackTapped))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        attributePicker.delegate = self
        
        collectionView.delegate = self
        collectionView.register(AddVariantCell.self, forCellWithReuseIdentifier: AddVariantCell.reuseIdentifier)
        
        configureUI()
        checkVariantStats()
        
        Service.shared.fetchAllAttributes { allAttributes, status, message in
            if status {
                guard let allAttributes = allAttributes else { return }
                self.fetchedAttributes = allAttributes
            } else {
            }
        }
    }
    
    //MARK: - Selectors
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 0
            self.attributePicker.frame.origin.y = UIScreen.main.bounds.height
        } completion: { (_) in
            self.blackView.removeFromSuperview()
        }
    }
    
    @objc func handleTapAddMore() {
        allVariants.append(CreateItemVariant())
    }
    
    @objc func didTapSave() {
        parentController.itemVariants = allVariants
        navigationController?.popViewController(animated: true)
        parentController.showAlert(withMsg: "Saved")
    }
    
    @objc func handleBackTapped() {
        let alert = UIAlertController(title: "Are you sure want to exit without saving?", message: "Changes you made won't be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Continue_ar : Continue_en, style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
        view.backgroundColor = .appBackgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        view.addSubview(addMoreVarientsButton)
        addMoreVarientsButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        addMoreVarientsButton.setDimensions(height: 45, width: collectionView.frame.width - 30)
        addMoreVarientsButton.centerX(inView: view)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: addMoreVarientsButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 8)
        
        view.addSubview(addVariantsLabel)
        addVariantsLabel.centerX(inView: collectionView)
        addVariantsLabel.centerY(inView: collectionView)
        
        addVariantsLabel.alpha = 0
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
    
    func bringAttributePicker(forIndexPath indexPath: IndexPath, forVariantType variantType: VariantAttributeType) {
        attributePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
        
        attributePicker.allAttributes = fetchedAttributes
        attributePicker.forIndexPath = indexPath
        attributePicker.forVariantType = variantType
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(attributePicker)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.attributePicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2.5)
        }
    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        blackView.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        UIApplication.shared.keyWindow?.addSubview(blackView)
        blackView.fillSuperview()
    }
    
    func checkVariantStats() {
        if allVariants.count == 0 {
            addVariantsLabel.alpha = 1
        } else {
            addVariantsLabel.alpha = 0
        }
    }
    
    //MARK: - Delagate and DataSource UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVariants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddVariantCell.reuseIdentifier, for: indexPath) as! AddVariantCell
        cell.createVariant = allVariants[indexPath.row]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    }
}

//MARK: - Delegate NewXYZCellDelegate
extension AddVariantController: AddVariantCellDelegate {
    func didTapVariantOne(onCell cell: AddVariantCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        bringAttributePicker(forIndexPath: indexPath, forVariantType: .variantOne)
    }
    
    func didTapVariantTwo(onCell cell: AddVariantCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        bringAttributePicker(forIndexPath: indexPath, forVariantType: .variantTwo)
//        let status = self.allVariants[indexPath.row].setVariantTwo(variant: "selected")
//        print("DEBUG:- TWO \(status)")
//        collectionView.reloadItems(at: [indexPath])
    }
    
    func didChangePrice(price: Double, onCell cell: AddVariantCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        self.allVariants[indexPath.row].setPrice(price: price)
    }
    
    func didChangeQuantity(quantity: Int, onCell cell: AddVariantCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        self.allVariants[indexPath.row].setQuantity(quantity: quantity)
    }
    
    func didTapRemove(onCell cell: AddVariantCell) {
        let alert = UIAlertController(title: nil, message: appDele!.isForArabic ? Are_you_sure_want_to_remove_this_variant_ar : Are_you_sure_want_to_remove_this_variant_en, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Continue_ar : Continue_en, style: .destructive, handler: { _ in
            guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
            self.allVariants.remove(at: indexPath.row)
            
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension AddVariantController: AttributePickerDelegate {
    func attributePicker(_ attributePicker: AttributePicker, didSelectAttribute attribute: ItemAttribute, atIndexPath indexPath: IndexPath, forVariantType: VariantAttributeType) {
        
        switch forVariantType {
        case .variantOne:
            let result = self.allVariants[indexPath.row].setVariantOne(variant: attribute)
            let status = result.0
            if !status {
                guard let message = result.1 else { return }
                self.showAlert(withMsg: "\(message)", forTime: 0.8)
            }
        case .variantTwo:
            let result = self.allVariants[indexPath.row].setVariantTwo(variant: attribute)
            let status = result.0
            if !status {
                guard let message = result.1 else { return }
                self.showAlert(withMsg: "\(message)", forTime: 0.8)
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
        dismissPicker()
    }
    
}

