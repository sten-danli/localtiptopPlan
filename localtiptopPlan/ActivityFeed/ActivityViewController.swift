//
//  ActivityViewController.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol PinterestDelegate: class {
    func collectionView(_ collectionView: UICollectionView, numberOfColumns: Int, heightForPhotoAtIndexPath indexPath: IndexPath)  -> CGFloat
}


class ActivityViewController: UICollectionViewController {
     //一：创建user和posts array的信息储存库。
    var users = [User]()
    var posts = [PostModel]()

    @IBOutlet var collection: UICollectionView!
   
    
    
    fileprivate var images: [String] = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6","7","8","9","10","11","12","13","14"
    ]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadPosts()
            let layout = PinterestLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            self.collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
            self.collection.backgroundColor = .white
            self.collection.register(ActivityCell.self, forCellWithReuseIdentifier: "CELL")
            
            collection.alwaysBounceVertical = true
            collection.dataSource = self
            
            if let layout = collection.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            }
            
           view.addSubview(collection)
        }
    
    //MARK：-LoadPost
       func loadPosts() {//二：👇把firebase内的posts和user内容分别取出来，并且分别放入posts和users的信息储存库中。
                 let refDatabasePosts = Database.database().reference().child("posts")
                 
                 refDatabasePosts.observe(.childAdded) { (snapshot) in
                     guard let dic = snapshot.value as? [String: AnyObject] else { return }
                     let newPost = PostModel(dictionary: dic, key: snapshot.key)
                     
                     guard let userUid = newPost.uid else { return }
                     self.fetchUser(uid: userUid, completed: {
                     self.posts.insert(newPost, at: 0)
                     self.collection.reloadData()
                     })
                 }
             }
             // MARK: - Fetch Users
             func fetchUser(uid: String, completed: @escaping () -> Void) {
                 let refDatabaseUser = Database.database().reference().child("users").child(uid)
                 refDatabaseUser.observe(.value) { (snapshot) in
                     guard let dic = snapshot.value as? [String: AnyObject] else { return }
                     let newUser = User(uid: uid, dictionary: dic)
                     self.users.insert(newUser, at: 0)
                     completed()
                 }
             }//👆把firebase内的posts和user内容取出来，并且放入posts和users的信息储存库中。
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("image counter: ",posts.count)
        return posts.count
        }
       
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                   let cell = collection.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! ActivityCell
//                   let image = UIImage(named: self.images[indexPath.row])
//                   cell.image = image
                   cell.post = posts[indexPath.row]
                   cell.user = users[indexPath.row]
                   return cell
               }

    }
    //设定图片高度ratio比率。
    extension ActivityViewController: PinterestDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfColumns: Int, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var image : UIImage? = nil
//        let image = UIImage(named: self.images[indexPath.item])!
        if let imageString = posts[indexPath.row].imageUrl{
            if let imagUrl = URL.init(string: imageString){
                do{
                    let data = try Data.init(contentsOf: imagUrl)
                   image = UIImage(data: data)
                }catch{
                    
                }
            }
        }
       
        let imageHight = image?.size.height
        let imageWidth = image?.size.width
        let columnRatio: CGFloat = 1/CGFloat(numberOfColumns)
        let imageSizeRadio = (collectionView.frame.width * columnRatio) / imageWidth!

        return (imageHight ?? 200) * imageSizeRadio
        }
    }



