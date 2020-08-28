//
//  ViewController.swift
//  PDFKitDemo
//
//  Created by Mayur Parmar on 28/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit
import PDFKit

class CreatePDFViewController: UIViewController {
    // MARK: -  IBOutlet
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var txtBody: UITextView!
    
    @IBOutlet weak var buttonSelectImage: UIButton! 
    @IBOutlet weak var buttonGeneratePDF: UIButton! 
    @IBOutlet weak var imgPreviewHeight: NSLayoutConstraint!
    
    // MARK: -  Other Method
    func setupUI() {
        txtBody.layer.borderColor = UIColor.gray.cgColor
        txtBody.layer.borderWidth = 1.0
        txtBody.layer.cornerRadius = 4.0
        txtBody.text = "Add PDF Body!"
        txtBody.delegate = self
        txtBody.textColor = UIColor.lightGray
        imgPreviewHeight.constant = 0
        
        buttonSelectImage.addTarget(self, action: #selector(didTapButtonSelectImage), for: .touchUpInside)
        buttonGeneratePDF.addTarget(self, action: #selector(didTapButtonGeneratePDF), for: .touchUpInside)
    }
    
    func isAllDataAvailable() -> Bool {
        if !txtTitle.text!.trimmingCharacters(in: .whitespaces).isEmpty && !txtBody.text!.trimmingCharacters(in: .whitespaces).isEmpty && imgPreview.image != nil {
            if txtBody.text != "Add PDF Body!" {
                return true
            } else { return false }
        } else { return false }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "All Data Not Provided", message: "Please provide all information to create a PDF.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - View Life Cycle
extension CreatePDFViewController {
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
extension CreatePDFViewController {
    @objc func didTapButtonSelectImage() {
        let actionSheet = UIAlertController(title: "Select Photo", message: "Select Photo Fom?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                
                self.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera
                self.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func didTapButtonGeneratePDF() {
        let vc = self.storyboard?.instantiateViewController(identifier: "PreviewViewController") as! PreviewViewController
        if isAllDataAvailable() {
            if let title = txtTitle.text, let body = txtBody.text, let image = imgPreview.image  {
                let pdfCreator = PDFCreator(title: title, body: body,image: image )
                let pdfData = pdfCreator.createPDF()
                vc.documentData = pdfData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.showAlert()
            return
        } 
    }
}


// MARK: - UIImagePickerControllerDelegate
extension CreatePDFViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imgPreview.image = selectedImage
        imgPreviewHeight.constant = 150 
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITextViewDelegate
extension CreatePDFViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
 
