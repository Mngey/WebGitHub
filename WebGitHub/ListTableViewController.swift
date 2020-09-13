//
//  ListTableViewController.swift
//  WebGitHub
//
//  Created by a.a.mitrofanova on 11/09/2020.
//  Copyright © 2020 mngey. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    var links = [GitHubLinks]()
    
    var managedObjectContext: NSManagedObjectContext?
    
//    var skillList = [
//        "https://github.com/Mngey/BestMoviesEver2",
//    "https://github.com/Mngey/ShoppingList",
//        "https://github.com/Mngey/LoginProject",
//        "https://github.com/Mngey/ConverterTemperature",
//        "https://github.com/Mngey/DayfinderHomework",
//        "https://github.com/Mngey/LayoutHometask",
//        "https://github.com/Mngey/TrafficLight",
//        "https://github.com/Mngey/DarkModeApp"
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()

    }

    @IBAction func newLinkTapped(_ sender: Any) {
        addLink()
        
    }
    
    func addLink() {
        let alertController = UIAlertController(title: "Add new link", message: "Would you like to add a link?", preferredStyle: .alert)
        alertController.addTextField {(textField: UITextField) in
       }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            
            let entity
                = NSEntityDescription.entity(forEntityName: "GitHubLinks", in: self.managedObjectContext!)
            
            let link = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            link.setValue(textField?.text, forKey: "link")
            self.saveData()
            
        }
        
        let cancelAction  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    func saveData(){
        do{
            try self.managedObjectContext?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<GitHubLinks> = GitHubLinks.fetchRequest()
        
        do{
            let result = try managedObjectContext?.fetch(request)
            links = result!
            tableView.reloadData()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return links.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webCell", for: indexPath)
        
        let link = links[indexPath.row]

        cell.textLabel?.text = link.value(forKey: "link") as? String
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: WebViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        vc.passedValue = links[indexPath.row].link!
        self.present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        links[indexPath.row].completed = !links[indexPath.row].completed
        
        saveData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            managedObjectContext?.delete(links[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        saveData()
    }
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
