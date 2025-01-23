//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Büşra on 23.01.2025.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if chosenPainting != "" {
            // CoreData
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = chosenPaintingId?.uuidString
            // id ile filtreleme
            fetchRequest.predicate = NSPredicate(format: "id= %@", idString!) // id'si argümana eşit olanı getir
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        if let artist = result.value(forKey: "artist") as? String {
                            artistText.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            }catch{
                print("Error")
            }
            
            
            
        }else {
            nameText.text = ""
            artistText.text = ""
            yearText.text = ""
        }
        
        
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
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Attributes
        
        newPainting.setValue(nameText.text, forKey: "name")
        newPainting.setValue(artistText.text, forKey: "artist")
        
        if let year = Int(yearText.text!){
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        newPainting.setValue(data, forKey: "image")
        
        
        do {
            try context.save()
            print("success")
        }catch{
            print("error")
        }
        
        //1.yol Kayıttan sonra verileri güncellemek için
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil) // Kayıt olan gözlemciler için mesaj yollama aleti , diger viewController'lara veri gönderme
        
        //2.yol Kayıttan sonra verileri güncellemek için
        
        //getData()
        // self.navigationController?.popViewController(animated: true) //Bir önceki viewController'a gitme
        
       
        
        
    }
    

}
