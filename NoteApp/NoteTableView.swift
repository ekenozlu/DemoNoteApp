//
//  NoteTableView.swift
//  NoteApp
//
//  Created by Eken Özlü on 5.06.2023.
//

import UIKit
import CoreData

var noteList = [NoteData]()

class NoteTableView: UITableViewController{
    
    var firstLoad = true

    override func viewDidLoad() {
        if firstLoad {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! NoteData
                    noteList.append(note)
                }
            } catch {
                print("Fetch Failed")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID") as! NoteCell
        
        let thisNote: NoteData!
        thisNote = noteList[indexPath.row]
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descriptionLabel.text = thisNote.desc
        
        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {  act, view, completionHandler in
            do {
                 let results: NSArray = try context.fetch(request) as NSArray
                 for result in results {
                     let note = result as! NoteData
                     if (note == noteList[indexPath.row]){
                         noteList.remove(at: indexPath.row)
                         context.delete(note)
                         try context.save()
                         tableView.reloadData()
                     }
                 }
             } catch {
                 print("Fetch Failed")
             }
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNote"){
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetailVC = segue.destination as? NoteDetailVC
            let selectedNote: NoteData = noteList[indexPath.row]
            noteDetailVC?.selectedNote = selectedNote
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
