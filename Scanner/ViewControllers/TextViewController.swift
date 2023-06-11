//
//  TextViewController.swift
//  Scanner
//
//  Created by mac on 10.06.2023.
//

import UIKit

class TextViewController: UIViewController {

    var textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.backgroundColor = .cyan
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40).isActive = true
        //textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}
