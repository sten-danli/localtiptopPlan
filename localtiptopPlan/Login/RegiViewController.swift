//  RegiViewController.swift
//  localtiptopPlan
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage : UIImage?
    
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var haveAnAccountButton: UIButton!//最下方"Du hast einen Account? Login“的那行字。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        addTargetToTextField()
        
        addGestureToimageView()
     
    }
    //让键盘掉下去的方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupView(){
        //用户圆形效果图效果
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        profilImageView.layer.borderColor = UIColor.white.cgColor
        profilImageView.layer.borderWidth = 2
        
        //刚开始显示画面 createAccountButton 不可，一直到画usernameTextField，emailTextField 和 passwordTextField 三个框内都添上内容的情况让 createAccountButton 高亮。
        createAccountButton.isEnabled =  false
        
        //👇haveAnAccountButton最下面的“Du hast einen Account?Du hast einen Account?”login 粗体效果显示。
        let attributeText = NSMutableAttributedString(string: "Du hast einen Account?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white])
        attributeText.append(NSMutableAttributedString(string: " " + "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white]))
        haveAnAccountButton.setAttributedTitle(attributeText, for: UIControl.State.normal)
        //👆haveAnAccountButton最下面的“Du hast einen Account?Du hast einen Account?”login 粗体效果显示。
    }
    
    //👇只有在：usernameTextField，emailTextField 和 passwordTextField 三个框内都添上内容的情况让 createAccountButton 高亮的功能。
    func addTargetToTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
    @objc func textFieldDidChange() {
        let isText = usernameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
            
        if isText {
            createAccountButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.backgroundColor = UIColor(white: 0.8, alpha: 0)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = false
        }
        //👆只有在：usernameTextField，emailTextField 和 passwordTextField 三个框内都添上内容的情况让 createAccountButton 高亮的功能。
    }
    
     //👇激活点击iamgevView更换用户招照片的方法。
    func addGestureToimageView(){
        //激活点击屏幕上的“profilImageView”。
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilPhoto))
        profilImageView.addGestureRecognizer(tapGesture)
        profilImageView.isUserInteractionEnabled = true
    }
    //激活后做什么，允许pickerController照片改动，例如放大或缩小。
    @objc func handleSelectProfilPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //如果用户修改了照片。
        if let editImage = info[.cropRect] as? UIImage{
            profilImageView.image = editImage
            selectedImage = editImage
        }else if let originalImage = info[.originalImage] as? UIImage{
        //如果用户未修改照片。
            profilImageView.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    //👆点击iamgevView更换用户招照片
    }
    
    //返回Login画面.//最下方"Du hast einen Account? Login“的那行字是个Button。
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    //MARK: -👇按下Account erstellen 新用户注册和用户照片注册和存储到firebase
    @IBAction func createButtonTapped(_ sender: UIButton) {
        
        if selectedImage == nil{
            print("Bitte Foto wählen")
            return
        }
        
        guard let image = selectedImage else {return}
        guard let imageData = image.jpegData(compressionQuality: 0.1)else{return}
        
        
        AuthenticationService.createUser(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }) { (error) in
            print(error!)
        }
        
//        //建立新用户
//        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            }
//             print("User mit der Email :",data?.user.email ?? "")
//            //如果建立成功便取出新用户uid
//            guard let newUser = data?.user else{return} //然后把data内的user用newUser接住
//            let uid = newUser.uid//把uid取出
//            //👆到这一步将emailTextField，passwordTextField 的内容读到Auth，然后最后得到newUser的uid。
//
//            //uploadUserData是一个自己写的func的实现，具体方法内容在下面。
//            self.uploadUserData(uid: uid, username: self.usernameTextField.text!, email: self.emailTextField.text!)
//        }
//    }
//
//    func uploadUserData(uid : String, username : String, email : String){
//    //👇整个这一步的作用就是把用户照片输入到storegeRef，然后再从里面把输入照片的uid取出。
//        let storageRef = Storage.storage().reference().child("profil_image").child(uid)//找到databank中storeg地址，这是我们存放user “profilImageView”图片的地址，并创建profil_image文件。
//        guard let image = selectedImage else {return}//var selectedImage：UIImage？得到修改后的用户照片。
//        guard let uploadData = image.jpegData(compressionQuality: 0.1) else {return}//用户照片质量设定
//
//        storageRef.putData(uploadData, metadata: nil) { (metadata, error ) in //把用户照片存入Storage
//            if let err = error{
//                print(err.localizedDescription)
//                return
//            }
//            //👇把照片从storege取出来转换成url交给profilImageUrlString
//            storageRef.downloadURL { (url, error) in
//                if let err = error{
//                    print(err.localizedDescription)
//                    return
//                }
//                let profilImageUrlString = url?.absoluteString
//            //👆把照片从storege取出来p转换成url交给profilImageUrlString
//    //👆到这里，整个这一步的作用就是把用户照片输入到storegeRef，然后再从里面把输入照片的uid取出。
//
//               //得到database用户地址：用child建立一个叫user的datenbank， 然后再child一个uid在user下面。
//                let ref = Database.database().reference().child("users").child(uid)
//                print("Databank Adresse: ", ref)
//                 //每输入一个新的用户，就会在在ref（datenbank地址）的user下建立一个新的uid，存放新输入的username，email 和 passwordh 还有profilImageString。//setValue就是把本地内容上到datenbank ref的方法。
//                ref.setValue(["username" : self.usernameTextField.text!, "email" : self.emailTextField.text!, "password" : self.passwordTextField.text!, "profilImageUrl" : profilImageUrlString])
//
//                //当用户资料全部存入firebase中后，顺着“registerSegue“的链接进入HomeViewController。
//                 self.performSegue(withIdentifier: "registerSegue",sender: nil)
//            }
//        }
   
    }
}
