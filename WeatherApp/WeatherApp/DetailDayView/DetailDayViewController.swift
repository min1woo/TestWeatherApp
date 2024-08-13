//
//  DetailDayViewController.swift
//  WeatherApp
//
//  Created by 유민우 on 8/13/24.
//

import UIKit
import SnapKit

class DetailDayViewController: UIViewController {
    
    // MARK: - Property
    
    lazy var detailDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeaterDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeaterDetailCollectionViewCell.id)
        collectionView.register(DetailDaySectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailDaySectionHeaderView.id)
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Method
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(detailDayCollectionView)
        
        detailDayCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createDateSectionLayout()
            case 1:
                return self.createWeaterDetailSectionLayout()
            default:
                return nil
            }
        }
    }
    
    private func createDateSectionLayout() -> NSCollectionLayoutSection {
        // 아이템 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // 그룹 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(75), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        return section
    }
    
    private func createWeaterDetailSectionLayout() -> NSCollectionLayoutSection {
        // 아이템 설정
        // 첫 번째 아이템(병합된 셀) 설정
            let fullWidthItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let fullWidthItem = NSCollectionLayoutItem(layoutSize: fullWidthItemSize)
            
            // 두 번째 아이템 설정
            let halfWidthItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let halfWidthItem = NSCollectionLayoutItem(layoutSize: halfWidthItemSize)

            // 수평 그룹(두 개의 셀을 나란히 배치) 설정
        let halfWidthGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let halfWidthGroup = NSCollectionLayoutGroup.horizontal(layoutSize: halfWidthGroupSize, subitem: halfWidthItem, count: 2)
            halfWidthGroup.interItemSpacing = .fixed(10)

            // 최종 수직 그룹 설정 (병합된 셀 + 두 개의 셀)
            let finalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(450))
            let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: finalGroupSize, subitems: [fullWidthItem, halfWidthGroup])
            finalGroup.interItemSpacing = .fixed(10)

            // 섹션 설정
            let section = NSCollectionLayoutSection(group: finalGroup)
            section.interGroupSpacing = 10

        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}

// MARK: - Extension

extension DetailDayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return 6
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.id, for: indexPath) as! DateCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeaterDetailCollectionViewCell.id, for: indexPath) as! WeaterDetailCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("error")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailDaySectionHeaderView.id, for: indexPath) as! DetailDaySectionHeaderView
        
        headerView.configure(wiht: "2024년 08월 13일")
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
        
}
