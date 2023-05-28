//
//  SearchViewController.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var seachView: UIView!
    @IBOutlet weak var seachTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        seachView.layer.masksToBounds = true
        seachView.layer.cornerRadius = 5
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
