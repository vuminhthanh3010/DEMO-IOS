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
    }
    
    // click button login
    @IBAction func btnLogin(_ sender: Any) {
        let userName    =   txtUserName.text!
        let passWord    =   txtPassWord.text!
        if !userName.isEmpty && !passWord.isEmpty{
            if let checkPass    =   UserDefaults.standard.string(forKey: userName),checkPass==passWord{
                let alert   =   UIAlertController(title: "Thông báo", message: "Bạn đã đăng nhập thành công", preferredStyle: .alert)
                let btnOk   =   UIAlertAction(title: "OK", style: .default) { (ok) in
                    let sb  =   UIStoryboard(name: "Main", bundle: nil)
                    let nextSb  =   sb.instantiateViewController(withIdentifier: "show") as! ShowAccountViewController
                    UserDefaults.standard.set(userName, forKey: "showUserName")
                    UserDefaults.standard.set(passWord, forKey: "showPassWord")
                    UserDefaults.standard.synchronize()
                    self.present(nextSb, animated: true, completion: nil)
                }
                alert.addAction(btnOk)
                present(alert, animated: true, completion: nil)
            }else{
                alert(title: "Tài khoản hoặc mật khẩu chưa đúng")
            }
        }else{
            alert(title: "Tên đăng nhập hoặc mật khẩu trống")
        }
    }
    
    // click button register
    @IBAction func btnRegister(_ sender: Any) {
        nextScreen()
    }
    
    // alert notification
    func alert(title:String){
        let alert   =   UIAlertController(title: "Thông báo", message: title, preferredStyle: .alert)
        let btnOk   =   UIAlertAction(title: "OK", style: .default) { (ok) in}
        alert.addAction(btnOk)
        present(alert, animated: true, completion: nil)
    }

    // next storybroad
    func nextScreen(){
        let sb  =   UIStoryboard(name: "Main", bundle: nil)
        let nextSb  =   sb.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        present(nextSb, animated: true, completion: nil)
    }
    
}

