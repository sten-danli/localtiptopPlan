//
//  ShareViewController.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
class ShareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    
    
    // MARK: - var / let
    var selectedImage: UIImage?
    
    
    // MARK: - View Lifycylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Share"

        addTapGestureToImageView()
        handleShareAndAbortButton()
    }
    
    // MARK: View stuff
    func handleShareAndAbortButton() {
        shareButton.isEnabled = false
        abortButton.isEnabled = false
        
        let attributeShareButtonText = NSAttributedString(string: shareButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        let attributeAbortButtonText = NSAttributedString(string: abortButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        
        shareButton.setAttributedTitle(attributeShareButtonText, for: .normal)
        abortButton.setAttributedTitle(attributeAbortButtonText, for: .normal)
    }
    
    func imageDidChange() {
            shareButton.isEnabled = true
            abortButton.isEnabled = true
            
            let attributeShareButtonText = NSAttributedString(string: shareButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
            let attributeAbortButtonText = NSAttributedString(string: abortButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
            
            shareButton.setAttributedTitle(attributeShareButtonText, for: .normal)
            abortButton.setAttributedTitle(attributeAbortButtonText, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    // MARK: Choose post photo
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.cropRect] as? UIImage {
            postImageView.image = editImage
            selectedImage = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            postImageView.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
        imageDidChange()
    }
    
    
    // MARK: Post
    //👇从这里开始：但按下shareButton时，上转照片和文字到storege 和 database
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Lade...", interaction: false)
        
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let imageRatio = image.size.width / image.size.height
        let uuid = NSUUID().uuidString // Jedes Foto erhält seine einmalige UUID
        
        let storageRef = Storage.storage().reference().child("posts").child(uuid)//在Storegpost下面生成子文件：posts.uuid(uuid是自动生成的id)，
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in//然后在这posts.uuid下面存入当前图片。
            if error != nil {
                ProgressHUD.showError("Fehler, Bild kann nicht hochgeladen werden")
                return
            }
            storageRef.downloadURL(completion: { (url, error) in//当图片成功存入Storeg的posts.uuid后，把当前图片的url取出（用来存入到Database）
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let postsImageUrlString = url?.absoluteString //把成功存入storeg图片的imageurl取出并交给postsImageUrlString，
                self.uploadDataToDatabase(imageUrl: postsImageUrlString ?? "Kein Bild vorhanden", imageRatio: imageRatio)//然后放入到 database的"posts"中。
            })
        }
    }
    
    func uploadDataToDatabase(imageUrl: String, imageRatio: CGFloat) {
        //👇得到当前时间
        let timestamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSinceNow: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyy"
        dateFormatter.timeZone = TimeZone.current
        print(dateFormatter.string(from: date))
        //👆得到当前时间
        
        let databaseRef = Database.database().reference().child("posts")//找到Database地址，在地址尾部加入分支posts，
        let newPostId = databaseRef.childByAutoId().key//然后创建新的key，
        let newPostRefernce = databaseRef.child(newPostId!) //然后在posts的key中
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let dictionary = ["uid": uid,"imageUrl" : imageUrl, "postText" : postTextView.text, "postTime" : dateFormatter.string(from: date), "imageRatio": imageRatio] as [String : Any]//存入imageUrl 和 postText //将来加入时间
        newPostRefernce.setValue(dictionary) { (error, ref) in
            if error != nil {
                ProgressHUD.showError("Fehler, Daten konnten nicht hochgeladen werden")
                return
            }
            ProgressHUD.showSuccess("Post erstellt")
            self.remove()// share button 重新变成不能按下状态。
            self.handleShareAndAbortButton()//share完后share和abbort button 返回不可按下状态。
            self.tabBarController?.selectedIndex = 0 //share完后直接返回feed页面。
        }
    }
    //👆到这里为止：上转照片和文字到storege 和 database 结束。
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        remove()
        handleShareAndAbortButton()
    }
    
    func remove() {
        selectedImage = nil
        postTextView.text = ""
        postImageView.image = UIImage(named: "placeholder")
    }
}
