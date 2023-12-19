//
//  CollectionViewCell.swift
//  swiftCV2
//
//  Created by 정희원 on 2023/05/15.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet var ratioName: UILabel!
    @IBOutlet var ratioImage: UIImageView!
    
    static let identifier = "CollectionViewCell"
 
    private var cornerRadius: CGFloat = 14.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureShadow()
    }
    private func configureShadow() {
        // How blurred the shadow should be
        layer.shadowRadius = 2

        // How far the shadow is offset from the cell's frame
        layer.shadowOffset = CGSize(width: 0, height: 2)

        // The transparency of the shadow. Ranging from 0.0 (transparent) to 1.0 (opaque).
        layer.shadowOpacity = 0.25

        // The default color is black
        layer.shadowColor = UIColor.black.cgColor
        
        // To avoid the shadow to be clipped to the corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    private func configureLayout() {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    public func configure(with label: String, image: UIImage) {
        ratioName.text = label
        ratioName.font = UIFont(name: "Cinzel-Bold", size: 15)
        ratioImage.image = image
        ratioImage.contentMode = .scaleAspectFit
        ratioImage.frame.size = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.width-10)
    }
    
    static func nib()-> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
