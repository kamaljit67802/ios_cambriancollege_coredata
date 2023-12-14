//
//  AddBookViewController.swift
//  Elibrary
//
//  Created by Gokul on 2023-12-10.
//

import UIKit

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var txtAuthorName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var synopsisTxtView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    static let storyboardName:String = "Main"
    static let storyBoardId:String = "AddBookViewController"
    var authorId:String = ""
    
    @IBOutlet weak var txtPublication: UITextField!
    var currentBookObj:BooksDisplayModel? = nil
    
    var addOperation:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentData()
        // Do any additional setup after loading the view.
    }
    
    func setCurrentData(){
        
        if currentBookObj != nil {
            self.titleTextField.text = currentBookObj?.title
            self.txtPublication.text = currentBookObj?.publishedYear
            self.synopsisTxtView.text = currentBookObj?.synopsis
            self.txtAuthorName.text = (currentBookObj?.authorModel.fname)! + "  " + (currentBookObj?.authorModel.lname)!
            self.authorId = currentBookObj?.authorModel.id ?? ""
            self.btnAdd.setTitle("Update", for: .normal)
            self.addOperation = false
        }
        else{
            self.btnAdd.setTitle("Add", for: .normal)
            self.addOperation = true
        }
        
    }
    class func showaddBookViewPage(sourceView:UIViewController,selectedModel:BooksDisplayModel?){
        let storyboard = UIStoryboard(name: AddBookViewController.storyboardName, bundle: nil)
        let detailiewVC:AddBookViewController = storyboard.instantiateViewController(withIdentifier: AddBookViewController.storyBoardId) as! AddBookViewController
        detailiewVC.currentBookObj = selectedModel
        sourceView.navigationController?.isNavigationBarHidden = false
        sourceView.navigationController?.pushViewController(detailiewVC, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func btnSelectAuthotSelected(_ sender: Any) {
        let storyboard = UIStoryboard(name: AuthorSelectionViewController.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: AuthorSelectionViewController.storyBoardId) as! AuthorSelectionViewController
        // Alternative way to present the new view controller
        vc.delegate = self
        self.navigationController?.show(vc, sender: nil)
       
       
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let titleTxt = titleTextField.text ?? ""
        if titleTxt == "" {
            return
        }
        
        let publicationYear = txtPublication.text ?? ""
        if publicationYear == "" {
            return
        }
        let synopsisText = synopsisTxtView.text ?? ""
        if synopsisText == "" {
            return
        }
        if currentBookObj?.authorModel.id  == "" {
            return
        }
        
        if !addOperation {
            //UPD
            
            QCCoredataOperations().updateBook(id: currentBookObj!.id, title: titleTxt, publicationYear: publicationYear, synopsis: synopsisText, authorId: self.authorId ){ result in
                if result {
                    
                    self.showAlert(status: result)
                    
                    
                }
            }
            
        }
        else{
            //ADD
            QCCoredataOperations().saveBooks(id: "", title: titleTxt, publicationYear: publicationYear, synopsis: synopsisText, authorId: self.authorId) { resultItem in
                
                self.showAlert(status: true)
            }
        }
    }
    func showAlert(status:Bool){
        var msg = ""
        if status {
            if addOperation {
                msg = "Book added."
            }
            else{
                msg = "Book Updted."
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

extension AddBookViewController:AuthorSelectionDelegate{
    func authorClicked(item: AuthorDisplayModel) {
        self.txtAuthorName.text = item.fname + "  " + item.lname
        self.authorId = item.id
    }

}

