//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Musa on 23.01.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
    }
    
    @objc func addButtonClick() {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    


}

