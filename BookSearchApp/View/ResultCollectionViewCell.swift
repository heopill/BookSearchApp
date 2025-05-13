//
//  CustomCollectionViewCell.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/13/25.
//

import UIKit
import SnapKit

final class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "책 제목"
        label.font = .systemFont(ofSize: 23)
        label.textColor = .black
        return label
    }()
    
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.text = "작가 이름"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "77,777원"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
//    override func prepareForReuse() {
//        titleLabel.text = nil
//        authorsLabel.text = nil
//        priceLabel.text = nil
//    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.4
        
        [titleLabel, authorsLabel, priceLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(45)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(25)
        }
    }
    
    func update(text: String) {
        titleLabel.text = text
    }
    
}

