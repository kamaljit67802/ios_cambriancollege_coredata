//
//  ElibraryCoredataManagerClass.swift
//  Elibrary
//

//

import Foundation
import CoreData
import UIKit

class QCCoredataManagerClass{
    static var shared:QCCoredataManagerClass = QCCoredataManagerClass()
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Elibrary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

struct QCCoredataOperations{
    
    //AUTHOR RELATED DB OPERATIONS
    
    func  saveAuthor(id:String,firstName:String,lastName:String,result: @escaping (_ resultItem:Bool)->Void){
        
        
        let dispatchQueue = DispatchQueue(label: "ELibraAddBG", qos: .background)
        dispatchQueue.async{
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
                let authorDetailsEntity = NSEntityDescription.entity(forEntityName: "Author", in: managed_Context)!
                
                
                //SAVE CONTACT DETAILS
                let authorItem:Author = NSManagedObject(entity: authorDetailsEntity, insertInto: managed_Context) as! Author
                authorItem.id = UUID().uuidString
                authorItem.fname = firstName
                authorItem.lastname = lastName


                
                if managed_Context.hasChanges {
                    do {
                        try  managed_Context.save()
                        result(true)
                    } catch {
                        // let nserror = error as NSError
                        //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        
                    }
                }
                else{
                    result(false)
                }
            }
        }
        
    }
    func getAllAuthors()->[Author]{
        let contactMainListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Author")
        contactMainListFetch.resultType  = .managedObjectResultType
        // contactMainListFetch.propertiesToFetch = ["id","name","phone"]
        var dbResult:[Author] = []
        if let result:[Author] = try! QCCoredataManagerClass.shared.persistentContainer.viewContext.fetch(contactMainListFetch) as? [Author] {
            for item in result {
                dbResult.append(item)
            }
        }
        return dbResult
        
    }
    
    func getAllAuthorList(completionHandlerWithJson: @escaping (_ contactDBResult:[Author]) -> Void) {
       let result =  getAllAuthors()
       completionHandlerWithJson(result)
    }
    
    
    
    func updateAuthor(id:String,firstName:String,lastName:String ,delResult: @escaping (_ result:Bool) -> Void){
        
        let dispatchQueue = DispatchQueue(label: "ElibUpdBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask {
                (managed_Context) in
                let authorItem: Author!
                
                        let request = Author.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", id)
                if  let items = try? managed_Context.fetch(request) {
                    
                    if items.count == 0 {
                        delResult(false)
                    } else {
                        // here you are updating
                        authorItem = items.first
                        authorItem.fname = firstName
                        authorItem.lastname = lastName
                    }
                }
                
                do {
                    try managed_Context.save()
                    delResult(true)
                }
                catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }
    func deleteAuthor(id:String,delResult: @escaping (_ result:Bool) -> Void){
        let dispatchQueue = DispatchQueue(label: "ElibDelBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
               // let fetchRequest1:NSFetchRequest<NSFetchRequestResult> = Author.fetchRequest()
                
                let companyAddrFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Author")
                companyAddrFetch.predicate = NSPredicate(format: "id = %@", id)
                
                let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: companyAddrFetch)
                
                do {
                    try managed_Context.execute(batchDeleteRequest1)
                    try  managed_Context.save()
                    delResult(true)
                    
                    //  self.saveBookMarks(documentsData: documentsData)
                } catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            }
            
            //}
        }
        
        
    }
    
    
    // BOOK RELATED OPERATIONS
    
    func  saveBooks(id:String,title:String,publicationYear:String,synopsis:String,authorId:String,result: @escaping (_ resultItem:Bool)->Void){
        
  
        
        let dispatchQueue = DispatchQueue(label: "ELibraAddBookG", qos: .background)
        dispatchQueue.async{
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
                let authorDetailsEntity = NSEntityDescription.entity(forEntityName: "Books", in: managed_Context)!
                
                
                //SAVE CONTACT DETAILS
                let bookItem:Books = NSManagedObject(entity: authorDetailsEntity, insertInto: managed_Context) as! Books
                bookItem.id = UUID().uuidString
                bookItem.title = title
                bookItem.publicationyear = publicationYear
                bookItem.synopsis = synopsis
                
                let authorItem: Author!
                
                        let request = Author.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", authorId)
                if  let items = try? managed_Context.fetch(request) {
                    
                    if items.count == 0 {
                       
                    } else {
                        // here you are updating
                        authorItem = items.first
                        bookItem.booksToAuthor = authorItem
                    }
                }
               
                
                if managed_Context.hasChanges {
                    do {
                        try  managed_Context.save()
                        result(true)
                    } catch {
                        // let nserror = error as NSError
                        //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        
                    }
                }
                else{
                    result(false)
                }
            }
        }
        
    }
    
    func getAllBooks()->[Books]{
        let contactMainListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        contactMainListFetch.resultType  = .managedObjectResultType
        // contactMainListFetch.propertiesToFetch = ["id","name","phone"]
        var dbResult:[Books] = []
        if let result:[Books] = try! QCCoredataManagerClass.shared.persistentContainer.viewContext.fetch(contactMainListFetch) as? [Books] {
            for item in result {
                dbResult.append(item)
            }
        }
        return dbResult
        
    }
    
    func getAllBooksList(completionHandlerWithJson: @escaping (_ contactDBResult:[Books]) -> Void) {
       let result =  getAllBooks()
       completionHandlerWithJson(result)
    }
    
    func updateBook(id:String,title:String,publicationYear:String,synopsis:String,authorId:String,delResult: @escaping (_ result:Bool) -> Void){
        
        let dispatchQueue = DispatchQueue(label: "ElibUpdBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask {
                (managed_Context) in
                let bookItem: Books!
                let authorItem: Author!
                        let request = Books.fetchRequest()
                    request.predicate = NSPredicate(format: "%K == %@", "id", id)
                if  let items = try? managed_Context.fetch(request) {
                    
                    if items.count == 0 {
                        delResult(false)
                    } else {
                        // here you are updating
                        bookItem = items.first
                        bookItem.title = title
                        bookItem.publicationyear = publicationYear
                        bookItem.synopsis = synopsis
                        
                        let request1 = Author.fetchRequest()
                        request1.predicate = NSPredicate(format: "%K == %@", "id", authorId)
                if  let items = try? managed_Context.fetch(request1) {
                    
                    if items.count == 0 {
                       
                    } else {
                        // here you are updating
                        authorItem = items.first
                        bookItem.booksToAuthor = authorItem
                    }
                }
                    }
                }
                
                do {
                    try managed_Context.save()
                    delResult(true)
                }
                catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }
    func deleteBook(id:String,delResult: @escaping (_ result:Bool) -> Void){
        let dispatchQueue = DispatchQueue(label: "ElibDelBG", qos: .background)
        dispatchQueue.async{
            //QDMSCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
            
            QCCoredataManagerClass.shared.persistentContainer.performBackgroundTask { (managed_Context) in
               // let fetchRequest1:NSFetchRequest<NSFetchRequestResult> = Author.fetchRequest()
                
                let bookFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
                bookFetch.predicate = NSPredicate(format: "id = %@", id)
                
                let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: bookFetch)
                
                do {
                    try managed_Context.execute(batchDeleteRequest1)
                    try  managed_Context.save()
                    delResult(true)
                    
                    //  self.saveBookMarks(documentsData: documentsData)
                } catch {
                    delResult(false)
                    //  let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            }
            
            //}
        }
        
        
    }
}
