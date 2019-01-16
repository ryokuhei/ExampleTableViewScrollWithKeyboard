//
//  TestCell.swift
//  TestTableView
//
//  Created by ryoku on 2019/01/15.
//  Copyright © 2019 ryokuhei_sato. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
    }
    
}

extension TestCell: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}
