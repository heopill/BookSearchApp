//
//  CustomTableViewCell.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/15/25.
//

import UIKit

class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "책 제목"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.clipsToBounds = true
        return label
    }()
    
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.text = "작가 이름"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "77,777원"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        authorsLabel.text = nil
        priceLabel.text = nil
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.4
        
        [priceLabel, authorsLabel, titleLabel].forEach {
            self.addSubview($0)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalTo(priceLabel.snp.leading).inset(-10)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(authorsLabel.snp.leading).inset(-10).priority(.low)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.55)
        }
        
        
    }
    
    func update(title: String, author: String, price: Int) {
        titleLabel.text = title
        authorsLabel.text = author
        if price >= 1000000 {
            priceLabel.text = "\(price/10000)만원"
        } else if price > 0 {
            priceLabel.text = "\(price)원"
        } else {
            priceLabel.text = "구매 불가"
        }
        
    }
}
