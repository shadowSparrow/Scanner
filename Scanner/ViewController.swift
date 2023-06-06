//
//  ViewController.swift
//  Scanner
//
//  Created by mac on 06.06.2023.
//

import UIKit
import VisionKit
var addScanButton: UIButton!
var scansCollectionView: UICollectionView!
var scans: [Scan] = []


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Documents"
       // self.view.backgroundColor = .cyan
        setUIElements()
    }
    
    @objc func startScanningAction(_ sender: UIButton) {
        configureScanDocs()
    }

}

extension ViewController {
    
    private func setUIElements() {
        addScanButton = UIButton(configuration: .tinted())
        addScanButton.setTitle("New Scan", for: .normal)
        addScanButton.translatesAutoresizingMaskIntoConstraints = false
        addScanButton.addTarget(self, action: #selector(startScanningAction), for: .allEvents)
        self.view.addSubview(addScanButton)
        
        // Constraints
        addScanButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor , multiplier: 0).isActive = true
        addScanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addScanButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        addScanButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        addScanButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        scansCollectionView = UICollectionView(frame: self.view.bounds.inset(by: UIEdgeInsets(top: 50, left: 16, bottom: 200, right: 16)), collectionViewLayout: layout)
        scansCollectionView.register(ScanCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        scansCollectionView.delegate = self
        scansCollectionView.dataSource = self
        //scansCollectionView.backgroundColor = UIColor.cyan
        self.view.addSubview(scansCollectionView)
    }
    
}

extension UIViewController: VNDocumentCameraViewControllerDelegate {
    
    func configureScanDocs() {
        let scanDoucument = VNDocumentCameraViewController()
        scanDoucument.delegate = self
        self.present(scanDoucument, animated: true)
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageNumber)
            let newScan = Scan(scanImage: image, scanName: "NewScan")
            scans.append(newScan)
            scansCollectionView.reloadData()
        }
        controller.dismiss(animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScanCollectionViewCell
        cell.backgroundColor = .blue
        cell.scan.image = scans[indexPath.row].scanImage
        cell.scanName.text = scans[indexPath.row].scanName
        return cell
    }
    
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
    }
}
