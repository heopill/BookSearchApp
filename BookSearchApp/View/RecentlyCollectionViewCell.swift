//
//  RecentlyCollectionViewCell.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/13/25.
//

import UIKit
import SnapKit
import Alamofire

class RecentlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecentlyCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        [imageView].forEach {
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
        }
        
        imageView.layer.cornerRadius = 45
    }
    
    func imageUpdate(imageURL: String) {
        let imageUrl = imageURL
        
        AF.request(imageUrl).responseData { response in
            if let data = response.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
