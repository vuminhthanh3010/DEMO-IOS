//
//  ViewController.swift
//  demo1
//
//  Created by Minh Thanh on 7/8/19.
//  Copyright © 2019 Minh Thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var phoneName:[String]   =   ["Thanh"]
    var phoneNumber:[String] =   ["0987301097"]
    
    @IBOutlet weak var showCountContact: UIBarButtonItem!
    @IBOutlet weak var listConact: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        listConact.delegate     =   self
        listConact.dataSource   =   self
        navigationItem.title    =   "Danh Bạ"
        showCountContact.title  =   "\(phoneName.count) Liên hệ"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneNumber.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    =   listConact.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
        cell.showName.text  =   phoneName[indexPath.row]
        cell.showPhone.text =   phoneNumber[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete  =   UITableViewRowAction(style: .default, title: "Xoá") { (action, index) in
            self.phoneNumber.remove(at: indexPath.row)
            self.phoneName.remove(at: indexPath.row)
            self.listConact.deleteRows(at: [indexPath], with: .automatic)
            self.listConact.reloadData()
            self.showCountContact.title  =   "\(self.phoneName.count) Liên hệ"
        }
        let edit    =   UITableViewRowAction(style: .default, title: "Sửa") { (action, index) in
            let alertEdit       =   UIAlertController(title: "Thông báo", message: "Sửa thông tin liên hệ", preferredStyle: .alert)
            alertEdit.addTextField(configurationHandler: { (editName) in
                editName.text   =   self.phoneName[indexPath.row]
            })
            alertEdit.addTextField(configurationHandler: { (editPhone) in
                editPhone.text   =   self.phoneNumber[indexPath.row]
            })
            let btnCancelEdit   =   UIAlertAction(title: "Huỷ", style: .default, handler: { (cancel) in})
            let btnEdit     =   UIAlertAction(title: "Sửa", style: .default, handler: { (btnEdit) in
                let addPhoneEdit:String =   alertEdit.textFields![1].text!
                let addNameEdit:String =   alertEdit.textFields![0].text!
                if addPhoneEdit.count    < 11{
                    self.phoneNumber[indexPath.row]  =   addPhoneEdit
                    self.phoneName[indexPath.row]  =   addNameEdit
                    self.listConact.reloadData()
                    
                }else{
                    let alertError  =   UIAlertController(title: "Thông báo", message: "Sửa liên hệ không thành công. Số điện thoại gồm 10 chữ số", preferredStyle: .alert)
                    let btn_OK      =   UIAlertAction(title: "Ok", style: .default, handler: { (ok) in})
                    alertError.addAction(btn_OK)
                    self.present(alertError, animated: true, completion: nil)
                }
            })
            alertEdit.addAction(btnCancelEdit)
            alertEdit.addAction(btnEdit)
            self.present(alertEdit, animated: true, completion: nil)
        }
        edit.backgroundColor    =   UIColor.init(red: 0.0745, green: 0.6588, blue: 0.6863, alpha: 1)
        return  [delete,edit]
    }
    @IBAction func addPhoneNumber(_ sender: Any) {
        let alert   =   UIAlertController(title: "Thông báo", message: "Nhập số điện thoại bạn muốn thêm", preferredStyle: .alert)
        alert.addTextField { (name) in
            name.placeholder   =   "Tên liên hệ"
        }
        alert.addTextField { (phone) in
            phone.placeholder   =   "Số điện thoại"
            phone.keyboardType  =   .numberPad
        }
        let btnCancel   =   UIAlertAction(title: "Huỷ", style: .default) { (cancel) in }
        let btnAdd  =   UIAlertAction(title: "Thêm", style: .default) { (ok) in
            let addPhone:String =   alert.textFields![1].text!
            let addName:String =   alert.textFields![0].text!
            if addPhone.count    < 11{
                self.phoneNumber.append(addPhone)
                self.phoneName.append(addName)
                self.listConact.reloadData()
                self.showCountContact.title  =   "\(self.phoneName.count) Liên hệ"
            }else{
                let alertError  =   UIAlertController(title: "Thông báo", message: "Thêm liên hệ không thành công. Số điện thoại gồm 10 chữ số", preferredStyle: .alert)
                let btn_OK      =   UIAlertAction(title: "Ok", style: .default, handler: { (ok) in})
                alertError.addAction(btn_OK)
                self.present(alertError, animated: true, completion: nil)
            }

        }
        alert.addAction(btnCancel)
        alert.addAction(btnAdd)
        present(alert, animated: true, completion: nil)
    }
    

    
    
    
    
}

