//
//  AuthorsViewController.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import UIKit

class AuthorsViewController: UIViewController {
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "AuthorsViewController"
    
    var authorModelList : [AuthorDisplayModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
    }
    func initialSetup(){
        self.fetchAuthorDetails()
    }
    
    func fetchAuthorDetails(){
        AuthorDisplayModel().getAuthorList { status, message, result in
            
            self.authorModelList = result
            self.tableReload()
        }
    }
    
    func tableReload(){
        if self.authorModelList .count > 0{
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
    func showAlert(status:Bool){
        var msg = ""
        if status {
            
                msg = "Author deleted."
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
            self.fetchAuthorDetails()}
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
        AddAuthtorViewController.showaddAuthorViewPage(sourceView: self, selectedModel: nil)
    }
    
    
    
}

extension AuthorsViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.authorModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AuthorDisplyTableViewCell.cellIdentifier) as? AuthorDisplyTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.setData(item: self.authorModelList[indexPath.row], index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let delAlert = UIAlertController(title: "ELibrary", message: "Are you sure you want to delete?. All the books corresponds to the author will also delete", preferredStyle: UIAlertController.Style.alert)

            delAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                QCCoredataOperations().deleteAuthor(id:  self.authorModelList[indexPath.row].id) { result in
                    if result {
                        self.showAlert(status: result)
                    }
                }
            }))

            delAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))

            present(delAlert, animated: true, completion: nil)
            
            
           
        }
        
        
    }
}

extension AuthorsViewController:AuthorTableViewCellDelegate{
    func authorClicked(index: Int) {

        AddAuthtorViewController.showaddAuthorViewPage(sourceView: self, selectedModel: self.authorModelList[index])
    }
      
    
}

class AuthorDisplyTableViewCell:UITableViewCell{
    
    static let cellIdentifier:String = "AuthorDisplyTableViewCell"
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBAction func btnSelect(_ sender: Any) {
    }
    
    var delegate:AuthorTableViewCellDelegate?
    var index:Int = 0
    var currentItem:AuthorDisplayModel = AuthorDisplayModel()
    
    func setCellItem(item:AuthorDisplayModel){
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(item:AuthorDisplayModel,index:Int){
        self.index = index
       
         currentItem = item
        self.btnSelect.removeTarget(self, action: nil, for: .allEvents)
        self.lblName.text = item.fname + " " + item.lname
        self.btnSelect.addTarget(self, action: #selector(AuthorDisplyTableViewCell.selectAuthor(_:)), for: .touchUpInside)
    }
    
    
    @objc func selectAuthor(_ sender: Any) {
        self.delegate?.authorClicked(index: self.index)
        
    }
}
protocol AuthorTableViewCellDelegate{
    func authorClicked(index:Int)
}
protocol AuthorSelectionDelegate{
    func authorClicked(item:AuthorDisplayModel)
}
