//
//  SearchVC.swift
//  localtiptopPlan
//
//  Created by Dan Li on 10.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SearchUserCell"

class SearchVC: UITableViewController {

    // MARK: -Properties
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register cell classes
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // separator insets TableView中每个cell之间的灰色线条
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        configureNavController()
        
        // fetch user
        fetchUsers()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        // create instance of user profile vc
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
    
        // pass user from searchVC to userProfile
        userProfileVC.userToloadFromSearchVC = user
        
        //push view controller
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func configureNavController(){
        navigationItem.title = "Explore"
    }

    // MARK: -FetchUsers
    
    func fetchUsers(){
        
        Database.database().reference().child("users").observe(.childAdded) {(snapshot) in
            print("snapshot in func fetchUsers is \(snapshot)")
            // uid
            let uid = snapshot.key
            
            //snapshot value cast as dictionary
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            
            //construct user
            let user = User(uid: uid, dictionary: dictionary)
            
            // append user to data source
            self.users.append(user) //我们把snapshot出来的所有东西都放入users[]里面去。
            
            //reload our table view， 开始运行s这也是users.count是空的，因为此时var users = [User]()是空的，这时候程序运行到func fetchUsers()
            //得到snapshot内容然后执行tableView.reloadData(），通过reload， var users = [User]()将会刷新并得到新的snapsho里面的内容。
            self.tableView.reloadData()
            
        }
    }
}
