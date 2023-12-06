//
//  CommentController.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/03/21.
//

import UIKit
import GrowingTextView
import SwipeCellKit
import JGProgressHUD

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    var hud = JGProgressHUD(style: .dark)
    
    var postId: String
    var isOwner: Bool
    
    var comments = [Comment]()
    
    var selectedReplyComment: Comment?
    //MARK: - UI Elements
    private var inputToolbar: UIView!
    private var textView: GrowingTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send_message").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(height: 35, width: 35)
        
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    init(forPostWithId postId: String) {
        self.postId = postId
        self.isOwner = false
        if let loggedUser = loggedInUser {
            self.isOwner = postId == loggedUser.id
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTextBar()
        Utility.openScreenView(str_screen_name: "Comment", str_nib_name: self.nibName ?? "")

        navigationItem.title = appDele!.isForArabic ? Comments_ar : Comments_en

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.reuseIdentifier)
        collectionView.register(CommentChildCell.self, forCellWithReuseIdentifier: CommentChildCell.reuseIdentifier)
        
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        
        fetchComments {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.comments.count - 1), at: .bottom, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Selectors
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
    }
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }

    @objc func handleSend() {
        guard textView.hasText else { return }
        guard var commentText = textView.text else { return }
        
        commentText = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let selectedReplyComment = selectedReplyComment {
            Service.shared.addComment(toPostWithId: postId, comment: commentText, parentCommentId: selectedReplyComment.id) { (status) in
                if status {
//                    self.showAlert(withMsg: "Comment Posted Successfully!")
                    self.fetchComments()
                } else {
                    self.showAlert(withMsg: "Failed to Post Comment!")
                }
                
                self.textView.text = ""
                self.textView.resignFirstResponder()
                self.fetchComments()
            }
        } else {
            Service.shared.addComment(toPostWithId: postId, comment: commentText) { (status) in
                if status {
//                    self.showAlert(withMsg: "Comment Posted Successfully!")
                } else {

                }
                
                self.textView.text = ""
                self.textView.resignFirstResponder()
                self.fetchComments()
            }
        }
        textView.resignFirstResponder()
    }
    
    //MARK: - API
    func fetchComments(completion: (() -> Void)? = nil) {
        hud.show(in: view, animated: true)
        Service.shared.getComments(forPostWithId: postId) { (allComments, status, message) in
            if status {
                guard let comments = allComments else { return }
                self.comments.removeAll()
                self.comments = comments
                self.collectionView.reloadData()
                self.hud.dismiss(animated: true)
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureTextBar() {
        // *** Create Toolbar
        inputToolbar = UIView()
        inputToolbar.backgroundColor = .white
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputToolbar)
        
        
        
        // *** Create GrowingTextView ***
        textView = GrowingTextView()
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        textView.backgroundColor = UIColor.hex("#D7D8DB")
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = appDele!.isForArabic ? "أضف تعليقًا.." : "Add a comment..."
        textView.textAlignment = appDele!.isForArabic ? .right : .left
        textView.placeholderColor = UIColor.black.withAlphaComponent(0.65)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputToolbar.addSubview(textView)
        
        // *** Autolayout ***
        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topConstraint
        ])
        

        if #available(iOS 11, *) {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -53),
                textViewBottomConstraint
                ])
        } else {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -53),
                textViewBottomConstraint
                ])
        }
        
        inputToolbar.addSubview(sendButton)
        sendButton.anchor(right: inputToolbar.rightAnchor, paddingRight: 8)
        sendButton.centerY(inView: textView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: inputToolbar.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - DataSource UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments[section].childComments.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
            cell.comment =  comments[indexPath.section]
            
            if isOwner {
                cell.delegate = self
            }
            
            cell.commentCelldelegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentChildCell.reuseIdentifier, for: indexPath) as! CommentChildCell
            cell.comment =  comments[indexPath.section].childComments[indexPath.row - 1]
            cell.commentCelldelegate = self
            if isOwner {
                cell.delegate = self
            }
            return cell
        }
    }
}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


//MARK: - Delegate GrowingTextViewDelegate
extension CommentController:  GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        selectedReplyComment = nil
        self.textView.placeholder = appDele!.isForArabic ? "أضف تعليقًا.." : "Add a comment..."
    }
}

extension CommentController: CommentCellDelgate {
    func didTapProfile(forComment comment: Comment, cell: CommentCell) {
        guard let comment = cell.comment else { return }
//        let controller = UserProfileController(forUserId: comment.owner.id)
        let obj = OtherProfileVC()
        obj.userId = comment.owner.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func didTapLike(forComment comment: Comment, cell: CommentCell) {
        if comment.liked {
            Service.shared.dislikeComment(forComment: comment) { (status) in
                self.fetchComments()
            }
        } else {
            Service.shared.likeComment(forComment: comment) { (status) in
                self.fetchComments()
            }
        }
    }
    
    func didTapReply(forComment comment: Comment, cell: CommentCell) {
        textView.placeholder = "Reply to \(comment.owner.fullName)"
        textView.becomeFirstResponder()
        selectedReplyComment = comment
        
        let index = collectionView.indexPath(for: cell)!
        collectionView.scrollToItem(at: index, at: . centeredVertically, animated: true)
    }
    
    func didTapDelete(forComment comment: Comment, cell: CommentCell) {
        Service.shared.deleteComment(withCommentId: comment.id) { (status) in
            if status {
                self.fetchComments()
            } else {

            }
        }
    }
}

extension CommentController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let cell = collectionView.cellForItem(at: indexPath)! as! CommentCell
            guard let comment = cell.comment else { return }
            
            self.didTapDelete(forComment: comment, cell: cell)
        }

        let iv = UIImageView(image: #imageLiteral(resourceName: "trash").withRenderingMode(.alwaysTemplate))
        iv.tintColor = .white
        
        // customize the action appearance
        deleteAction.image = iv.image
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
}
