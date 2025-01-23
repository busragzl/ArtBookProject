//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Büşra on 23.01.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    var selectedPainting = ""
    var selectedPaintingId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)  //
    }
    
   
    
    
    @objc func getData() {
        
        nameArray.removeAll(keepingCapacity:false) // arryleri temizleme dublicate veri için
        idArray.removeAll(keepingCapacity:false) // arryleri temizleme
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Paintings")
        fetchRequest.returnsObjectsAsFaults = false // daha verimli okumak için chach'den okumayı kapatıyoruz
        
        do{
            
         let result = try context.fetch(fetchRequest) // dizi halinde dönüyor
            
            if result.count > 0 {
                for result in result as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name) // isim key li datanın getirilmesi
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)  // id key li datanın getirilmesi
                    }
                    
                    self.tableView.reloadData() //yeni data geldiğinde tableView güncellenmesi
                    
                    
                }
            }
     
            
        }catch {
            print("error")
        }
        
    }
    
    @objc func addButtonClick() {
        selectedPainting = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //cell.textLabel?.text = nameArray[indexPath.row]
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPainting = selectedPainting
            destinationVC.chosenPaintingId = selectedPaintingId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPainting = nameArray[indexPath.row]
        selectedPaintingId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id == %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                
                                context.delete(result) // core data'dan seçilen verinin silinmesi
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at:  indexPath.row)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save() // silme işleminin tamamlanması kayıt edilmesi
                                }catch {
                                    print("Error")
                                }
                                
                                break
                                
                            }
                            
                        }
                    }
                }
            }catch {
                print("Error")
            }
            
            
            
           
        }
    }

}

