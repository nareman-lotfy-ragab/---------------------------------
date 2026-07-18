import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/article_datasource.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleDatasource articleDatasource;

  ArticleBloc({required this.articleDatasource}) : super(ArticleInitial()) {
    on<FetchArticlesEvent>((event, emit) async {
      emit(ArticleLoading());
      try {
        final articles = await articleDatasource.fetchArticles();
        emit(ArticleLoaded(articles));
      } catch (e) {
        emit(ArticleError(e.toString()));
      }
    });
  }
}
