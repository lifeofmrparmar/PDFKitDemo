//
//  PreviewViewController.swift
//  PDFKitDemo
//
//  Created by Mayur Parmar on 28/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit
import PDFKit

class PreviewViewController: UIViewController {
    // MARK: -  IBOutlet & Variable
    public var documentData: Data?
    @IBOutlet weak var displayPDFView: UIView!
    @IBOutlet weak var buttonSharePDF: UIButton!
    
    
    // MARK: -  Other Method
    func setupUI() {
        buttonSharePDF.addTarget(self, action: #selector(didTapButtonShare), for: .touchUpInside)
        if let data = documentData {
            let pdfView = PDFView()
            pdfView.autoScales = true
            displayPDFView.addSubview(pdfView)
            pdfView.frame = displayPDFView.frame
            pdfView.document = PDFDocument(data: data)
         }
    }
}


// MARK: - View Life Cycle
extension PreviewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}


// MARK: - Button Action
extension PreviewViewController {
    @objc func didTapButtonShare() {
        if let data = documentData {
            let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
}
