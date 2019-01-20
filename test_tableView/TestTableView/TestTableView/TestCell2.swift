//
//  TestCell2.swift
//  TestTableView
//
//  Created by ryoku on 2019/01/16.
//  Copyright © 2019 ryokuhei_sato. All rights reserved.
//

import UIKit

class TestCell2: UITableViewCell {
    
    @IBOutlet weak var textView: TestTextView!
    
    weak var targetView: UIView?
    var tapped: ((_ point :CGPoint) -> Void)?

    weak var tableView: UITableView? {
        didSet {
            textView.targetView = self.tableView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        textView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture(sender:)))
//        textView.addGestureRecognizer(panGesture)
//        panGesture.delegate = self
        
    }
    
    @objc func doPanGesture(sender: UIPanGestureRecognizer) {
//        self.tableView?.endEditing(true)
        self.textView?.resignFirstResponder()
    }

    @objc func didTap(sender: UITapGestureRecognizer) {
        
        print("tapped")
        let tapPoint = sender.location(in: self.targetView)
        self.tapped?(tapPoint)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

}

extension TestCell2: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}

class TestTextView: UITextView {
    
    weak var targetView: UIView?
}
