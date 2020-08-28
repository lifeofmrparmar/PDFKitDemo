//
//  File.swift
//  PDFKitDemo
//
//  Created by Mayur Parmar on 28/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
 

struct TableDataItem {
    let name: String
    let address: String
    let phone: String

    init(name: String, address: String, phone: String) {
        self.name = name
        self.address = address
        self.phone = phone
    }
}

class CreateTablePDFViewController: UIViewController {
    // MARK: -  IBOutlet & Variable
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBOutlet weak var buttonGeneratePDF: UIButton!
    @IBOutlet weak var tblUserData: UITableView!
     
    let backBtn = UIBarButtonItem()
    var pdfView: PDFView!
    var arrUserData = [TableDataItem]()
    
    // MARK: -  Other Method
    func setupUI() {
        self.title = "Table PDF"
        
        let image: UIImage = UIImage(systemName: "doc.text.fill")! 
        backBtn.image = image
        backBtn.action = #selector(popSelf)
        backBtn.target = self
        navigationItem.leftBarButtonItem = backBtn
        
        tblUserData.tableFooterView = UIView()
        buttonAdd.target = self;
        buttonAdd.action = #selector(didTapButtonAdd)
        buttonGeneratePDF.addTarget(self, action: #selector(didTapGeneratePDF), for: .touchUpInside)
    }
    
    
    func createTablePDF() -> Data {
        let tableDataHeaderTitles =  ["name", "email", "phone"]
        let pdfCreator = PDFTableCreator(tableDataItems: arrUserData, tableDataHeaderTitles: tableDataHeaderTitles)

        return pdfCreator.create()
    }
    
    
    //show TextField in alert to insert record
    func showTextField() {
        var alert = UIAlertController()
            alert = UIAlertController(title: "PDF", message: "Add Record", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
            textField.placeholder = "Enter User Name"
        })
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
            textField.placeholder = "Enter Address"
        })
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
            textField.placeholder = "Enter Phone"
            textField.keyboardType = .phonePad
        })
         
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (action) -> Void in
            let textField1 = alert?.textFields![0]
            let textField2 = alert?.textFields![1]
            let textField3 = alert?.textFields![2]
            let userName = textField1?.text ?? ""
            let userAddress = textField2?.text ?? ""
            let userPhone = textField3?.text ?? ""
            if userName != ""  && userAddress != "" && userPhone != "" {
                self.arrUserData.append(TableDataItem(name: userName, address: userAddress, phone: userPhone))
                self.tblUserData.reloadData()
            } else {
                self.showAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func  showAlert() {
        let alert = UIAlertController(title: "Data Not Provided", message: "Please provide some data to create a PDF.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - View Life Cycle
extension CreateTablePDFViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
}


//MARK:- IBAction
extension CreateTablePDFViewController {
    @objc func popSelf() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapButtonAdd() {
        showTextField()
    }
    
    @objc func didTapGeneratePDF() {
        if arrUserData.count != 0 {
            let vc = self.storyboard?.instantiateViewController(identifier: "PreviewViewController") as! PreviewViewController
            let pdfData = createTablePDF()
            vc.documentData = pdfData
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlert()
        } 
    }
}
 

//MARK:- TableViewDelegate Methods
extension CreateTablePDFViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell", for: indexPath) as! tblCell
        cell.lblName.text = "Name: \(self.arrUserData[indexPath.row].name)"
        cell.lblAddress.text = "Address: \(self.arrUserData[indexPath.row].address)"
        cell.lblPhone.text = "Phone: \(self.arrUserData[indexPath.row].phone)"
        return cell
    }
     
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.arrUserData.remove(at: indexPath.row)
            print("deleted!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}


//MARK:- UITableViewCell
class tblCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
}
