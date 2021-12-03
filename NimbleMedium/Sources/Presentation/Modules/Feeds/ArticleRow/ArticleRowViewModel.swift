//
//  FeedRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol ArticleRowViewModelInput {

    func toggleFavoriteArticle()
}

// sourcery: AutoMockable
protocol ArticleRowViewModelOutput {

    var id: String { get }
    var isTogglingFavoriteArticle: Driver<Bool> { get }
    var uiModel: Driver<ArticleRow.UIModel?> { get }
    var didToggleFavoriteArticle: Signal<Bool> { get }
    var didFailToToggleFavoriteArticle: Signal<Void> { get }
}

// sourcery: AutoMockable
protocol ArticleRowViewModelProtocol: ObservableViewModel {

    var input: ArticleRowViewModelInput { get }
    var output: ArticleRowViewModelOutput { get }
}

final class ArticleRowViewModel: ObservableObject, ArticleRowViewModelProtocol {

    @Injected private var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected private var toggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let toggleFavoriteArticleTrigger = PublishRelay<Void>()
    private var articleIsFavorite: Bool
    private var articleFavoritesCount: Int

    var input: ArticleRowViewModelInput { self }
    var output: ArticleRowViewModelOutput { self }

    @PublishRelayProperty var didToggleFavoriteArticle: Signal<Bool>
    @PublishRelayProperty var didFailToToggleFavoriteArticle: Signal<Void>
    @BehaviorRelayProperty(false) var isTogglingFavoriteArticle: Driver<Bool>
    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleRow.UIModel?>

    let id: String

    init(article: Article) {
        id = article.id
        articleIsFavorite = article.favorited
        articleFavoritesCount = article.favoritesCount

        getCurrentSessionUseCase.execute()
            .subscribe(with: self) { owner, user in
                owner.$uiModel.accept(
                    .init(
                        id: article.id,
                        articleTitle: article.title,
                        articleDescription: article.description,
                        articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                        articleFavoriteCount: article.favoritesCount,
                        articleCanFavorite: user?.username != article.author.username,
                        articleIsFavorited: article.favorited,
                        authorImage: try? article.author.image?.asURL(),
                        authorName: article.author.username
                    )
                )
            }
            .disposed(by: disposeBag)

        toggleFavoriteArticleTrigger
            .withUnretained(self)
            .flatMap { $0.0.updateToggleFavoriteArticle() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest { owner, args -> Observable<Void> in
                let (isFavorite, favoritesCount) = args
                return owner.toggleFavoriteArticleTriggered(
                    owner: owner,
                    isFavorite: isFavorite,
                    favoritesCount: favoritesCount
                )
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleRowViewModel: ArticleRowViewModelInput {

    func toggleFavoriteArticle() {
        toggleFavoriteArticleTrigger.accept(())
    }
}

extension ArticleRowViewModel: ArticleRowViewModelOutput {}

// MARK: - Private

extension ArticleRowViewModel {

    private func toggleFavoriteArticleTriggered(
        owner: ArticleRowViewModel,
        isFavorite: Bool,
        favoritesCount: Int
    ) -> Observable<Void> {
        $isTogglingFavoriteArticle.accept(true)
        return toggleArticleFavoriteStatusUseCase
            .execute(slug: id, isFavorite: isFavorite)
            .do(
                onError: { _ in
                    owner.$didFailToToggleFavoriteArticle.accept(())
                    owner.updateFavoriteArticle(
                        owner.articleIsFavorite,
                        count: owner.articleFavoritesCount
                    )
                    owner.$isTogglingFavoriteArticle.accept(false)
                },
                onCompleted: {
                    owner.articleIsFavorite = isFavorite
                    owner.articleFavoritesCount = favoritesCount
                    owner.$didToggleFavoriteArticle.accept(isFavorite)
                    owner.$isTogglingFavoriteArticle.accept(false)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func updateToggleFavoriteArticle() -> Observable<(Bool, Int)> {
        guard let uiModel = $uiModel.value else { return .empty() }
        let isFavorite = uiModel.articleIsFavorited
        let count = uiModel.articleFavoriteCount + (!isFavorite ? 1 : -1)
        updateFavoriteArticle(!isFavorite, count: count)

        return .just((!isFavorite, count))
    }

    private func updateFavoriteArticle(_ isFavorite: Bool, count: Int) {
        guard var uiModel = $uiModel.value else { return }
        uiModel.articleIsFavorited = isFavorite
        uiModel.articleFavoriteCount = count
        $uiModel.accept(uiModel)
    }
}

extension Array where Element == Article {

    var viewModels: [ArticleRowViewModelProtocol] {
        map { Resolver.resolve(ArticleRowViewModelProtocol.self, args: $0) }
    }
}
