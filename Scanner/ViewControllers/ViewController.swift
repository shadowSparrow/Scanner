//
//  ViewController.swift
//  Scanner
//
//  Created by mac on 06.06.2023.
//

import UIKit
import VisionKit
import Vision


class ViewController: UIViewController {

    lazy var addScanButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.setTitle("New Scan", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startScanningAction), for: .allEvents)
        return button
    }()
    
     lazy var scanView: UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.backgroundColor = .blue
         imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
   lazy var scanTexView: UITextView = {
         let texView = UITextView()
        texView.backgroundColor = .cyan
        texView.textColor = .white
        texView.translatesAutoresizingMaskIntoConstraints = false
       return texView
    }()
    
    var scans: [Scan] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Documents"
        setUIElements()
        setContraints()
    }
    
    @objc func startScanningAction(_ sender: UIButton) {
        configureScanDocs()
        
    }

}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    
    private func setUIElements() {
        self.view.addSubview(addScanButton)
        self.view.addSubview(scanTexView)
        self.view.addSubview(scanView)
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            scanTexView.heightAnchor.constraint(equalToConstant: 200),
            scanTexView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            scanTexView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            scanTexView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scanTexView.bottomAnchor.constraint(equalTo: addScanButton.topAnchor, constant: -16),
            scanView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 132),
            scanView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            scanView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            scanView.heightAnchor.constraint(equalToConstant: 300),
            addScanButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addScanButton.heightAnchor.constraint(equalToConstant: 50),
            addScanButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            addScanButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            addScanButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
                                    ])
    }
    
   
    private func configureScanDocs() {
        let scanDoucument = VNDocumentCameraViewController()
        scanDoucument.delegate = self
        self.present(scanDoucument, animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for pageNumber in 0..<scan.pageCount {
            let originalImage = scan.imageOfPage(at: pageNumber)
            detectText(in: originalImage)
            scanView.image = originalImage
        }
        controller.dismiss(animated: true)
    }
    
    func detectText(in image: UIImage) {
        guard let image = image.cgImage else {
            print("Invalid image")
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error detecting text: \(error)")
            } else {
                self.handleDetectionResults(results: request.results)
            }
        }
        request.recognitionLanguages = ["en_US"]
        request.recognitionLevel = .fast
        performDetection(request: request, image: image)
    }
    
    func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
        let requests = [request]
        
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform(requests)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func handleDetectionResults(results: [Any]?) {
        guard let results = results, results.count > 0 else {
            print("No text found")
            return
        }
        
        guard let obsetvations = results as? [VNRecognizedTextObservation] else {return}
        
        let text = obsetvations.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: " ")
        
        DispatchQueue.main.async {
            self.scanTexView.text = text
        }
        
        /*
         for result in results {
         if let observation = result as? VNRecognizedTextObservation {
         
         
         
         for text in observation.topCandidates(1)[0...] {
         
         DispatchQueue.main.async {
         self.scanTexView.text = text.string
         print(text.string)
         print(text.confidence)
         print(observation.boundingBox)
         print("\n")
         }
         
         }
         
         }
         }
         
         */
    }
    
}

