//
//  ScanCollectionViewCell.swift
//  Scanner
//
//  Created by mac on 06.06.2023.
//

import UIKit

class ScanCollectionViewCell: UICollectionViewCell {
    
    var scan: UIImageView!
    var scanName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scan = UIImageView()
        
        scan.backgroundColor = .black
        scan.layer.cornerRadius = 4
        scan.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scan)
        
       
        scanName = UILabel()
        scanName.textColor = .white
        scanName.textAlignment = .center
        scanName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scanName)
        
        // Constraints
        scan.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        scan.heightAnchor.constraint(equalToConstant: self.frame.height/1.5).isActive = true
        scan.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        scanName.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        scanName.heightAnchor.constraint(equalToConstant: self.frame.height/3).isActive = true
        scanName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
