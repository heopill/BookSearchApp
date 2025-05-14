//
//  MainViewController.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/12/25.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: UIViewController, UISearchBarDelegate {
    
    let data = [1, 2, 3, 4, 5]
    var bookData: [Book] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 이름을 입력하세요"
        searchBar.setImage(UIImage(named: "iconSearchDarkGray"), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "iconCloseDarkGray"), for: .clear, state: .normal)
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        collectionView.register(RecentlyCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        searchBar.delegate = self
    }
    
    private func configureUI() {
        
        [searchBar, collectionView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    // 서치바 텍스트 (엔터키 입력시)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색어: \(searchBar.text ?? "")")
        searchBar.resignFirstResponder()
        fetchBooksFromKakaoAPI()
    }
    
    private func fetchData<T: Decodable>(
        url: URL,
        headers: HTTPHeaders,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
    
    func fetchBooksFromKakaoAPI() {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
              return
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let apiKey = plist?.object(forKey: "KakaoApiKey") as? String else {
              return
            }
        
        let query = "\(searchBar.text ?? "")"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        fetchData(url: url, headers: headers) { (result: Result<BookResponse, AFError>) in
            switch result {
            case .success(let response):
                print("도서 수: \(response.documents.count)")
                
                self.bookData = response.documents
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                for book in response.documents {
                    print("책 제목: \(book.title), 저자: \(book.authors.first ?? "저자 없음"), 가격: \(book.price), 책 설명: \(book.contents), 이미지: \(book.thumbnail)")
                }
                
            case .failure(let error):
                print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.createSectionZeroLayout()
            case 1:
                return self.createSectionOneLayout()
            default:
                return self.createDefaultSectionLayout()
            }
        }
        
        return layout
    }
    
    // 섹션 0 레이아웃 만들기
    private func createSectionZeroLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .absolute(100))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    // 섹션 1 레이아웃 만들기
    private func createSectionOneLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 기본 섹션 레이아웃 만들기
    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        // 1. item Size 만들기
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        
        // 2. item을 만들기
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 3.Group Size 만들기
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        // 4.group 만들기
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // 5.section 만들기
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        } else {
            return bookData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyCollectionViewCell.identifier, for: indexPath) as? RecentlyCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            }
            
            return cell1
        } else {
            
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            }
            
            let book = bookData[indexPath.item]
            let title = book.title
            let author = book.authors.first ?? "저자 없음"
            let price = book.price
            
            cell2.update(title: title, author: author, price: price)
            
            return cell2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.identifier, for: indexPath) as? CustomHeaderView else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == 0 {
                header.configure(with: "최근 본 책")
            } else if indexPath.section == 1 {
                header.configure(with: "검색 결과")
            } else {
                header.configure(with: "Header Section \(indexPath.section)")
            }
            
            return header
        }
        
        return UICollectionReusableView()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // cell 클릭 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let modalVC = ModalViewController()
            modalVC.modalPresentationStyle = .automatic
            
            // 클릭 했을 때 Modal 뷰컨트롤러 클릭된 책의 data를 같이 전달한다 present 하기 전에
            
            present(modalVC, animated: true, completion: nil)
            
            
        }
    }
}
