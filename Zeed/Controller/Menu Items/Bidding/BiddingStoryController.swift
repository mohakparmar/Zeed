//
//  BiddingStoryController.swift
//  Zeed
//
//  Created by Shrey Gupta on 09/05/21.
//

import UIKit
import GrowingTextView
import EZYGradientView

class BiddingStoryController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Properties
    let item: BidItem
    
    var comments = [CommentObject]()
    
    var productInfoView: BiddingLiveProductInfoView?
    
    var blackView = UIView()
    
    var numberOfViewersView = BiddingLiveNumberOfViewersView()
    var highestBidderInfoView = BiddingLiveHighestBidderInfoView()
    
    lazy var itemInfoButton = createButton(withImage: #imageLiteral(resourceName: "box"))
    lazy var bidderInfoButton = createButton(withImage: #imageLiteral(resourceName: "people"))
    
    var commentCollectionView: UICollectionView
    
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()

    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(didSwipeDown), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    //MARK: - Lifecycle
    init(forItem item: BidItem) {
        self.item = item
        commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(nibName: nil, bundle: nil)
        
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        commentCollectionView.register(BiddingLiveCommentCell.self, forCellWithReuseIdentifier: BiddingLiveCommentCell.reuseIdentifier)
        commentCollectionView.isScrollEnabled = true
        commentCollectionView.alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Bidding_Story", str_nib_name: self.nibName ?? "")

        itemInfoButton.addTarget(self, action: #selector(handleItemInfoTapped), for: .touchUpInside)
        bidderInfoButton.addTarget(self, action: #selector(handleBidderInfoButton), for: .touchUpInside)
        
        fetchComments()
        configureUI()
        
        dismissGesture.delegate = self
        dismissGesture.addTarget(self, action: #selector(didSwipeDown(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Selectors
    @objc func handleItemInfoTapped() {
        productInfoView = BiddingLiveProductInfoView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 300))
        guard let productInfoView = productInfoView else { return }
        productInfoView.item = item
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(productInfoView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 1
            let leftoverSpace = UIScreen.main.bounds.height - 300
            self.productInfoView?.frame.origin.y = leftoverSpace
        })
    }
    
    @objc func handleBidderInfoButton() {
//        let controller = BiddingLiveBiddersController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didSwipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 0
            self.productInfoView?.frame.origin.y = UIScreen.main.bounds.height
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.productInfoView?.removeFromSuperview()
            self.productInfoView = nil
        })
    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        blackView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        view.addSubview(blackView)
        blackView.fillSuperview()
    }

    //MARK: - API
    func fetchComments() {
        // FIXME: - LOGIC FOR FETCHING ALL COMMENTS
//        let comment1 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Mohammed salah", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        let comment2 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Mohammed alnajid", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        let comment3 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Mohammed alfadi", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        let comment4 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Mohammed salah", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        let comment5 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Mohammed T", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        let comment6 = Comment(postID: "2312", commenterUID: "123", commenterProfileImage: "String", commenterName: "Fatema hassan", commentTime: Date(timeIntervalSince1970: 23123124343), commentText: "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz")
//
//        comments.append(comment1)
//        comments.append(comment2)
//        comments.append(comment3)
//        comments.append(comment4)
//        comments.append(comment5)
//        comments.append(comment6)
//
//        commentCollectionView.reloadData()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .random
        commentCollectionView.backgroundColor = .clear
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Auction", preferredLargeTitle: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        view.addSubview(numberOfViewersView)
        numberOfViewersView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, width: 100)
        
        
        view.addSubview(highestBidderInfoView)
        highestBidderInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        
        itemInfoButton.setDimensions(height: 55, width: 55)
        itemInfoButton.layer.cornerRadius = 55/2
        bidderInfoButton.setDimensions(height: 55, width: 55)
        bidderInfoButton.layer.cornerRadius = 55/2
        
        let buttonStack = UIStackView(arrangedSubviews: [itemInfoButton, bidderInfoButton])
        buttonStack.axis = .vertical
        buttonStack.alignment = .center
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 8
        
        view.addSubview(buttonStack)
        buttonStack.anchor(top: highestBidderInfoView.bottomAnchor, right: highestBidderInfoView.rightAnchor, paddingTop: 19)
        
    }
    
    
    func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        
        let blurView = UIVisualEffectView()
        blurView.setDimensions(height: 55, width: 55)
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.layer.cornerRadius = 55/2
        blurView.isUserInteractionEnabled = false
        
        button.insertSubview(blurView, at: 0)

        button.clipsToBounds = true
        
        return button
    }
}

//MARK: - Delegate GrowingTextViewDelegate
extension BiddingStoryController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension BiddingStoryController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingLiveCommentCell.reuseIdentifier, for: indexPath) as! BiddingLiveCommentCell
        cell.comment =  comments[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension BiddingStoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

//MARK: - Delegate BiddingCellAddBidViewDelegate
extension BiddingStoryController: BiddingCellAddBidViewDelegate {
    func addBidView(_ addBidView: BiddingCellAddBidView, didBidWithAmount amount: Double, forItem item: BidItem) {
        dismissPicker()
    }
}
