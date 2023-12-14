//
//  AddAuthtorViewController.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import UIKit

class AddAuthtorViewController: UIViewController {
    
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "AddAuthtorViewController"
    var delegate:AuthorTableViewCellDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    var currentAuthorObj:AuthorDisplayModel? = nil
    
    var addOperation:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCurrentData()
        // Do any additional setup after loading the view.
    }
    
    func setCurrentData(){
        
        if currentAuthorObj != nil {
            self.txtFirstName.text = currentAuthorObj?.fname
            self.txtLastName.text = currentAuthorObj?.lname
            
            self.btnAdd.setTitle("Update", for: .normal)
            self.addOperation = false
        }
        else{
            self.btnAdd.setTitle("Add", for: .normal)
            self.addOperation = true
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
    class func showaddAuthorViewPage(sourceView:UIViewController,selectedModel:AuthorDisplayModel?){
        let storyboard = UIStoryboard(name: AddAuthtorViewController.storyboardName, bundle: nil)
        let detailiewVC:AddAuthtorViewController = storyboard.instantiateViewController(withIdentifier: AddAuthtorViewController.storyBoardId) as! AddAuthtorViewController
        detailiewVC.currentAuthorObj = selectedModel
       
        sourceView.navigationController?.isNavigationBarHidden = false
        sourceView.navigationController?.pushViewController(detailiewVC, animated: true)
    }
    
    @IBAction func btnAddorUpdateTapped(_ sender: Any) {
        
        let titleFst = txtFirstName.text ?? ""
        if titleFst == "" {
            return
        }
        
        let titleLst = txtLastName.text ?? ""
        if titleLst == "" {
            return
        }
        if !addOperation {
            //UPD
            
            QCCoredataOperations().updateAuthor(id: currentAuthorObj!.id, firstName: titleFst, lastName: titleLst, delResult: { result in
                
                if result {
                    
                    self.showAlert(status: result)
                    
                    
                }
            })
            
        }
        else{
            //ADD
            QCCoredataOperations().saveAuthor(id: "", firstName: titleFst, lastName: titleLst, result: { resultItem in
                
                self.showAlert(status: true)
            })
        }
    }
    func showAlert(status:Bool){
        var msg = ""
        if status {
            if addOperation {
                msg = "Author added."
            }
            else{
                msg = "Author Updted."
            }
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
        self.navigationController?.popViewController(animated: true)
    }
}
