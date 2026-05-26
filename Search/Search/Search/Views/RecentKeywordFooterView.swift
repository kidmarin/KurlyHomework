import SnapKit
import UIKit

protocol RecentKeywordFooterViewDelegate: AnyObject {
    func deleteAllKeywordTapped(on footer: RecentKeywordFooterView)
}

final class RecentKeywordFooterView: UITableViewHeaderFooterView {

    weak var delegate: RecentKeywordFooterViewDelegate?

    // MARK: - UI

    private let deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension RecentKeywordFooterView {
    private func setupUI() {
        contentView.addSubview(deleteAllButton)
        let action = UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.deleteAllKeywordTapped(on: self)
        })
        deleteAllButton.addAction(action, for: .touchUpInside)
    }

    private func setupLayout() {
        deleteAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Const
extension RecentKeywordFooterView {
    enum Const {
        static let identifier = "RecentKeywordFooterView"
    }
}
