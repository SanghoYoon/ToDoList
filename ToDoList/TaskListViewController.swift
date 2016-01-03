//
//  ViewController.swift
//  ToDoList
//
//  Created by 윤상호 on 12/26/15.
//  Copyright © 2015 윤상호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tasks = [Task]() {
        didSet {
            self.saveAll()
        }
    }
    
    // IB: 인터페이스 빌더 <- 스토리보드 이전 이름
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAll()
    }
    
    @IBAction func editButtonDidTop(sender: UIBarButtonItem) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? UINavigationController,
            let taskEditorViewController = navigationController.viewControllers.first as? TaskEditorViewController {
                taskEditorViewController.didAddHandler = { task in
                    self.tasks.append(task)
                    self.tableView.reloadData()
                }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
        cell.textLabel?.text = self.tasks[indexPath.row].title
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        if self.tasks[indexPath.row].done {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadData() // UI 업데이트
    }
}

// MARK: - NSUserDefaults
extension ViewController {
//    나쁜 예
//    func saveAll() {
//        var dic = [String : AnyObject]()
//        var arr = [[String : AnyObject]]()
//        for i in 0..<tasks.count {
//            dic = ["title": String(tasks[i].title), "done": Bool(tasks[i].done)]
//            arr.append(dic)
//            user.setObject(arr[i], forKey: "task")
//        }
//        
//        print(arr)
//    }
    
//    func saveAll() {
//        var dicts = [[String: AnyObject]]()
//        
//        for task in self.tasks {
//            let dict: [String: AnyObject] = [
//                "title" : task.title,
//                "done" : task.done
//            ]
//            
//            dicts.append(dict)
//        }
//        
//        NSUserDefaults.standardUserDefaults().setObject(dicts, forKey: "tasks")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
    
    func saveAll() {
        let dicts = self.tasks.map {
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        
        NSUserDefaults.standardUserDefaults().setObject(dicts, forKey: "tasks")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
//    func loadAll() {
//        var arr : [[String : AnyObject]]
//        if let arr = user.objectForKey("task") {
//            for i in 0...arr.count {
//                print(arr)
//                self.tasks.append(Task(title: String(arr[i].title), done: arr[i]["done"] as! Bool))
//            }
//        }
//        
//    }
    
//    func loadAll() {
//        if let dicts = NSUserDefaults.standardUserDefaults().objectForKey("tasks") as? [[String: AnyObject]] {
//            var tasks = [Task]()
//            for dict in dicts {
//                if let title = dict["title"] as? String {
//                    let done = dict["done"] as? Bool == true
//                    let task = Task(title: title, done: done)
//                    tasks.append(task)
//                }
//            }
//        }
//    }
    
    func loadAll() {
        if let dicts = NSUserDefaults.standardUserDefaults().objectForKey("tasks") as? [[String: AnyObject]] {
            self.tasks = dicts.flatMap {
                if let title = $0["title"] as? String {
                    let done = $0["done"] as? Bool == true
                    return Task(title: title, done: done)
                }
                
                return nil
            }
        }
    }
}



/*
    var dicts = [[String: AnyObejct]]()
    
    for task in self.tasks {
        let dict = [
            "title" = task.title
            "done" = task.done
        ]
        dicts.append(dict)
    }

*/