//
//  resultViewController.swift
//  swiftCV2
//
//  Created by 정희원 on 2023/05/15.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKTemplate

let templateId = 93956


class resultViewController: UIViewController {
    
    var gender: String!
    var bcolor: UIColor!
    var fcolor: UIColor!
    
    //let palette: [UIImage] = []
    let one = 1.00
    let ratioName: [String] = ["얼굴형", "중안부", "눈과 미간 너비", "눈 세로 가로폭", "눈과 눈썹사이 거리", "미간, 코, 입 너비", "눈의 위치", "입의 위치", "위아래 입술 두께"]
    
    var index: Int!
    var toneResult: [String] = ["겨울딥", "겨울브라이트", "봄라이트", "봄비비드", "여름브라이트", "여름뮤트", "가을뮤트", "가을딥"]
    var resultTitle: [String] = ["woody & floral", "fresh & floral", "floral", "floral", "fresh & aroma", "aroma", "oriental \n& floral", "woody \n& oriental"]
    var resultImage: [String] = ["w", "fl", "fr", "a", "o"]
    var resultContent: [String] = ["피부톤은 차분하고 모던한 향이 잘 어울립니다.", "피부톤은 맑고 은은한 향이 잘 어울립니다.", "피부톤은 맑고 밝은 향이 잘 어울립니다.", "피부톤은 귀여운, 발랄한 향이 잘 어울립니다.", "피부톤은 온화하고 맑은 향이 잘 어울립니다.", "피부톤은 우아하고 내추럴한 향이 잘 어울립니다.", "피부톤은 따뜻하고 귀여운 향이 잘 어룰립니다.", "피부톤은 깊고 강한 향이 어울립니다."]
    
    var source:UIImage!
    var skinTone:String!


    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func home(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //@IBOutlet weak var backView: UIView!
    //@IBOutlet weak var backview: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    // 카카오톡 공유 버튼
    
    
    var calculator:CalculatePoints!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gender! == "female"{
            bcolor = UIColor(red: 214/255, green: 187/255, blue: 196/255, alpha: 1)
            fcolor = UIColor(red: 171/255, green: 112/255, blue: 130/255, alpha: 1)
        } else if gender! == "male"{
            bcolor = UIColor(red: 169/255, green: 210/255, blue: 203/255, alpha:1)
            fcolor = UIColor(red: 88/255, green: 157/255, blue:145/255 , alpha:1)
        }
        
        let backButtonItem = UIBarButtonItem(customView: backBtn)
        let homeButtonItem = UIBarButtonItem(customView: homeBtn)
        navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = homeButtonItem
        
        
        OpenCVWrapper.recognizeImage(source)
        let floatArray = OpenCVWrapper.getResult()
        let doubleArray = OpenCVWrapper.getColorResult()
        
        calculator = CalculatePoints.init(input: floatArray)
        calculator.calculate()
        
        let lineCurveArray = calculator.getLineCurve()
        
        print("color result")
        print(doubleArray[0])
        print(doubleArray[1])
    
        let r = doubleArray[2]/doubleArray[3]
        let g = doubleArray[3]/doubleArray[3]
        let b = doubleArray[4]/doubleArray[3]
        print("green")
        print(doubleArray[3])
        print("brow")
        print(doubleArray[5])
    
        print("Line or Curve")
        print(lineCurveArray[0])
        print(lineCurveArray[1])
        print(lineCurveArray[2])
        print("rgb")
        print(r)
        print(g)
        print(b)
        
        if r >= 1.2{
            if b <= 0.88  {
                print("fall")
                if doubleArray[0]>80{
                    print("deep fall")
                    skinTone = toneResult[7]
                    index = 7
                } else{
                    print("mute fall")
                    skinTone = toneResult[6]
                    index = 6
                }
            } else {
                print("spring")
                if doubleArray[0]>50{
                    print("bright spring")
                    skinTone = toneResult[2]
                    index = 2
                } else{
                    print("vivid spring")
                    skinTone = toneResult[3]
                    index = 3
                }
            }
        } else {
            if doubleArray[5] >= 1.45 {
                print("winter")
                if doubleArray[0]<30{
                    print("clear winter")
                    skinTone =  toneResult[1]
                    index = 1
                } else {
                    print("deep winter")
                    skinTone =  toneResult[0]
                    index = 0
                }
            } else{
                print("summer")
                if doubleArray[0]<45{
                    print("bright summer")
                    skinTone =  toneResult[4]
                    index = 4
                } else{
                    print("mute summer")
                    skinTone =  toneResult[5]
                    index = 5
                }
            }
    
        }
        
        
        loadResultContent(idx: index)
    
        

        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        collectionView.layer.shadowPath = nil
        collectionView.layer.shadowColor = UIColor.systemGray.cgColor
        collectionView.layer.shadowRadius = 0.5  //반지름 - 범위?
        collectionView.layer.shadowOpacity = 0.4 //투명도 0~1
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 1) //위치이동 - 아래로 1 이동

        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        

        
        
        
        floatArray.deallocate()
        doubleArray.deallocate()

    
        
        //collectioin view 로 9가지 비율 CalculatePoints 객체 하나 만들어서 가져와서 보이기

        // Do any additional setup after loading the view.
    }
    
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

    
    func loadResultContent(idx: Int){
        let model = getModel()
        var small = false
        
        if model.contains("SE"){
            small = true
        }
       
        if gender! == "female"{
            backBtn.setBackgroundImage(UIImage(named: "backp"), for: .normal)
            homeBtn.setBackgroundImage(UIImage(named: "homep"), for: .normal)
        } else if gender! == "male"{
            backBtn.setBackgroundImage(UIImage(named: "backg"), for: .normal)
            homeBtn.setBackgroundImage(UIImage(named: "homeg"), for: .normal)
        }
        
        backBtn.sizeToFit()
        homeBtn.sizeToFit()
        
        
        let parent = self.view!

        let backview = UIView()
        backview.backgroundColor = bcolor
        backview.layer.cornerRadius = 20
        backview.translatesAutoresizingMaskIntoConstraints = false

        let backView = UIView()
        backView.backgroundColor = fcolor
        backView.layer.cornerRadius = 32
        backView.translatesAutoresizingMaskIntoConstraints = false

        parent.addSubview(backview)
        backview.addSubview(backView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = small ? 250 : 300
        
        NSLayoutConstraint.activate([
            backview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            backview.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            backview.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            backview.heightAnchor.constraint(equalToConstant: height),
            
            backView.centerXAnchor.constraint(equalTo: backview.centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: backview.centerYAnchor),
            backView.widthAnchor.constraint(equalTo: backview.widthAnchor, constant: -20),
            backView.heightAnchor.constraint(equalTo: backview.heightAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: backview.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
        
        

        

        
        // Create the title label
        let titleLabel = UILabel()
        titleLabel.text = resultTitle[idx]
        titleLabel.font = UIFont(name: "Cinzel-Bold", size: 50)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backView.addSubview(titleLabel)
        // Add constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backview.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: backview.centerXAnchor)
        ])
      
        
        
        // frag image
        let rec = UIImageView()
        rec.contentMode = .scaleToFill

        var frag: UIImage?
        if let unwrappedSkinTone = skinTone {
            print("skintone")
            print(unwrappedSkinTone)
            if unwrappedSkinTone == "가을딥" || unwrappedSkinTone == "겨울딥" {
                frag = UIImage(named: "woody.jpeg")
            } else if unwrappedSkinTone == "봄라이트" || unwrappedSkinTone == "봄비비드" {
                frag = UIImage(named: "flower.jpeg")
                print("flower")
            } else if unwrappedSkinTone == "여름브라이트" || unwrappedSkinTone == "겨울브라이트" {
                frag = UIImage(named: "fresh.jpeg")
            } else if unwrappedSkinTone == "가을뮤트" {
                frag = UIImage(named: "oriental.jpeg")
            } else if unwrappedSkinTone == "여름뮤트" {
                frag = UIImage(named: "aroma.jpeg")
            }
        } else {
        }
        rec.image = frag
        
        backView.addSubview(rec)
        rec.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rec.widthAnchor.constraint(equalTo: backView.widthAnchor, constant: -40),
            rec.heightAnchor.constraint(equalToConstant: 120),
            rec.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            rec.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ])
        
    
  
        // descript
        let textLabel = UILabel()
        textLabel.text = resultContent[idx] // Use the dynamic text variable
        textLabel.font = UIFont(name: "Cinzel-Bold", size: 18)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: rec.bottomAnchor, constant: 12),
            textLabel.centerXAnchor.constraint(equalTo: backview.centerXAnchor)
//            textLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
//            textLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10)
            
        ])
        
        
       
//        let moreBtn = UIButton()
//        moreBtn.setImage(UIImage(named: "more"), for: .normal)
//        moreBtn.translatesAutoresizingMaskIntoConstraints = false
//
//        backView.addSubview(moreBtn)
//
//        moreBtn.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//            moreBtn.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -25),
//            moreBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
//            moreBtn.heightAnchor.constraint(equalToConstant: 35),
//            moreBtn.widthAnchor.constraint(equalToConstant: 35)
//        ])
//
//
//
//        let shareBtn = UIButton()
//        shareBtn.setImage(UIImage(named: "share"), for: .normal)
//        shareBtn.contentMode = .center
//        shareBtn.translatesAutoresizingMaskIntoConstraints = false
//
//        backView.addSubview(shareBtn)
//
//        shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//            shareBtn.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -16),
//            shareBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
//            shareBtn.heightAnchor.constraint(equalToConstant: 35),
//            shareBtn.widthAnchor.constraint(equalToConstant: 35)
//        ])
    
    }
    
    
    // Target method to handle button tap event
//    @objc func moreBtnTapped() {
//        guard let fragVC = self.storyboard?.instantiateViewController(withIdentifier: "fragViewController")as? fragViewController
//        else{return}
//
//        // fragVC에 직선형인지 곡선형인지, 퍼컬 8개중 뭐인지 보내기(두가지 데이터 붙여야함)
//        fragVC.skinTone = self.skinTone
//
//        self.navigationController?.pushViewController(fragVC, animated: true)
//    }
    
    @objc func shareBtnTapped(){
        // 카카오톡 설치여부 확인
//        if ShareApi.isKakaoTalkSharingAvailable() {
//            // 카카오톡으로 카카오톡 공유 가능
//            ShareApi.shared.shareCustom(templateId: templateId, templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("shareCustom() success.")
//                    if let sharingResult = sharingResult {
//                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//        }
//        else {
//            // 카카오톡 미설치: 웹 공유 사용 권장
//            // Custom WebView 또는 디폴트 브라우져 사용 가능
//            // 웹 공유 예시 코드
//            if let url = ShareApi.shared.makeCustomUrl(templateId: templateId, templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {
//                self.safariViewController = SFSafariViewController(url: url)
//                self.safariViewController?.modalTransitionStyle = .crossDissolve
//                self.safariViewController?.modalPresentationStyle = .overCurrentContext
//                self.present(self.safariViewController!, animated: true) {
//                    print("웹 present success")
//                }
//            }
//        }
    }
}

extension resultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        OpenCVWrapper.recognizeImage(source)
        let floatArray = OpenCVWrapper.getResult()
        calculator = CalculatePoints.init(input: floatArray)
        calculator.calculate()
        
        var arr:[Double]=[]
        
        if indexPath.item==0{
            let array = calculator.getWidthHeight()
            arr.append(array[0])
            arr.append(array[1])
            print(arr)
            array.deallocate()
        } else if indexPath.item==1{
            let array = calculator.getThreePart()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            print(arr)
            array.deallocate()
        } else if indexPath.item==2{
            let array = calculator.getMiddleEyeWidth()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            arr.append(array[3])
            arr.append(array[4])
            arr.append(array[5])
            print(arr)
            array.deallocate()
        } else if indexPath.item==3{
            let array = calculator.getEyeWidthHeight()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            arr.append(array[3])
            print(arr)
            array.deallocate()
        } else if indexPath.item==4{
            let array = calculator.getEyeEyebrowHeight()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            arr.append(array[3])
            print(arr)
            array.deallocate()
        } else if indexPath.item==5{
            let array = calculator.getMiddleNoseLipWidth()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            print(arr)
            array.deallocate()
        } else if indexPath.item==6{
            let array = calculator.getEyePos()
            arr.append(array[0])
            arr.append(array[1])
            print(arr)
            array.deallocate()
        } else if indexPath.item==7{
            let array = calculator.getLipPos()
            arr.append(array[0])
            arr.append(array[1])
            print(arr)
            array.deallocate()
        } else if indexPath.item==8{
            let array = calculator.getLipWidthHeight()
            arr.append(array[0])
            arr.append(array[1])
            arr.append(array[2])
            arr.append(array[3])
            print(arr)
            array.deallocate()
        }

            

        guard let oneVC = self.storyboard?.instantiateViewController(withIdentifier: "oneViewController")as? oneViewController
                else{return}
        var count = MemoryLayout<UnsafeMutablePointer<Double>>.size
        count = count/MemoryLayout<Double>.size
    
        oneVC.array = arr
        oneVC.ratioType = indexPath.item + 1
        oneVC.gender = gender

        self.navigationController?.pushViewController(oneVC, animated: true)
        
    }
}

extension resultViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ratioName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: ratioName[indexPath.row], image: UIImage(named:"ff\(indexPath.row + 1)")!)
        return cell
    }
}

extension resultViewController: UICollectionViewDelegateFlowLayout {
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellItemForRow: CGFloat = 3
        let minimumSpacing: CGFloat = 2
        
        let width = (collectionViewWidth - (cellItemForRow - 1) * minimumSpacing) / cellItemForRow
        
        return CGSize(width: width, height: width * 1.05)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

