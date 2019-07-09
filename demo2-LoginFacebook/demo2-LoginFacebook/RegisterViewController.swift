//
//  RegisterViewController.swift
//  demo2-LoginFacebook
//
//  Created by Minh Thanh on 7/9/19.
//  Copyright © 2019 Minh Thanh. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtUserNameRegister: UITextField!
    @IBOutlet weak var txtPassWordRegister: UITextField!
    @IBOutlet weak var txtComfirmPassWordRegister: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserNameRegister.placeholder =   "Số điện thoại hoặc email"
        txtUserNameRegister.clearButtonMode =   .always
        txtPassWordRegister.placeholder =   "Mật khẩu"
        txtPassWordRegister.clearButtonMode =   .always
        txtPassWordRegister.isSecureTextEntry   =   true
        txtComfirmPassWordRegister.placeholder  =   "Nhập lại mật khẩu"
        txtComfirmPassWordRegister.clearButtonMode =   .always
        txtComfirmPassWordRegister.isSecureTextEntry    =   true
        btnRegister.layer.cornerRadius  =   8
        btnRegister.layer.borderWidth   =   0.5
        
    }
    
    @IBAction func btnBackHome(_ sender: Any) {
        nextScreen()
    }
    @IBAction func btnRegister(_ sender: Any) {
            let userNameRegister             =   txtUserNameRegister.text!
            let passWordRegister             =   txtPassWordRegister.text!
            let comfirmpPassWordRegister     =   txtComfirmPassWordRegister.text!
            
            if !userNameRegister.isEmpty && !passWordRegister.isEmpty && !comfirmpPassWordRegister.isEmpty{
                if passWordRegister  == comfirmpPassWordRegister{
                    UserDefaults.standard.set(userNameRegister, forKey: "username")
                    UserDefaults.standard.set(passWordRegister, forKey: "password")
                    UserDefaults.standard.synchronize()
                    nextScreen()
                    
                    
                }else{
                    alert(title: "Mật khẩu không khớp, vui lòng nhập lại")
                }
                
            }else{
                alert(title: "Tên đăng nhập hoặc mật khẩu trống")
            }
    }
    func nextScreen(){
        let sb  =   UIStoryboard(name: "Main", bundle: nil)
        let nextSb  =   sb.instantiateViewController(withIdentifier: "home") as! ViewController
        present(nextSb, animated: true, completion: nil)
    }
    func alert(title:String){
        let alert   =   UIAlertController(title: "Thông báo", message: title, preferredStyle: .alert)
        let btnOk   =   UIAlertAction(title: "OK", style: .default) { (ok) in}
        alert.addAction(btnOk)
        present(alert, animated: true, completion: nil)
    }

}
