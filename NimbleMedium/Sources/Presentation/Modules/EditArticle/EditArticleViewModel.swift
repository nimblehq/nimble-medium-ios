//
//  EditArticleViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 19/10/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol EditArticleViewModelInput {

    func didTapUpdateButton(
        title: String,
        description: String,
        body: String,
        tagsList: String
    )

    func fetchArticleDetail()
}

protocol EditArticleViewModelOutput {

    var uiModel: Driver<EditArticleView.UIModel?> { get }
    var didFailToFetchArticleDetail: Signal<Void> { get }
    var didUpdateArticle: Signal<Void> { get }
    var didFailToUpdateArticle: Signal<Void> { get }
    var isLoading: Driver<Bool> { get }
}

protocol EditArticleViewModelProtocol: ObservableViewModel {

    var input: EditArticleViewModelInput { get }
    var output: EditArticleViewModelOutput { get }
}

final class EditArticleViewModel: ObservableObject, EditArticleViewModelProtocol {

    typealias UpdateArticleParams = (
        title: String, description: String, body: String, tagsList: [String]
    )

    private let disposeBag = DisposeBag()
    private let slug: String

    var input: EditArticleViewModelInput { self }
    var output: EditArticleViewModelOutput { self }

    @PublishRelayProperty var didUpdateArticle: Signal<Void>
    @PublishRelayProperty var didFailToUpdateArticle: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleDetail: Signal<Void>

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @BehaviorRelayProperty(nil) var uiModel: Driver<EditArticleView.UIModel?>

    @Injected var updateArticleUseCase: UpdateMyArticleUseCaseProtocol
    @Injected var getArticleUseCase: GetArticleUseCaseProtocol

    private let updateArticleTrigger = PublishRelay<UpdateArticleParams>()
    private let fetchArticleDetailTrigger = PublishRelay<Void>()

    init(slug: String) {
        self.slug = slug

        fetchArticleDetailTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleDetailTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)

        updateArticleTrigger
            .withUnretained(self)
            .flatMapLatest { owner, inputs in owner.updateArticleTriggered(owner: owner, inputs: inputs) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension EditArticleViewModel: EditArticleViewModelInput {

    func didTapUpdateButton(
        title: String,
        description: String,
        body: String,
        tagsList: String
    ) {
        $isLoading.accept(true)
        updateArticleTrigger.accept((title, description, body, tagsList.toStringsArray()))
    }

    func fetchArticleDetail() {
        fetchArticleDetailTrigger.accept(())
    }
}

extension EditArticleViewModel: EditArticleViewModelOutput {}

extension EditArticleViewModel {

    private func fetchArticleDetailTriggered(owner: EditArticleViewModel) -> Observable<Void> {
        getArticleUseCase
            .execute(slug: slug)
            .do(
                onSuccess: {
                    owner.$uiModel.accept(.init(article: $0))
                },
                onError: { _ in owner.$didFailToFetchArticleDetail.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func updateArticleTriggered(owner: EditArticleViewModel, inputs: UpdateArticleParams) -> Observable<Void> {
        updateArticleUseCase
            .execute(
                slug: owner.slug,
                params: .init(
                    title: inputs.title,
                    description: inputs.description,
                    body: inputs.body,
                    tagList: inputs.tagsList
                )
            )
            .do(
                onError: { _ in
                    owner.$isLoading.accept(false)
                    owner.$didFailToUpdateArticle.accept(())
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didUpdateArticle.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
