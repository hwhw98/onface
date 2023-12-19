//
//  selectViewController.swift
//  swiftCV2
//
//  Created by 정희원 on 2023/05/15.
//

import UIKit

class selectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var gender: String!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var galleryBtn: UIButton!
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
        if gender! == "female"{
            backBtn.setBackgroundImage(UIImage(named: "backp"), for: .normal)
        } else if gender! == "male"{
            backBtn.setBackgroundImage(UIImage(named: "backg"), for: .normal)
        }
        
        backBtn.sizeToFit()
    }
    
    @IBAction func buttonClicked() {
        // to gallery and put image in resultViewController
        let vc = UIImagePickerController()
        
        vc.delegate = self
        vc.sourceType = .photoLibrary
        present(vc, animated: true)
    }
    
    
    func loadContent() {
        let backButtonItem = UIBarButtonItem(customView: backBtn)
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        let view = UILabel()
        view.backgroundColor = .white

        view.layer.cornerRadius = 49

        let parent = self.view! // Assuming self.view is the parent view

        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.lightGray
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: parent.widthAnchor),
            view.heightAnchor.constraint(equalTo: parent.widthAnchor),
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        ])
//
//        let gradientLayer = CAGradientLayer()
//
//
//        let largerSize = CGRect(
//            x: view.bounds.origin.x - 5,
//            y: view.bounds.origin.y - 5,
//            width: view.bounds.size.width + 10,
//            height: view.bounds.size.height + 10
//        )
//        gradientLayer.frame = largerSize
//
//        gradientLayer.colors = [UIColor(red: 0, green: 92/255, blue: 76/255, alpha: 1).cgColor, UIColor(red: 201/255, green: 28/255, blue: 80/255, alpha: 1).cgColor] // Replace with your desired gradient colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.colors = [UIColor(red: 0, green: 92/255, blue: 76/255, alpha: 1).cgColor, UIColor(red: 201/255, green: 28/255, blue: 80/255, alpha: 1).cgColor] // Replace with your desired gradient colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//
//        let smallerSize = CGRect(
//            x: view.bounds.origin.x + 5,
//            y: view.bounds.origin.y + 5,
//            width: view.bounds.size.width - 10,
//            height: view.bounds.size.height - 10
//        )
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = UIBezierPath(roundedRect: smallerSize, cornerRadius: 49).cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.black.cgColor // Replace with your desired stroke color
//        shapeLayer.lineWidth = 10 // Replace with your desired stroke width
//        shapeLayer.frame = view.bounds
//        gradientLayer.mask = shapeLayer
//
//
//        view.layer.addSublayer(gradientLayer)
        
        
        // image inside box
        // 1. face
        let face = UIImageView(image: UIImage(named: "femaleface"))
        face.contentMode = .scaleAspectFit
        parent.addSubview(face)
        face.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            face.widthAnchor.constraint(equalToConstant: 120),
            face.heightAnchor.constraint(equalTo: face.widthAnchor, multiplier: face.image!.size.height / face.image!.size.width),
            face.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 80),
            face.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        ])



        // 2. no
        let ban = UIImageView(image: UIImage(named: "xmark"))
        ban.contentMode = .scaleAspectFit
        parent.addSubview(ban)
        ban.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ban.widthAnchor.constraint(equalToConstant: 150),
            ban.heightAnchor.constraint(equalTo: ban.widthAnchor, multiplier: ban.image!.size.height / ban.image!.size.width),
            ban.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: -80),
            ban.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        ])


        let cap = UIImageView(image: UIImage(named: "cap"))
        cap.contentMode = .scaleAspectFit
        parent.addSubview(cap)
        cap.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cap.widthAnchor.constraint(equalToConstant: 80),
            cap.heightAnchor.constraint(equalTo: cap.widthAnchor, multiplier: cap.image!.size.height / cap.image!.size.width),
            cap.centerXAnchor.constraint(equalTo: ban.centerXAnchor, constant: -30),
            cap.centerYAnchor.constraint(equalTo: ban.centerYAnchor, constant: 10)
        ])

        let glass = UIImageView(image: UIImage(named: "eyeglasses"))
        glass.contentMode = .scaleAspectFit
        parent.addSubview(glass)
        glass.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            glass.widthAnchor.constraint(equalToConstant: 80),
            glass.heightAnchor.constraint(equalTo: glass.widthAnchor, multiplier: glass.image!.size.height / glass.image!.size.width),
            glass.centerXAnchor.constraint(equalTo: ban.centerXAnchor, constant: 30),
            glass.centerYAnchor.constraint(equalTo: ban.centerYAnchor, constant: -10)
        ])


        
        let textView = UITextView()
        textView.text = "안경, 모자, 마스크 등을 착용하지 않은 사진을 골라주세요. 앞머리가 이마를 덮지 않은, 이마가 보이는 사진을 골라주세요. 최대한 정면에서 찍은 사진을 골라주세요."
        textView.font =  UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        textView.backgroundColor = .clear
        textView.textAlignment = .natural
        parent.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            textView.topAnchor.constraint(equalTo: ban.bottomAnchor, constant: 32),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])


        galleryBtn.backgroundColor = UIColor(hex: "#414258")
        galleryBtn.setTitle("사진 선택하기", for: .normal)
        galleryBtn.setTitleColor(.white, for: .normal)
        galleryBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20) // Adjust the font size as needed
        galleryBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            galleryBtn.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            galleryBtn.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            galleryBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            galleryBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
//        let circle = UILabel()
//        circle.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        circle.backgroundColor = .white
//
//        let radius = min(circle.frame.width, circle.frame.height) / 2.0
//        circle.layer.cornerRadius = radius
//        circle.clipsToBounds = true
//
//        parent.addSubview(circle)
//        circle.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            circle.widthAnchor.constraint(equalToConstant: 80),
//            circle.heightAnchor.constraint(equalToConstant: 80),
//            circle.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
//            circle.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
//        ])
//
//        let gradient = CAGradientLayer()
//
//
//        gradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//
//        gradient.colors = [UIColor(red: 0, green: 92/255, blue: 76/255, alpha: 1).cgColor, UIColor(red: 201/255, green: 28/255, blue: 80/255, alpha: 1).cgColor] // Replace with your desired gradient colors
//        gradient.startPoint = CGPoint(x: 1, y: 1)
//        gradient.endPoint = CGPoint(x: 0, y: 0)
//
//
//        circle.layer.addSublayer(gradient)
//
//        let gall = UIImageView(image: UIImage(named: "photo"))
//        gall.contentMode = .scaleAspectFit
//
//        parent.addSubview(gall)
//        gall.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            gall.widthAnchor.constraint(equalToConstant: 50),
//            gall.heightAnchor.constraint(equalTo: gall.widthAnchor, multiplier: gall.image!.size.height / gall.image!.size.width),
//            gall.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
//            gall.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
//        ])
//        parent.bringSubviewToFront(gall)
//
//        galleryBtn.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 32).isActive = true
//        galleryBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        galleryBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        parent.bringSubviewToFront(galleryBtn)
    }

    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true){
                OpenCVWrapper.recognizeImage(image)
                let floatArray = OpenCVWrapper.getResult()
                if floatArray[0] == -1 {
                    let alert = UIAlertController(title: "알림", message: "얼굴을 찾지 못했습니다.\n사진을 다시 선택해주세요", preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                } else{
                    let resultVC = self.storyboard?.instantiateViewController(withIdentifier:
                                                                            "resultViewController")as! resultViewController
                    resultVC.source = image
                    resultVC.gender = self.gender
                    resultVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            picker.dismiss(animated: true){
//                OpenCVWrapper.recognizeImage(image)
//                let floatArray = OpenCVWrapper.getResult()
//                if floatArray[0] == -1 {
//                    let alert = UIAlertController(title: "알림", message: "얼굴을 찾지 못했습니다.\n사진을 다시 선택해주세요", preferredStyle: UIAlertController.Style.alert)
//                    self.present(alert, animated: true)
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        alert.dismiss(animated: true, completion: nil)
//                    }
//
//                } else{
//                    let resultVC = self.storyboard?.instantiateViewController(withIdentifier:
//                                                                            "resultViewController")as! resultViewController
//                    resultVC.source = image
//                    resultVC.gender = self.gender
//                    resultVC.modalPresentationStyle = .fullScreen
//                    self.navigationController?.pushViewController(resultVC, animated: true)
//                }
//            }
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

