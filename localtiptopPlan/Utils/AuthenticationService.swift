//  AuthenticationService.swift
//  localtiptopPlan
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthenticationService {
    //MARK: -Einloggen
    static func signIn(eMail: String, password: String, onSuccess: @escaping ()->Void, onError: @escaping (_ error: String?)->Void){
        Auth.auth().signIn(withEmail: eMail, password: password) { (data, error) in
            if let err = error{
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //MARK: -LogOut
    
    static func logOut(onSuccess:@escaping()->Void, onError:@escaping(_ error:String?)->Void){
        do {
                try  Auth.auth().signOut()//firebase的auth().signOut功能调用
            } catch let logoutError {
                onError(logoutError.localizedDescription)
            }
        onSuccess()
    }
    
    //MARK: -Automatisches Einloggen
    static func automaticSingIn(onSuccess : @escaping ()->Void){
        if Auth.auth().currentUser != nil{
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
                onSuccess()
                })
            }
        }
    }
    
    //MARK: -Create new User
    static func createUser(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping ()->Void, onError: @escaping (_ error: String?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let err = error{
                onError(err.localizedDescription)
                return
            }
            //user erfolgreich erstellt
            guard let uid = data?.user.uid else {return}
            self.uploadUserData(uid: uid, username: username, email: email, password: password, imageData: imageData, onSuccess: onSuccess)
        }
    }
    
    //MARK: -Upload User info
    static func uploadUserData(uid : String, username : String, email : String, password : String, imageData: Data, onSuccess: @escaping ()->Void){
     
         let storageRef = Storage.storage().reference().child("profil_image").child(uid)
         storageRef.putData(imageData, metadata: nil) { (metadata, error ) in
             if error != nil{return}
            
            storageRef.downloadURL { (url, error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
            }
                let profilImageUrlString = url?.absoluteString
                let ref = Database.database().reference().child("users").child(uid)
                ref.setValue(["username" : username, "email" : email, "password" : password, "profilImageUrl" : profilImageUrlString])
                onSuccess()
             }
         }
     }
}

