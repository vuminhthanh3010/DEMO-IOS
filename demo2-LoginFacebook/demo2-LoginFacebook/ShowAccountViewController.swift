//
//  ShowAccountViewController.swift
//  demo2-LoginFacebook
//
//  Created by Minh Thanh on 7/10/19.
//  Copyright © 2019 Minh Thanh. All rights reserved.
//

import UIKit

class ShowAccountViewController: UIViewController {

    @IBOutlet weak var showUser: UILabel!
    @IBOutlet weak var showPass: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showUser.text   =   ""
        showPass.text   =   ""
        if let showUserName = UserDefaults.standard.string(forKey: "showUserName"), let showPassWord = UserDefaults.standard.string(forKey: "showPassWord") {
            showUser.text   =   showUserName
            showPass.text   =   showPassWord
        }
    }
    
    //click button logout
    @IBAction func btnLogout(_ sender: Any) {
        
        let alert   =   UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất hay không?", preferredStyle: .alert)
        let btnCancel   =   UIAlertAction(title: "Huỷ", style: .default) { (cancel) in }
        let btnOk   =   UIAlertAction(title: "OK", style: .default) { (ok) in
            let sb  =   UIStoryboard(name: "Main", bundle: nil)
            let nextSb  =   sb.instantiateViewController(withIdentifier: "home")
            self.present(nextSb, animated: true, completion: nil)
        }
        alert.addAction(btnCancel)
        alert.addAction(btnOk)
        present(alert, animated: true, completion: nil)
    }
    
}
