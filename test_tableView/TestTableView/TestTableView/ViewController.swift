//
//  ViewController.swift
//  TestTableView
//
//  Created by ryoku on 2019/01/15.
//  Copyright © 2019 ryokuhei_sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tapLocation: CGPoint?

    let datasource = [
        [
            "TestCell2",
        ],
        [
            "TestCell",
            "TestCell",
         ],
        [
            "TestCell2",
            "TestCell2",
        ],
    ]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        let nib = UINib(nibName: "TestCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TestCell")
        
        let nib2 = UINib(nibName: "TestCell2", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "TestCell2")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.tableView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapped() {
        
        
        tableView.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    var tapY: CGFloat?
    var keyboardHeight: CGFloat?
    var tempY: CGFloat?
    
    @objc func willShowKeyboard(notification: Notification) {
        
        let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        let size = keyboardSize?.cgRectValue.size
        self.keyboardHeight = size?.height

        self.tapY = tapLocation?.y
        self.keyboardHeight = size?.height
//        print("scroll Y \(tapY)")
//        print("keyboard Height Y \(keyboardHeight)")

        // 667
        UIView.animate(withDuration: duration ?? 0, animations: {
//            self.tableView.contentOffset.y = (self.tapY ?? 0) + 1000
//                + (self.keyboardHeight ?? 0)

            self.tempY = self.tableView.contentOffset.y
            self.tableView.contentOffset.y = (self.tapY ?? 0) - (667 / 2)
        })
    }

    @objc func willHideKeyboard(notification: Notification) {

        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: duration ?? 0, animations: {
//            self.tableView.contentOffset.y = self.tapY ?? 0
            self.tableView.contentOffset.y = self.tempY ?? 0
        })
    }
    

}

extension ViewController: UITableViewDelegate {
    
}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.section {
        case 1:
          let cell1 = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
            cell = cell1
        case 0, 2:
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "TestCell2", for: indexPath) as! TestCell2
          cell2.tableView = self.tableView
          cell2.tapLocation = { [weak self] point in
//            print("set point: \(point)")
            self?.tapLocation = point
            
          }
            cell = cell2
        default:
          let defaultCell = tableView.dequeueReusableCell(withIdentifier: "TestCell2", for: indexPath)
            cell = defaultCell
        }

        return cell
    }
    

}

extension ViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        tableView.endEditing(true)
//    }
    
}
