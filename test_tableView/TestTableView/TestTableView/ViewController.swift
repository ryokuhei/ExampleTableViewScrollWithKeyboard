//
//  ViewController.swift
//  TestTableView
//
//  Created by ryoku on 2019/01/15.
//  Copyright © 2019 ryokuhei_sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tapPoint = CGPoint(x: 0, y: 0)
    var backToContentOffset = CGPoint(x: 0, y: 0)
    var isScroll = false

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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.tableView.addGestureRecognizer(tapGesture)
        
    }

    @objc func didTap() {
        
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
        
        guard !isScroll else {
            return
        }
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        let keyboardRect = keyboardFrame?.cgRectValue

        guard  keyboardRect?.contains(tapPoint) ?? false else {
            print("no tapped in keyborad")
            return
        }
        print("tapped in keyboard")
        

        let iPhoneSize = UIScreen.main.bounds.size

        let keyboardSize = keyboardRect?.size ?? CGSize(width: 0, height: 0)
        let enableArea = (iPhoneSize.height - keyboardSize.height)
        
        let scrollY = tapPoint.y - (enableArea / 2)

        self.backToContentOffset = self.tableView.contentOffset
        UIView.animate(withDuration: duration ?? 0, animations: {
            self.tableView.contentOffset.y += scrollY
//                + (self.keyboardHeight ?? 0)

//            self.tempY = self.tableView.contentOffset.y
//            self.tableView.contentOffset.y = (self.tapY ?? 0) - (667 / 2)
            
        })
        self.isScroll = true
    }

    @objc func willHideKeyboard(notification: Notification) {

        guard isScroll else {
            return
        }
        
//        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
//
//        UIView.animate(withDuration: duration ?? 0, animations: {
//            self.tableView.contentOffset = self.backToContentOffset
////            self.tableView.contentOffset.y = self.tempY ?? 0
//        })
        self.isScroll = false
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
//        case 0:
//          let cell1 = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
//            cell = cell1
        case 0, 1, 2:
          let cell2 = tableView.dequeueReusableCell(withIdentifier: "TestCell2", for: indexPath) as! TestCell2
          cell2.tableView = self.tableView
          cell2.targetView = self.view
          cell2.tapped = { [weak self] point in
            self?.tapPoint = point
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
