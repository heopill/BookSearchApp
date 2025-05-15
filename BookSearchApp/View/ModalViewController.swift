//
//  ModalViewController.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/13/25.
//

import UIKit
import Alamofire
import CoreData

class ModalViewController: UIViewController {
    var coredata = CoreDataManager.shared
    var container: NSPersistentContainer!
    
    let bookData: Book
    
    init(bookData: Book, nibName: String? = nil, bundle:Bundle? = nil) {
        self.bookData = bookData
        super.init(nibName: nibName, bundle: bundle) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView()
    private let innerView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
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
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchDown)
        return button
    }()

    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle("담기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        updateUI()
    }
    
    @objc private func cancelButtonTapped() {
        print("X 버튼 클릭")
        
        // Modal 내리기
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cartButtonTapped() {
        print("담기 버튼 클릭")
        
        coredata.createData(title: bookData.title, author: bookData.authors.joined(separator: ", "), price: bookData.price, thumbnail: bookData.thumbnail, contents: bookData.contents, isbn: bookData.isbn)
        
        // Modal 내리기
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white

        // view에 scrollView 추가
        view.addSubview(scrollView)
        // scrollView에 innerView 추가
        scrollView.addSubview(innerView)
        
        // innerView안에 들어갈 요소들 추가
        [titleLabel, authorLabel, imageView, priceLabel, contentsLabel].forEach {
            innerView.addSubview($0)
        }
        
        // 버튼들은 스크롤 영역에 관계없이 사용하기 위해서 플로팅 형식으로 view에 추가
        [cancelButton, cartButton].forEach {
            view.addSubview($0)
        }
        
        // scrollView constraints 설정
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top).offset(-20)
        }
        
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(authorLabel.snp.bottom).offset(20)
            make.width.equalTo(270)
            make.height.equalTo(400)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
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
    
    func updateUI() {
        titleLabel.text = bookData.title
        authorLabel.text = bookData.authors.first
        priceLabel.text = "\(bookData.price)원"
        contentsLabel.text = bookData.contents
        
        AF.request(bookData.thumbnail).responseData { response in
            if let data = response.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
    }
}
