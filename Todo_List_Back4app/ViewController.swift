//
//  ViewController.swift
//  Todo_List_Back4app
//
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var listItens:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveAllItens()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]


    }
    
    func retrieveAllItens(){
        let query = PFQuery(className:"Item")
        query.findObjectsInBackground { (list, error) in
            self.listItens = list!
            self.tableView.reloadData()
        }
    }


    @IBAction func add(_ sender: Any) {
        openDialog(edit:false, item: nil)
    }
    
    func openDialog(edit:Bool, item: PFObject?){
        let alert = UIAlertController(title: "Item", message: "Enter a text", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Insert text here."
            if(item != nil){
                textField.text = (item!["name"] as! String)
            }
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            if(item == nil){
                self.saveNewItem(text: textField.text!)
            }else{
                item!["name"] = textField.text
                self.updateItem(item: item!)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func saveNewItem(text: String){
        let item = PFObject(className:"Item")
        item["name"] = text
        item.saveInBackground { (success, error) in
            self.retrieveAllItens()
        }
    }
    
    func updateItem(item: PFObject){
        item.saveInBackground { (success, error) in
            self.retrieveAllItens()
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.listItens[sender.tag].deleteInBackground { (success, error) in
                self.retrieveAllItens()
            }
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              //do nothind
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        self.openDialog(edit: true, item: self.listItens[sender.tag])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        cell.label.text = (self.listItens[indexPath.row]["name"] as! String)
        cell.btn_edit.tag = indexPath.row
        cell.delete_btn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openDialog(edit: true, item: self.listItens[indexPath.row])
    }
    
}

