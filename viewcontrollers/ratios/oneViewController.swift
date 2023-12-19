//
//  ratioViewController.swift
//  swiftCV2
//
//  Created by 정희원 on 2023/05/16.
//

import UIKit

class oneViewController: UIViewController {
//    var width: Double?
//    var height: Double?
//    var type:String?
    var gender: String!
    var bcolor: UIColor!
    var boxColor: UIColor!
    var titleColor: UIColor!
    
    var array: [Double]?
    var ratioType: Int?
    
    @IBOutlet weak var backbtn: UIButton!
 
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gender! == "female"{
            bcolor = UIColor(red: 115/255, green: 14/255, blue: 45/255, alpha: 1)
            boxColor = UIColor(red: 185/255, green: 109/255, blue: 132/255, alpha: 1)
            titleColor = UIColor(red: 156/255, green: 47/255, blue: 81/255, alpha: 1)
        } else if gender! == "male"{
            bcolor = UIColor(red: 0, green: 84/255, blue: 69/255, alpha: 1)
            boxColor = UIColor(red: 109/255, green: 185/255, blue: 171/255, alpha: 1)
            titleColor = UIColor(red: 29/255, green: 106/255, blue: 93/255, alpha: 1)
        }
        
        loadContent(arr: array)
        
//        if height! > 1.3{
//            type = "긴"
//        } else {
//            type = "짧은"
//        }
//
//        loadContent(w: width!, h: height!)
        
//        if gender! == "female"{
//            backbtn.setBackgroundImage(UIImage(named: "backp"), for: .normal)
//        } else if gender! == "male"{
//            backbtn.setBackgroundImage(UIImage(named: "backg"), for: .normal)
//        }
        backbtn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        
        backbtn.sizeToFit()
        
        
        
        

//        if let width = width, let height = height {
//            descript.text = "당신의 얼굴 가로 대비 세로의 비율은 \(width) : \(height)으로 "+type!+"편에 속합니다."
//
//        }
        
    }
    
    
//  func loadContent(w: Double, h: Double){
    
    
    // 디바이스 모델 조회
    func getModel() -> String {
            
            /*
            // -----------------------------------------
            [getDeviceModelName 메소드 설명]
            // -----------------------------------------
            1. 디바이스 기기 모델 이름 확인 실시
            // -----------------------------------------
            2. 호출 방법 :
             
             C_Util().getDeviceModelName()
            // -----------------------------------------
            3. 리턴 데이터 :
             
             iPhone XS / iPhone 11
            // -----------------------------------------
            */
            
            
        // [초기 리턴 데이터 변수 선언 실시]
        var modelName = ""
        
        // [1]. 시뮬레이터 체크 수행 실시
        modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
        if modelName != nil && modelName.isEmpty == false && modelName.count>0 {
            print("")
            print("====================================")
            print("[C_Util >> getDeviceModelName() :: 디바이스 시뮬레이터]")
            print("-------------------------------")
            print("deviceModelName :: \(modelName)")
            print("====================================")
            print("")
            
            // [리턴 반환 실시]
            return modelName
        }
        
        // [2]. 실제 디바이스 체크 수행 실시
        let device = UIDevice.current
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) { // [옵셔널 체크 실시]
            modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
        }
        
        // [로그 출력 실시]
        print("")
        print("====================================")
        print("[C_Util >> getDeviceModelName() :: 디바이스 기기 모델 명칭 확인]")
        print("-------------------------------")
        print("return :: \(modelName)")
        print("====================================")
        print("")
        
        // [리턴 반환 실시]
        return modelName
    }
    
    func loadContent(arr: [Double]?){
        let model = getModel()
        var small = false
        
        if model.contains("SE"){
            small = true
        }
        //iPhone14,5 내꺼
        // se모델
        
        
        let parent = self.view!
        parent.backgroundColor = bcolor
        
        
        
        // title
//        let title = UILabel()
//        title.text = "상세 비율"
//
//        title.font = UIFont(name: "", size: 32)
//        title.textColor =  titleColor
//        title.translatesAutoresizingMaskIntoConstraints = false
//
//        parent.addSubview(title)
//
//        if small == true{
//            NSLayoutConstraint.activate([
//                title.topAnchor.constraint(equalTo: parent.topAnchor, constant: 20),
//                title.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
//            ])
//
//        } else {
//            NSLayoutConstraint.activate([
//                title.topAnchor.constraint(equalTo: parent.topAnchor, constant: 50),
//                title.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
//            ])
//
//        }
        let backButtonItem = UIBarButtonItem(customView: backbtn)
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = backButtonItem
        if let navigationBar = navigationController?.navigationBar {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 20) // You can adjust the font size as needed
            ]
            
            // Set the title text attributes
            navigationBar.titleTextAttributes = titleAttributes
        }
        self.navigationItem.title = "상세 비율"
        
        
           
        // face image
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.layer.cornerRadius = 45
        imageContainer.clipsToBounds = true
        imageContainer.backgroundColor = .white

        let image = UIImageView(image: UIImage(named: "female\(String(ratioType!))"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        

        imageContainer.addSubview(image)
        parent.addSubview(imageContainer)

        if small == true{
            NSLayoutConstraint.activate([
                // Add constraints for the image container
                imageContainer.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                imageContainer.widthAnchor.constraint(equalToConstant: 180),
                imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
                imageContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),

                // Add constraints for the image view
                image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -7),
                image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 7),
                image.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: -7),
                image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 7)
            ])
        }
        else{
            NSLayoutConstraint.activate([
                // Add constraints for the image container
                imageContainer.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                imageContainer.widthAnchor.constraint(equalToConstant: 180),
                imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
                imageContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 52),
                
                // Add constraints for the image view
                image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -7),
                image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 7),
                image.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: -7),
                image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 7)
            ])
        }
        
        
        // level image
        var level: UIImageView!
//        if gender! == "female"{
//            level = UIImageView(image: UIImage(named: "levelp"))
//        } else if gender! == "male"{
//            level = UIImageView(image: UIImage(named: "levelg"))
//        }
        level = UIImageView(image: UIImage(named: "level"))
        level.translatesAutoresizingMaskIntoConstraints = false
        level.contentMode = .scaleAspectFit
        
        parent.addSubview(level)
        
        if small == true{
            NSLayoutConstraint.activate([
                level.widthAnchor.constraint(equalToConstant: 200),
                level.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                level.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 52)
                //level.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -level.frame.height),
                //level.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -35)
            ])
        } else{
            NSLayoutConstraint.activate([
                level.widthAnchor.constraint(equalToConstant: 200),
                level.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                level.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 60)
                //level.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -level.frame.height),
                //level.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -35)
            ])
        }
        
        
        let lowX = level.leadingAnchor
        let midX = level.centerXAnchor
        let highX = level.trailingAnchor
        print("what type")
        print(type(of: level.leadingAnchor))

    
        // level text
        let high = UILabel()
        high.text = "short"
        high.font = UIFont(name: "Cinzel-Bold", size: 18)
        high.textColor = UIColor.white
        high.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addSubview(high)
        
        NSLayoutConstraint.activate([
            high.bottomAnchor.constraint(equalTo: level.topAnchor, constant: -2),
            high.centerXAnchor.constraint(equalTo: lowX)
        ])
        
        let mid = UILabel()
        mid.text = "avg"
        mid.font = UIFont(name: "Cinzel-Bold", size: 18)
        mid.textColor = UIColor.white
        mid.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addSubview(mid)
        
        NSLayoutConstraint.activate([
            mid.bottomAnchor.constraint(equalTo: level.topAnchor, constant: -2),
            mid.centerXAnchor.constraint(equalTo: midX)
        ])
        
        let low = UILabel()
        low.text = "long"
        low.font = UIFont(name: "Cinzel-Bold", size: 18)
        low.textColor = UIColor.white
        low.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addSubview(low)
        
        NSLayoutConstraint.activate([
            low.bottomAnchor.constraint(equalTo: level.topAnchor, constant: -2),
            low.centerXAnchor.constraint(equalTo: highX)
        ])
        
     
        
        
        
        // descript box
        let descript = UITextView()
        var per = 0.5
        var dir = false
        
        if ratioType==1{
            if let height = array?[1], let width = array?[0] {
                let result = round(height / width*100)/100
                var type = ""
                // 1~1.6
                if result > 1.3 {
                    type = "긴"
                    per = (result-1.3)/0.3
                    dir = true
                } else{
                    type = "짧은"
                    per = (1.3-result/0.3)
                }
                descript.text = "당신의 얼굴 폭과 길이의 비율은 1 : \(result)으로 \(type)편에 속합니다."
            } else {
                print("One or both values are nil.")
            }
        } else if ratioType==2{
            if let fore = array?[0], let nose = array?[1], let lip = array?[2] {
                var type1 = ""
                var type2 = ""
                if fore/nose>1{
                    type1 = "넓은"
                } else{
                    type1 = "좁은"
                }
                // 0.5~1.5
                if lip/nose>1{
                    type2 = "긴"
                    per = (lip/nose-1)/0.5
                    dir = true
                } else{
                    type2 = "짧은"
                    per = (1-lip/nose)/0.5
                }
                descript.text = "당신의 상안부, 중안부, 하안부의 비율은 \(round(fore/nose*100)/100) : 1 : \(round(lip/nose*100)/100)으로 이마는 코에 비해 \(type1)편이고, 당신의 턱은 코에 비해 \(type2) 편입니다."
            }
        } else if ratioType==3{
            if let left_eye_width=array?[0], let right_eye_width=array?[1], let middle_left=array?[2], let middle_right=array?[3], let left_width=array?[4], let right_width=array?[5] {
                
                descript.text = "당신의 왼쪽 광대, 왼쪽 눈, 미간, 오른쪽 눈, 오른쪽 광대의 비율은 \(round(left_width-middle_left-left_eye_width*100)/100) : \(round(left_eye_width*100)/100) : \(round(middle_left+middle_right*100)/100) : \(round(right_eye_width*100)/100) : \(round(right_width-right_eye_width-middle_right*100)/100)이다"
            }
        } else if ratioType==4{
            if let left_eye_width=array?[0], let left_eye_height = array?[1], let right_eye_width = array?[2], let right_eye_height = array?[3] {
                let avg = (left_eye_width/left_eye_height + right_eye_width/right_eye_height)/2
                var type = ""
                // 1.5~3.5
                if avg>1{
                    type = "긴"
                    per = (avg-2.5)/1
                    dir = true
                } else{
                    type = "짧은"
                    per = (2.5-avg)/1
                }
                descript.text = "당신의 왼쪽 눈 가로와 세로 비율은 \(round(left_eye_width/left_eye_height*100)/100) : 1, 오른쪽 눈 가로와 세로 비율은 \(round(right_eye_width/right_eye_height*100)/100) : 1 로 눈이 \(type) 편입니다."
            }
        } else if ratioType==5{
            if let left_eyebrow_to_eye = array?[0], let right_eyebrow_to_eye = array?[1], let left_eye_height = array?[2], let right_eye_height = array?[3]{
                var type = ""
                let avg = (left_eyebrow_to_eye/left_eye_height + right_eyebrow_to_eye/right_eye_height)/2
                if avg > 2.5 {
                    type = "넓은"
                    per = (avg-2.5)/0.5
                    dir = true
                } else{
                    type = "좁은"
                    per = (2.5-avg)/0.5
                }
                descript.text = "당신의 눈썹과 눈 사이 거리와 눈 세로 길이의 비율은 왼쯕은 \(round(left_eyebrow_to_eye/left_eye_height*100)/100) : 1 이고 오른쪽은 \(round(right_eyebrow_to_eye/right_eye_height*100)/100) : 1 으로 눈썹과 눈 사이 거리가 \(type) 편입니다."
            }
        } else if ratioType==6{
            if let nose = array?[0], let eye = array?[1], let lip = array?[2] {
                var type1 = ""
                var type2 = ""
                if eye/nose>1{
                    type1 = "넓은"
                } else{
                    type1 = "좁은"
                }
                
                if lip/nose>1.3{
                    type2 = "넓은"
                } else{
                    type2 = "좁은"
                }
                
                descript.text = "당신의 미간 : 코 : 입 의 너비 비율은 \(round(eye/nose*100)/100) : 1 : \(round(lip/nose*100)/100) 으로 코에 비해 미간이 \(type1) 편이고, 코에 비해 입이 \(type2) 편입니다."
            }
        } else if ratioType==7{
            if let up = array?[0], let down = array?[1] {
                var type = ""
                if down/up>2.31{
                    type = "위"
                    per = (down/up - 2.31)/0.5
                    dir = true
                } else{
                    type = "아래"
                    per  = (2.31 - down/up)/0.5
                }
                descript.text = "당신의 눈 위치는 눈썹에서 눈, 눈에서 코의 비율이 1 : \(round(down/up*100)/100) 으로 눈이 \(type)에 있는 편입니다."
            }
        } else if ratioType==8{
            if let up = array?[0], let down = array?[1] {
                var type = ""
                if down/up>=2.1{
                    type = "위"
                    per = (down/up - 2.1)/0.5
                    dir = true
                } else{
                    type = "아래"
                    per = (2.1 - down/up)/0.5
                }
                descript.text = "당신의 입의 위치는 인중, 턱의 비율이 1 : \(round(down/up*100)/100) 으로 입이 \(type)에 있는 편입니다."
            }
        } else if ratioType==9{
            if let upper_lip = array?[0], let lower_lip = array?[1], let lip_width = array?[2], let lip_height = array?[3] {
                var type1 = ""
                var type2 = ""
                if lower_lip/upper_lip > 1.9 {
                    type1 = "두꺼운"
                } else{
                    type1 = "얇은"
                }
                
                if lip_width/lip_height >= 2.1 {
                    type2 = "긴"
                    per = (lip_width/lip_height-2.1)/0.5
                    dir = true
                } else{
                    type2 = "짧은"
                }
                descript.text = "당신의 윗 입술과 아랫입술의 두께 비율은 1 : \(round(lower_lip/upper_lip*100)/100) 으로 아래입술이 윗입술보다 \(type1) 편이고, 입술의 세로 대비 가로의 비율은 1 : \(round(lip_width/lip_height*100)/100) 으로 입술이 \(type2) 편입니다."
            }
        }
        
        
        
        // point
        // 받아서 l 이면
        //  mid - ( (mid-low) * p/100 )이 point
        // h이면
        //  mid + ( (high-mid) * p/100 )이 point
        
        var point: UIImageView!
//        if gender! == "female"{
//            point = UIImageView(image: UIImage(named: "pointp"))
//        } else if gender! == "male"{
//            point = UIImageView(image: UIImage(named: "pointg"))
//        }
        point = UIImageView(image: UIImage(named: "point"))
        point.translatesAutoresizingMaskIntoConstraints = false
        point.contentMode = .scaleAspectFit
        
        parent.addSubview(point)

//        // Calculate the centerX constant
//        let centerXConstant = (highX - midX) * CGFloat(per)
//
//        // Create the centerX constraint for point
//        let centerXConstraint = point.centerXAnchor.constraint(equalTo: point.superview!.centerXAnchor, constant: centerXConstant)

        if dir == true{
            if per<1{
                NSLayoutConstraint.activate([
                    point.widthAnchor.constraint(equalToConstant: 28),
                    point.heightAnchor.constraint(equalToConstant: 32),
                    point.centerXAnchor.constraint(equalTo: midX, constant: 100*CGFloat(per)),
                    point.topAnchor.constraint(equalTo: level.bottomAnchor, constant: 5)
                ])
            }else{
                NSLayoutConstraint.activate([
                    point.widthAnchor.constraint(equalToConstant: 28),
                    point.heightAnchor.constraint(equalToConstant: 32),
                    point.centerXAnchor.constraint(equalTo: midX, constant: 100),
                    point.topAnchor.constraint(equalTo: level.bottomAnchor, constant: 5)
                ])
            }
            
        } else {
            if per<1{
                NSLayoutConstraint.activate([
                    point.widthAnchor.constraint(equalToConstant: 28),
                    point.heightAnchor.constraint(equalToConstant: 32),
                    point.centerXAnchor.constraint(equalTo: midX, constant: -100*CGFloat(per)),
                    point.topAnchor.constraint(equalTo: level.bottomAnchor, constant: 5)
                ])
            } else{
                NSLayoutConstraint.activate([
                    point.widthAnchor.constraint(equalToConstant: 28),
                    point.heightAnchor.constraint(equalToConstant: 32),
                    point.centerXAnchor.constraint(equalTo: midX, constant: -100),
                    point.topAnchor.constraint(equalTo: level.bottomAnchor, constant: 5)
                ])
            }
            
           
        }
        
        
        
//        let height = round(h * 100) / 100
//        descript.text = "당신의 얼굴 가로 대비 세로의 비율은 \(w) : \(height)으로 "+type!+"편에 속합니다."
        
        
        
        descript.font =  UIFont(name: "Cinzel-Bold", size: 18)
        descript.textColor = UIColor.white
        descript.translatesAutoresizingMaskIntoConstraints = false
        
        descript.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        descript.layer.cornerRadius = 20
        descript.layer.borderWidth = 5
        descript.layer.borderColor = UIColor.white.cgColor
        

        //light pink backgroundcolor
        let backgroundColor = bcolor
        
        descript.backgroundColor = backgroundColor
        
        parent.addSubview(descript)
        
        if small == true{
            NSLayoutConstraint.activate([
                descript.widthAnchor.constraint(equalToConstant: 350),
                descript.heightAnchor.constraint(equalToConstant: 160),
                descript.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                descript.topAnchor.constraint(equalTo: point.bottomAnchor, constant: 36)
            ])
        } else{
            NSLayoutConstraint.activate([
                descript.widthAnchor.constraint(equalToConstant: 350),
                descript.heightAnchor.constraint(equalToConstant: 180),
                descript.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                descript.topAnchor.constraint(equalTo: point.bottomAnchor, constant: 44)
            ])
        }
        
        
    }
    



}
