//
//  NoteDetailVC.swift
//  NoteApp
//
//  Created by Eken Özlü on 5.06.2023.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedNote : NoteData? = nil
    
    override func viewDidLoad() {
        deleteButton.isEnabled = false
        super.viewDidLoad()
        if (selectedNote != nil){
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
            deleteButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //SAVE NEW NOTE
        if (selectedNote == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = NoteData(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.desc = descriptionTextView.text
            do{
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch{
                print("error")
            }
        }
        //EDIT EXISTING NOTE
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! NoteData
                    if (note == selectedNote){
                        note.title = titleTextField.text
                        note.desc = descriptionTextView.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch Failed")
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete this Note?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { _ in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! NoteData
                    if (note == self.selectedNote){
                        noteList.removeAll { noteData in
                            noteData.id == self.selectedNote?.id
                        }
                        context.delete(note)
                        
                        try context.save()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch Failed")
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            alertController.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    
}

