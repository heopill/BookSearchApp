//
//  DetailViewController.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/12/25.
//

import UIKit
import SnapKit
import CoreData

class CartViewController: UIViewController {
    
    var bookData: [Book] = []
    
    // 싱글톤 패턴의 coredata를 사용하기 위한 코드 작성
    var coredata = CoreDataManager.shared
    var container: NSPersistentContainer!
    
    lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchDown)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "담은 책"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // view가 willAppear 될 때 coreData에서 저장된 bookData를 불러오고 tableView에 표시
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readData()
        tableView.reloadData()
    }
    
    // coreData에서 저장된 책 정보 불러오기
    private func readData() {
        // bookData를 빈 배열로 초기화
        bookData = []
        let book = coredata.readAllData()
        
        for data in book {
            let price = data.price
            guard let title = data.title,let author = data.author, let thumbnail = data.thumbnail, let contents = data.contents, let isbn = data.isbn else { return }
            
            // 불러온 책 정보들을 bookData 배열에 append
            bookData.append(Book(title: title, contents: contents, authors: author.components(separatedBy: ", "), price: Int(price), thumbnail: thumbnail, isbn: isbn))
        }
    }
    
    private func configureUI() {
        [deleteAllButton, titleLabel, addButton, tableView].forEach {
            view.addSubview($0)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 전체 삭제 버튼
    @objc private func deleteAllButtonTapped() {
        print("전체 삭제 버튼 클릭")
        // coredata에서 데이터 전체 삭제
        coredata.deleteAllData()
        
        // 테이블 뷰의 data로 사용되는 bookData 배열을 빈 배열로 초기화
        bookData.removeAll()
        
        // 삭제 후 테이블 뷰 reload
        tableView.reloadData()
    }
    
    // 추가 버튼
    @objc private func addButtonTapped() {
        print("추가 버튼 클릭")
        
        // 첫번째 탭으로 이동 하기
        self.tabBarController?.selectedIndex = 0
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    // cell의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 투명한 뷰 (border 사이의 간격을 위해)
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    // 섹션간 여백 footer에서 5
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    // 섹션당 표시할 데이터는 1개
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // bookData의 count 만큼 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookData.count
    }
    
    // tabelView cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell ?? CustomCell()
        let book = bookData[indexPath.section]
        let title = book.title
        let author = book.authors.first ?? "저자 없음"
        let price = book.price
        
        cell.update(title: title, author: author, price: price)
        return cell
    }
    
    // 왼쪽으로 스와이프 했을 때 데이터 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let book = self.bookData[indexPath.item]
            self.coredata.deleteData(isbn: book.isbn)
            self.bookData.remove(at: indexPath.item)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
