//
//  BooksModel.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import Foundation
struct BooksDisplayModel  {
    var title:String = ""
    var publishedYear:String = ""
    var id:String = ""
    var synopsis:String = ""
    var authorModel:AuthorDisplayModel = AuthorDisplayModel()
    
    init() {
        title = ""
        publishedYear = ""
        id = ""
        synopsis = ""
        authorModel = AuthorDisplayModel()
    }
    init(books:Books){
        title = books.title ?? ""
        publishedYear =  books.publicationyear ?? ""
        id = books.id ?? ""
        synopsis = books.synopsis ?? ""
        authorModel = AuthorDisplayModel(author: books.booksToAuthor!)
    }
    
    func getBooksList(completion:@escaping (_ status:Bool ,_ message :String, _ result: [BooksDisplayModel] )->Void){
        
        QCCoredataOperations().getAllBooksList() {  dbContactResult in
            
            let bookListModel :[BooksDisplayModel] = convertToViewModel(list: dbContactResult)
            completion(false, "",bookListModel)
        }
    }
    
    func convertToViewModel(list:[Books])->[BooksDisplayModel]{
        var tmpList:[BooksDisplayModel]  = []
        for item in list{
            var tmp:BooksDisplayModel = BooksDisplayModel()
            tmp.title = item.title ?? ""
            tmp.publishedYear = item.publicationyear ?? ""
            tmp.id =  item.id ?? ""
            tmp.synopsis =  item.synopsis ?? ""
            tmp.authorModel =  AuthorDisplayModel(author: item.booksToAuthor ??  nil)
            tmpList.append(tmp)
        }
        return tmpList
    }
}
