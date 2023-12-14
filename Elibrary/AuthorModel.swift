//
//  AuthorModel.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import Foundation
import Foundation
struct AuthorDisplayModel  {
    var fname : String = ""
    var lname : String = ""
    var id:String = ""
    
    init() {
        fname = ""
        lname = ""
        id = ""
    }
    init(author:Author?){
        fname = author?.fname ?? ""
        lname =  author?.lastname ?? ""
        id = author?.id ?? ""
    }
    
    func getAuthorList(completion:@escaping (_ status:Bool ,_ message :String, _ result: [AuthorDisplayModel] )->Void){
        
        QCCoredataOperations().getAllAuthorList() {  dbContactResult in
            
            let noteListModel :[AuthorDisplayModel] = convertToViewModel(list: dbContactResult)
            completion(false, "",noteListModel)
        }
    }
    
    func convertToViewModel(list:[Author])->[AuthorDisplayModel]{
        var tmpList:[AuthorDisplayModel]  = []
        for item in list{
            var tmp:AuthorDisplayModel = AuthorDisplayModel()
            tmp.lname = item.lastname ?? ""
            tmp.fname = item.fname ?? ""
            tmp.id =  item.id ?? ""
            tmpList.append(tmp)
        }
        return tmpList
    }
}
