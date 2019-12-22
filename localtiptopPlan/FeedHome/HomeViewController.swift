//
//  HomeViewController.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    //一：创建user和posts array的信息储存库。
    var users = [User]()
    var posts = [PostModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activitiIndicatorView: UIActivityIndicatorView!//loading 的小圈圈
    
    // MARK: -View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)//不显示tableView的横线条。
        loadPosts()
    }
    
    //MARK：-LoadPost
    func loadPosts() {//二：👇把firebase内的posts和user内容分别取出来，并且分别放入posts和users的信息储存库中。
        activitiIndicatorView.startAnimating()
              let refDatabasePosts = Database.database().reference().child("posts")
              
              refDatabasePosts.observe(.childAdded) { (snapshot) in
                  guard let dic = snapshot.value as? [String: AnyObject] else { return }
                  let newPost = PostModel(dictionary: dic, key: snapshot.key)
                  
                  guard let userUid = newPost.uid else { return }
                  self.fetchUser(uid: userUid, completed: {
                    self.tableView.setContentOffset(CGPoint.zero, animated: true)
                    //self.posts.append(newPost)//把每次得到的内容加入到 var posts = [PostModel]() 的尾部。
                    self.posts.insert(newPost, at: 0) //把每次得到的内容加入到 var posts = [PostModel]() 的起首部。
                    self.activitiIndicatorView.stopAnimating()
                    self.tableView.reloadData()
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
                  //self.users.append(newUser)
                  completed() // Der Block { } welcher als Parameter an fetchUser() übergeben wird, wird an dieser Stelle aufgerufen
              }
          }//👆把firebase内的posts和user内容取出来，并且放入posts和users的信息储存库中。
    


    //MARK: -HOME LogoutButton tapped
    //👇按下logout时启用Google firebase的auth().signOut功能推出当前用户，并且回到login画面。
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        AuthenticationService.logOut(onSuccess: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                    self.present(loginVC, animated: true, completion: nil)
        }) { (error) in
            print(error!)
        }
    }//👆按下logout时启用Google firebase的auth().signOut功能推出当前用户，并且回到login画面。
    
    
        var post: PostModel?
        var user: User?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentTableViewCellSegue" {
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.post = self.post
            commentViewController.user = self.user
        }else if segue.identifier == "ContraCommentTableViewCellSegue" {
            let contraCommentViewController = segue.destination as! ContraCommentViewController
            contraCommentViewController.post = self.post
            contraCommentViewController.user = self.user
        }
    }
}

// MARK: -TableView Datasoruce
//👇把本HomeViewcControlle数据传到HomeTableViewCell
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("counter is \(posts.count)")
        return posts.count
    }
    //三：得到要显示出储存内容的那一页：let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
    
    //三（一）：然后把每次得到的users和posts（此时已经获得firebase内容）赋值给cell.user和cell.posts, cell就是：HomeTableViewCell的地址。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = posts[indexPath.row]
        cell.user = users[indexPath.row]
        
        cell.delegate = self //cell所代表的HomeTableViewCell里面的的东西要在本VC内解决。
        return cell
    }
}
//👆把本HomeViewcControlle数据传到HomeTableViewCell

//MARK：-delegate
extension HomeViewController: HomeTableViewCellDelegate{
    func didTapContraCommentImageView(post: PostModel, user: User) {
        self.post = post
        self.user = user
               
        performSegue(withIdentifier: "ContraCommentTableViewCellSegue", sender: nil)
    }
    
    func didTapCommentImageView(post: PostModel, user: User) {
        self.post = post
        self.user = user
        
        performSegue(withIdentifier: "CommentTableViewCellSegue", sender: nil)
    }
}

