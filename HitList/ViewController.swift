//
//  ViewController.swift
//  HitList
//
//  Created by Desiree on 11/17/20.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
          
          title = "The List"
          tableView.register(UITableViewCell.self,
                             forCellReuseIdentifier: "Cell")
        }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        let fetchRequest =
          NSFetchRequest<Person>(entityName: "Person")
        fetch(with: fetchRequest)
    }


    @IBAction func addName(_ sender: UIBarButtonItem) {
        // Implement the addName IBAction
        
          
          let alert = UIAlertController(title: "New Name",
                                        message: "Add a new name",
                                        preferredStyle: .alert)
          
          let saveAction = UIAlertAction(title: "Save",
                                         style: .default) {
            [unowned self] action in
                                          
            guard let textField = alert.textFields?.first,
              let nameToSave = textField.text else {
                return
            }
            self.save(name: nameToSave)
            tableView.reloadData()
          }
          
          let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel)
          
          alert.addTextField()
          
          alert.addAction(saveAction)
          alert.addAction(cancelAction)
          
          present(alert, animated: true)
        }
    
//MARK: - Save function
    func save(name: String) {
      //get reference to the app delegate
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // get access to persistant container
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // create new person object
      let person = Person(context: managedContext)
      
      // set name attribute using key value coding
      person.setValue(name, forKeyPath: "name")
      
      // save changes and add person to people array
      do {
        try managedContext.save()
        people.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
//MARK: - Fetch function
    func fetch(with fetchRequest: NSFetchRequest<Person>) {
        
        //get access to app delegate
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //get referenct to persistent container
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //fetch items
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
    


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {
    let person = people[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    
    return cell
  }
}


