//
//  ViewController.swift
//  Scanner
//
//  Created by mac on 06.06.2023.
//

import UIKit
import VisionKit
import Vision

var addScanButton: UIButton!
var scanView: UIImageView!
var scanLabel: UILabel!
//var scansCollectionView: UICollectionView!
var scans: [Scan] = []

var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Documents"
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
        
        scanView = UIImageView()
        scanView.backgroundColor = .cyan
        scanView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scanView)
        
        scanLabel = UILabel()
        scanLabel.backgroundColor = .blue
        scanLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scanLabel)
        
        // Constraints
        addScanButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor , multiplier: 0).isActive = true
        addScanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addScanButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        addScanButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        addScanButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        
        scanView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 132).isActive = true
        scanView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        scanView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        scanView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        scanLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        scanLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        scanLabel.topAnchor.constraint(equalTo: scanView.bottomAnchor, constant: 0).isActive = true
        scanLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        /*
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        */
        
        /*
        scansCollectionView = UICollectionView(frame: self.view.bounds.inset(by: UIEdgeInsets(top: 50, left: 16, bottom: 200, right: 16)), collectionViewLayout: layout)
        scansCollectionView.register(ScanCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        scansCollectionView.delegate = self
        scansCollectionView.dataSource = self
        scansCollectionView.isPagingEnabled = true
        //scansCollectionView.backgroundColor = UIColor.cyan
        self.view.addSubview(scansCollectionView)
         */
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
            let originalImage = scan.imageOfPage(at: pageNumber)
            let newImage = compressedImage(originalImage)
            scanView.image = newImage
            //scansCollectionView.reloadData()
        
        }
        controller.dismiss(animated: true)
    }
    
    func compressedImage(_ originalImage: UIImage) -> UIImage {
            guard let imageData = originalImage.jpegData(compressionQuality: 1),
                let reloadedImage = UIImage(data: imageData) else {
                    return originalImage
            }
            return reloadedImage
        }
    
     func setupVision() {
            textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                var detectedText = ""
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { return }
                    print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
        
                    detectedText += topCandidate.string
                    detectedText += "\n"
                    
                }
            }
            textRecognitionRequest.recognitionLevel = .accurate
        
         DispatchQueue.main.async {
             
         }
        
       
        }
    
}

/*
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
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height/1.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
    }
}
*/
