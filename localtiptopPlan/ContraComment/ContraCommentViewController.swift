//
//  ContraCommentViewController.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.12.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContraCommentViewController: UIViewController {

     @IBOutlet weak var tableView: UITableView!
        
        @IBOutlet weak var commenProfilFoto: UIImageView!
        @IBOutlet weak var commenTextField: UITextField!
        @IBOutlet weak var sendButton: UIButton!
        @IBOutlet weak var postImagView: UIImageView!
        
        @IBOutlet weak var postImagBottomConstraint: NSLayoutConstraint!
        @IBOutlet weak var bottomConstraint: NSLayoutConstraint!//打字输入框的底线链接，让打字框不被减半掩盖掉。
        
        // MARK: -var / let
        var comments = [ContraCommentModel]()//把 loadComments() 取出的comments存入到这里。
        var users = [User]()
        
        var post: PostModel?
        var user: User?

        override func viewDidLoad() {
            super.viewDidLoad()
        
            tableView.dataSource = self
            setupPostImg()
            fetchCurrentUserDataAndSetCurrenUserProfilImage()//用户打字框左侧的current用户图标。
            loadComments()
            addTrgetToTextField()
            empty()
            commenProfilFoto.layer.cornerRadius = commenProfilFoto.frame.width/2
            
            //👇探索打字框当用户点击打字框时，应该发生什么：1.在#selector内执行keyboardWillShow(_:)意思是键盘向上跳出，2.@objc func keyboardWillShow（）里面代码意思是：此时让输入文字框同时随着跳上来的键盘升高，这样文字输入框就不会被键盘挡住。
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            // MARK: - Keyboard stuff
           @objc func keyboardWillShow(_ notification: NSNotification) {
               let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
               UIView.animate(withDuration: 0.1) {
                   self.bottomConstraint.constant = keyboardFrame!.size.height
                   self.view.layoutIfNeeded()
                }
            }
            //还有keyboardWillHide（）是指键盘放下去时让打字输入框的底线链接返回最底下，值为0.
           @objc func keyboardWillHide(_ notification: NSNotification) {
               UIView.animate(withDuration: 0.2) {
                   self.bottomConstraint.constant = 0
                   self.view.layoutIfNeeded()
               }
           }
        //👆探索打字框当用户点击打字框时，应该发生什么：1.在#selector内执行keyboardWillShow(_:)意思是键盘向上跳出，2.@objc func keyboardWillShow（）里面代码意思是：此时让输入文字框同时随着跳上来的键盘升高，这样文字输入框就不会被键盘挡住。
        
        func setupPostImg(){
            guard let postImgUrl = post?.imageUrl else {
                return
            }
            postImagView.loadImage(with: postImgUrl)
            print("postimag is:", postImgUrl)
            self.view.reloadInputViews()
            
        }
        
        override func awakeFromNib() {
               super.awakeFromNib()
               setupPostImg()
           }
        //👇探索文字输入框内是否有文字。
        func addTrgetToTextField(){
            commenTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        }
        
        @objc func textFieldDidChange() {
            let isText = commenTextField.text?.count ?? 0 > 0
            //如果有文字
            if isText {
               sendButton.setImage(UIImage.init(named: "bazingal"), for: .normal)
                sendButton.isEnabled = true
            } else {
                sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
                sendButton.isEnabled = false
            }
        }
        //👆探索文字输入框内是否有文字。
        
        //👇当用户输入完文字后，文字框内为空，sendButton变为false，颜色为暗色。
        func empty(){
            commenTextField.text = ""
            sendButton.isEnabled = false
            sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
        }
        //👆当用户输入完文字后，文字框内为空，sendButton变为false，颜色为暗色。
        
        
        //👇进入comment届面时tabBar隐藏。
        override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(animated)
               tabBarController?.tabBar.isHidden = true
           }
        //👇推出comment界面时tabBar再次显示。
           override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               tabBarController?.tabBar.isHidden = false
           }
        
        //👇当按下sendButton时键盘消失执行 empty()复原键盘原始状态。
        @IBAction func sendButtonTapped(_ sender: UIButton) {
            creatComment()
        }
        //👆当按下sendButton时键盘消失执行 empty()复原键盘原始状态。
        
    // MARK：-Creat Comment
        func creatComment(){
            let refDatabase = Database.database().reference()
            let refComments = refDatabase.child("contracomments")
            guard let commentId = refComments.childByAutoId().key else {return}
            
            let newCommentRef = refComments.child(commentId)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            
            let dic = ["uid": uid, "contracommenttext": commenTextField.text!] as [String : Any]
            newCommentRef.setValue(dic) { (error, ref) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                }
                
                guard let postId = self.post?.id else{ return }
                let postCommenRef = Database.database().reference().child("contrapostcomments").child(postId).child(commentId)
                postCommenRef.setValue(true, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    self.view.endEditing(true)
                    self.empty()
                })
            }
        }
        
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
        
    // MARK: - load comments
        //👇1.取出每个post的comments，存入var comments = [CommentModel]()。
          //2.并用fetchUser取出current出发post的那个user的信息。
        func loadComments() {
            guard let postId = post?.id else { return }//得到当前post的id，
            let postCommentRef = Database.database().reference().child("contrapostcomments").child(postId)//并取出当前postId下所有的commentsID
         
            postCommentRef.observe(.childAdded) { (snapshot) in//存入到snapshot中，
                let commentRef = Database.database().reference().child("contracomments").child(snapshot.key)//然后在firebase “comments”中把对应commentsID的内容取出来，
                commentRef.observeSingleEvent(of: .value, with: { (snapshot) in//放入snapshot里面，
                    guard let dic = snapshot.value as? [String: Any] else { return }//snapshot存入dic中，
                    let newComment = ContraCommentModel(dictionary: dic)//dic用CommentModel解释并存入newComment中。
                    
                    guard let userUid = newComment.uid else { return }
                    self.fetchUser(uid: userUid, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                })
            }
        }
         //2.👇用fetchUser取出current出发post的那个user的信息。
        func fetchUser(uid: String, completed: @escaping () -> Void) {
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            let newUser = User(uid: uid, dictionary: dic)
            self.users.append(newUser)
            completed()
            }
            //👆用fetchUser取出current出发post的那个user的信息。
        }
        //👆取出每个ppost的comments，存入var comments = [CommentModel]()，并用fetchUser取出current出发post的那个user的信息。
        
    //MARK：-得到当前用户的ProfilFoto并赋给commenProfilFoto。
        func fetchCurrentUserDataAndSetCurrenUserProfilImage(){
            
            guard let currentUid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
                let uid = snapshot.key//和currentUid是一样的
                let user = User(uid: uid, dictionary: dictionary)
                guard let commenProfilFotoUrl = user.profilimageUrl else {return}
                self.commenProfilFoto.loadImage(with: commenProfilFotoUrl)
           }
        }
    }

    extension ContraCommentViewController: UITableViewDataSource, UITableViewDelegate{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return comments.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContraCommentTableViewCell", for: indexPath) as! ContraCommentTableViewCell
        
            cell.comment = comments[indexPath.row]
            cell.user = users[indexPath.row]
            return cell
            
        }
    }

