//
//  ViewController.swift
//  demo2-LoginFacebook
//
//  Created by Minh Thanh on 7/9/19.
//  Copyright © 2019 Minh Thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    var listAccount:[(username:String,password:String)] = [(username: "Thanh", password: "123"),(username: "Tuan", password: "456")]
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserName.placeholder =   "Số điện thoại hoặc email"
        txtPassWord.placeholder =   "Mật khẩu"
        txtPassWord.isSecureTextEntry   =   true
        txtUserName.clearButtonMode =   .always
        txtPassWord.clearButtonMode =   .always
        btnLogin.layer.borderWidth  =   0.5
        btnLogin.layer.cornerRadius =   8
        btnRegister.layer.borderWidth  =   0.5
        btnRegister.layer.cornerRadius =   8
        
        if let username =   UserDefaults.standard.string(forKey: "username"), let password = UserDefaults.standard.string(forKey: "password"){
            
            listAccount.append((username: username, password: password))
            print(listAccount)
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let userName    =   txtUserName.text!
        let passWord    =   txtPassWord.text!
        if !userName.isEmpty && !passWord.isEmpty{
//            if userName == listAccount[0].username && passWord  ==  listAccount[0].password{
//                nextScreen()
//            }else{
//                alert(title: "Tài khoản hoặc mật khẩu chưa đúng")
//            }
            
            
            
        }else{
            alert(title: "Tên đăng nhập hoặc mật khẩu trống")
        }
    }
    
    
    func alert(title:String){
        let alert   =   UIAlertController(title: "Thông báo", message: title, preferredStyle: .alert)
        let btnOk   =   UIAlertAction(title: "OK", style: .default) { (ok) in}
        alert.addAction(btnOk)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func btnRegister(_ sender: Any) {
        nextScreen()
    }
    func nextScreen(){
        let sb  =   UIStoryboard(name: "Main", bundle: nil)
        let nextSb  =   sb.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        present(nextSb, animated: true, completion: nil)
    }
    
}

