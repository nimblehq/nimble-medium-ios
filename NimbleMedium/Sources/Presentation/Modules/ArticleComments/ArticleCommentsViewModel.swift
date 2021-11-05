//
//  FeedCommentsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

protocol ArticleCommentsViewModelInput {

    func fetchArticleComments()
    func createArticleComment(content: String)
}

protocol ArticleCommentsViewModelOutput {

    var didFetchArticleComments: Signal<Void> { get }
    var didFailToFetchArticleComments: Signal<Void> { get }
    var didCreateArticleComment: Signal<Void> { get }
    var didFailToCreateArticleComment: Signal<Void> { get }
    var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]> { get }
    var isCreateCommentEnabled: Driver<Bool> { get }
}

protocol ArticleCommentsViewModelProtocol: ObservableViewModel {

    var input: ArticleCommentsViewModelInput { get }
    var output: ArticleCommentsViewModelOutput { get }
}

final class ArticleCommentsViewModel: ObservableObject, ArticleCommentsViewModelProtocol {

    @Injected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocol
    @Injected var createArticleCommentUseCase: CreateArticleCommentUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchArticleCommentsTrigger = PublishRelay<Void>()
    private let createArticleCommentTrigger = PublishRelay<String>()
    private let id: String

    @PublishRelayProperty var didFetchArticleComments: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleComments: Signal<Void>
    @PublishRelayProperty var didCreateArticleComment: Signal<Void>
    @PublishRelayProperty var didFailToCreateArticleComment: Signal<Void>
    @BehaviorRelayProperty([]) var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]>
    @BehaviorRelayProperty(false) var isCreateCommentEnabled: Driver<Bool>

    var input: ArticleCommentsViewModelInput { self }
    var output: ArticleCommentsViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchArticleCommentsTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleCommentsTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)

        createArticleCommentTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.createArticleCommentTriggered(owner: $0.0, content: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelInput {

    func fetchArticleComments() {
        fetchArticleCommentsTrigger.accept(())
    }

    func createArticleComment(content: String) {
        createArticleCommentTrigger.accept(content)
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelOutput {}

// MARK: Private

extension ArticleCommentsViewModel {

    private func fetchArticleCommentsTriggered(owner: ArticleCommentsViewModel) -> Observable<Void> {
        getArticleCommentsUseCase.execute(slug: owner.id)
            .do(
                onSuccess: {
                    owner.$isCreateCommentEnabled.accept(true)
                    owner.$didFetchArticleComments.accept(())
                    owner.$articleCommentRowViewModels.accept(
                        $0.map { owner.articleCommentRowViewModel(from: $0) }
                    )
                },
                onError: { _ in
                    owner.$isCreateCommentEnabled.accept(true)
                    owner.$didFailToFetchArticleComments.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func createArticleCommentTriggered(owner: ArticleCommentsViewModel, content: String) -> Observable<Void> {
        owner.$isCreateCommentEnabled.accept(false)
        return createArticleCommentUseCase.execute(
            articleSlug: id,
            commentBody: content
        )
        .do(
            onSuccess: { _ in
                owner.$isCreateCommentEnabled.accept(true)
                owner.fetchArticleComments()
                owner.$didCreateArticleComment.accept(())
            },
            onError: { _ in
                owner.$isCreateCommentEnabled.accept(true)
                owner.$didFailToCreateArticleComment.accept(())
            }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }

    private func articleCommentRowViewModel(from comment: ArticleComment) -> ArticleCommentRowViewModelProtocol {

        let viewModel = Resolver.resolve(
            ArticleCommentRowViewModelProtocol.self,
            args: ArticleCommentRowViewModelArgs(slug: id, comment: comment)
        )
        viewModel.output.didDeleteComment
            .emit(with: self) { owner, _ in
                owner.fetchArticleComments()
            }
            .disposed(by: disposeBag)

        return viewModel
    }
}
