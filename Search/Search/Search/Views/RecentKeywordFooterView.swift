import SnapKit
import UIKit

final class RecentKeywordFooterView: UITableViewHeaderFooterView {
    static let identifier = "RecentKeywordFooterView"

    var onDeleteAll: (() -> Void)?

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
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        deleteAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    @objc private func deleteAllButtonTapped() {
        onDeleteAll?()
    }
}
