//
//  ViewController.swift
//  swiftCV2
//
//  Created by 정희원 on 2023/05/10.
//

import UIKit

class firstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ages = [String]()
    var age: String!
    var gender: String!
    
    
    @IBOutlet weak var agePicker: UIPickerView!
    
    @IBOutlet weak var selectAge: UILabel!
    
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBAction func female(){
        gender = "female"
            
        // Load and resize the "tintedp" image for femaleBtn
        if let femaleOriginalImage = UIImage(named: "tintedp") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            femaleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedFemaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                femaleBtn.setBackgroundImage(resizedFemaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }
        
        // Load and resize the "borderg" image for maleBtn
        if let maleOriginalImage = UIImage(named: "borderg") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            maleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedMaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                maleBtn.setBackgroundImage(resizedMaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }
    }
    
    
    @IBAction func male(){
        gender = "male"
            
        // Load and resize the "tintedg" image for maleBtn
        if let maleOriginalImage = UIImage(named: "tintedg") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            maleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedMaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                maleBtn.setBackgroundImage(resizedMaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }
        
        // Load and resize the "borderp" image for femaleBtn
        if let femaleOriginalImage = UIImage(named: "borderp") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            femaleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedFemaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                femaleBtn.setBackgroundImage(resizedFemaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        if gender == nil{
            let alert = UIAlertController(title: "알림", message: "성별을 선택해주세요.", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
            return
        }
        let selectVC = self.storyboard?.instantiateViewController(withIdentifier:
                                                                "selectViewController")as! selectViewController
        selectVC.gender = gender
        selectVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.backgroundColor = UIColor(hex: "#414258")
        nextBtn.setTitle("계속", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20) // Adjust the font size as needed
        //nextBtn.layer.cornerRadius = 25 // Half of the desired button height (50 / 2)

        nextBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Set the button's leading and trailing constraints to the safe area
            nextBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            nextBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            // Set the button's bottom constraint to the safe area with a constant height of 50
            nextBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            nextBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        setText()
      
        if let maleOriginalImage = UIImage(named: "borderg") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            maleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedMaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                maleBtn.setBackgroundImage(resizedMaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }

        // Load and resize the "borderp" image for femaleBtn
        if let femaleOriginalImage = UIImage(named: "borderp") {
            let newSize = CGSize(width: 108, height: 58)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            femaleOriginalImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            if let resizedFemaleImage = UIGraphicsGetImageFromCurrentImageContext() {
                femaleBtn.setBackgroundImage(resizedFemaleImage, for: .normal)
            }
            UIGraphicsEndImageContext()
        }
//
//        nextBtn.setBackgroundImage(UIImage(named: "next"), for: .normal)
//        nextBtn.sizeToFit()
//        nextBtn.imageView?.layoutMargins = .init(top: 2, left: 10, bottom: 2, right: 10)
        // Set the background color

        
        
        for i in 1...100{
            ages.append(String(i))
        }
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.selectRow(19, inComponent: 0, animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }

    
    // Delegate method that returns the value to be displayed in the picker.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ages[row]
    }
    
    // A method called when the picker is selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age = ages[row]
    }
    
    func setText(){
        selectAge.text = "나이를 선택해주세요"
        selectAge.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 24)
        selectAge.textAlignment = .center
        
    }

}


