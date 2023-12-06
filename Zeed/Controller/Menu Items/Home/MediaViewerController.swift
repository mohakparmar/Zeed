//
//  MediaViewerController.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/04/21.
//

import UIKit

class MediaViewerController: UIViewController {
    //MARK: - Properties
    var imagePagingView: SGImagePagingView
    
    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Lifecycle
    init(forMedias allMedia: [ItemMedia] ) {
        self.imagePagingView = SGImagePagingView(forMedias: allMedia, isZoomEnabled: true)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "MediaView", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Media", preferredLargeTitle: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        imagePagingView.collectionView.backgroundColor = .white
        imagePagingView.clipsToBounds = false
        imagePagingView.collectionView.clipsToBounds = false
        
        view.addSubview(imagePagingView)
        imagePagingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
}
