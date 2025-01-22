//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Musa on 23.01.2025.
//

import UIKit

class DetailsVC: UIViewController {
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)) // Similator üzerinde editText tıklandığında diger editTestlerin üzeri kapandığı için
        view.addGestureRecognizer(gestureRecognizer) // view üzerinde neresi tıklanırsa tıklansın keybord kapanması için
        
    }

    @objc func hideKeyboard() {
        view.endEditing(true) // klavye kapatma
    }

   
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    

}
