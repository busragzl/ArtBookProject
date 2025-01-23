//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Musa on 23.01.2025.
//

import UIKit

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Recognizer

      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)) // Similator üzerinde editText tıklandığında diger editTestlerin üzeri kapandığı için
        view.addGestureRecognizer(gestureRecognizer) // view üzerinde neresi tıklanırsa tıklansın keybord kapanması için
        
        
        imageView.isUserInteractionEnabled = true
        let imageTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTabRecognizer)
        
        
    }

    @objc func hideKeyboard() {
        view.endEditing(true) // klavye kapatma
    }
    @objc func selectImage() {
        let picker = UIImagePickerController() // imageView tıklantığında fotograf seçebilmek için
        picker.delegate = self
        picker.sourceType = .photoLibrary // seçilecek fotografın galeriden alınması
        picker.allowsEditing = true // seçilecek fotografın editlenmesi
        present(picker, animated: true, completion: nil) // ekranda alert gibi göstermesi için
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage // any tipinde dönen resim objesinin UIImage'e dönüştürülmesi
        self.dismiss(animated: true) // picker'ın kapatılması
        
    } // image seçimi bittiğinde any tipinde seçilen görselin döndürülmesi

   
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    

}
