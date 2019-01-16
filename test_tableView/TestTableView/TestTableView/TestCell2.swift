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
    
    weak var tableView: UITableView? {
        didSet {
            textView.targetView = self.tableView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taped))
        textView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    @objc func taped(sender: UITapGestureRecognizer) {
        
        print("tapped")
        self.textView.taped(sender: sender)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

    var tapLocation: ((CGPoint?) -> Void)? {
        didSet {
            self.textView.tapLocationHandler = self.tapLocation
        }
    }

}

extension TestCell2: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}

class TestTextView: UITextView {
    
    weak var targetView: UIView?
    var tapLocationHandler: ((CGPoint?) -> Void)?
    
    func taped(sender: UITapGestureRecognizer) {
        
        print("tapped")
        let taplocation = sender.location(in: targetView)
        self.tapLocationHandler?(taplocation)
    }
    
}
