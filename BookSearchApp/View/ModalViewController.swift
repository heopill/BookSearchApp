//
//  ModalViewController.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/13/25.
//

import UIKit

class ModalViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "작가"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.layer.borderWidth = 0.5 // 확인용 border
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명 책 설명"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var cancelButton: UIButton = { 
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchDown)
        return button
    }()

    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle("담기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8 
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchDown)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc private func cancelButtonTapped() {
        print("X 버튼 클릭")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cartButtonTapped() {
        print("담기 버튼 클릭")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .orange
        
        [titleLabel, authorLabel, imageView, priceLabel, contentsLabel, cancelButton, cartButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(authorLabel.snp.bottom).offset(15)
            make.width.equalTo(270)
            make.height.equalTo(400)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(15)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(cartButton.snp.width).multipliedBy(0.25)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        cartButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
}
