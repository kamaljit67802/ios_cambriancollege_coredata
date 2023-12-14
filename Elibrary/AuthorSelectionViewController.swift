//
//  AuthorSelectionViewController.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import UIKit

class AuthorSelectionViewController: UIViewController {
  
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "AuthorSelectionViewController"
    var authorModelList : [AuthorDisplayModel] = []
    var currentAuthorObj : AuthorDisplayModel? = nil
    var delegate:AuthorSelectionDelegate?
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    class func showAuthorSelectionViewPage(sourceView:UIViewController,selectedModel:AuthorDisplayModel?){
//        let storyboard = UIStoryboard(name: AuthorSelectionViewController.storyboardName, bundle: nil)
//        let detailiewVC:AuthorSelectionViewController = storyboard.instantiateViewController(withIdentifier: AuthorSelectionViewController.storyBoardId) as! AuthorSelectionViewController
//        detailiewVC.currentAuthorObj = selectedModel
//        detailiewVC.delegate = sourceView as AddBookViewController
//        sourceView.navigationController?.isNavigationBarHidden = false
//        sourceView.navigationController?.pushViewController(detailiewVC, animated: true)
//    }
}
extension AuthorSelectionViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.authorModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AuthorSelectionTableViewCell.cellIdentifier) as? AuthorSelectionTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.setData(item: self.authorModelList[indexPath.row], index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
   
}

extension AuthorSelectionViewController:AuthorTableViewCellDelegate{
    func authorClicked(index: Int) {
        
        self.delegate?.authorClicked(item: self.authorModelList[index])
        self.navigationController?.popViewController(animated: true)
    }
      
    
}
class AuthorSelectionTableViewCell:UITableViewCell{
    
    static let cellIdentifier:String = "AuthorSelectionTableViewCell"
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblAuthor: UILabel!
    
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
        
        
        lblAuthor.text = item.fname + " " + item.lname
         currentItem = item
        self.btnSelect.removeTarget(self, action: nil, for: .allEvents)
        self.btnSelect.addTarget(self, action: #selector(AuthorSelectionTableViewCell.selectContact(_:)), for: .touchUpInside)
    }
    
    
    @objc func selectContact(_ sender: Any) {
        self.delegate?.authorClicked(index: self.index)
        
    }
}
