//
//  ViewController.swift
//  notList
//
//  Created by Muhammet Emre Kemancı on 18.09.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var ToDoList:[String] = []
    let defults = UserDefaults.standard
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        if let list = defults.array(forKey: k.userKey) as? [String]{
            ToDoList = list
        }
        tableView.register(UINib(nibName: "ToDoCeLL", bundle: nil), forCellReuseIdentifier: k.toDoıtem)
        super.viewDidLoad()
       
    }

    @IBAction func AddItem(_ sender: UINavigationItem) {
        let alart = UIAlertController(title: "Add To Do.", message: "Enter name to do.", preferredStyle: .alert)
        alart.addTextField()
        alart.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak alart] (_) in
            let textFieald = alart?.textFields![0]
            print("textField\(textFieald!.text!)")
            self.ToDoList.append(textFieald!.text!)
            self.defults.set(self.ToDoList, forKey: k.userKey)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        self.present(alart, animated: true)
    }
    
}



//MARK: - ViewControllerTableViewDataSource

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableview = tableView.dequeueReusableCell(withIdentifier: k.toDoıtem, for: indexPath) as! ToDoCeLL
        tableview.toDo.text = ToDoList[indexPath.row]
            return tableview
    }
}
//MARK: - UITableViewDelegate

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = ToDoList[sourceIndexPath.row]
        ToDoList.remove(at: sourceIndexPath.row)
        ToDoList.insert(mover, at: destinationIndexPath.row)
        defults.removeObject(forKey: k.userKey)
        defults.set(ToDoList, forKey: k.userKey)
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sendValue = ToDoList[indexPath.row]
        performSegue(withIdentifier: k.toDoList, sender:sendValue)
        
        
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == k.toDoList{
            let view = segue.destination as! ToDoListController
            view.navigationBar.title = sender as? String
        }
    }
    
}
    
    //MARK: - UITableViewDragDelegate
    
    extension ViewController:UITableViewDragDelegate{
        func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = ToDoList[indexPath.row]
            
            return [dragItem]
        }
        
        
    }
//MARK: - UISearchBarDelegate
extension ViewController : UISearchBarDelegate{
    
    
    
}


