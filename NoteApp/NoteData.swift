//
//  NoteData.swift
//  NoteApp
//
//  Created by Eken Özlü on 5.06.2023.
//

import CoreData

@objc(Note)
class NoteData: NSManagedObject{
    
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date!
    
}
