//
//  BooksViewController.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import UIKit

class BooksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "BooksViewController"
    
    var bookModelList : [BooksDisplayModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
    }
    func initialSetup(){
        self.fetchBookDetails()
    }
    
    func fetchBookDetails(){
        BooksDisplayModel().getBooksList { status, message, result in
            self.bookModelList = result
            self.tableReload()
        }
    }
    
    func tableReload(){
        if self.bookModelList .count > 0{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
          
        }
        else{
            // self.noDataFoundLabel.text = SPMlcQuickContactsOperations.noDataFoundVal
            self.tableView.isHidden = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnAddTapped(_ sender: Any) {
        AddBookViewController.showaddBookViewPage(sourceView: self, selectedModel:nil)
    }
    func showAlert(status:Bool){
        var msg = ""
        if status {
            
                msg = "Books deleted."
            }
           
        else{
            msg = "Transaction failed"
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ELibrary", message: msg, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: self.popUpView))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func popUpView(action:UIAlertAction) {
        DispatchQueue.main.async {
            self.fetchBookDetails()}
    }
    
}




extension BooksViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.bookModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: booksDisplyTableViewCell.cellIdentifier) as? booksDisplyTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.setData(item: self.bookModelList[indexPath.row], index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            QCCoredataOperations().deleteBook(id: self.bookModelList[indexPath.row].id) { [self] result in
                if result {
                    showAlert(status: result)
                }
            }
            
        }
    }
    
    
}

extension BooksViewController:BooksTableViewCellDelegate{
    func booksClicked(index: Int) {

        AddBookViewController.showaddBookViewPage(sourceView: self, selectedModel: self.bookModelList[index])
    }
      
    
}

class booksDisplyTableViewCell:UITableViewCell{
    
    static let cellIdentifier:String = "booksDisplyTableViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var publishedYear: UILabel!
    
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblSynopsis: UILabel!
    var delegate:BooksTableViewCellDelegate?
    var index:Int = 0
    var currentItem:BooksDisplayModel = BooksDisplayModel()
    
    func setCellItem(item:BooksDisplayModel){
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(item:BooksDisplayModel,index:Int){
        self.index = index
        
        
         lblTitle.text = item.title
         publishedYear.text = item.publishedYear
         lblAuthor.text = item.authorModel.fname + " " + item.authorModel.lname
         lblSynopsis.text = item.synopsis
         currentItem = item
        self.btnSelect.removeTarget(self, action: nil, for: .allEvents)
        self.btnSelect.addTarget(self, action: #selector(booksDisplyTableViewCell.selectContact(_:)), for: .touchUpInside)
    }
    
    
    @objc func selectContact(_ sender: Any) {
        self.delegate?.booksClicked(index: self.index)
        
    }
}
protocol BooksTableViewCellDelegate{
    func booksClicked(index:Int)
}
