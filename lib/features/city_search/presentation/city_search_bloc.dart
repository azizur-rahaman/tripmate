import 'package:tripmate/core/usecases/usecase.dart';
import 'package:tripmate/features/city_search/domain/usecases/clear_search_history.dart';
import 'package:tripmate/features/city_search/domain/usecases/search_cities.dart';
import 'package:tripmate/features/city_search/domain/usecases/search_history.dart';
import 'package:tripmate/features/city_search/presentation/bloc/city_search_event.dart';
import 'package:tripmate/features/city_search/presentation/bloc/city_search_state.dart';
import 'package:bloc/bloc.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState>{
  final SearchCities searchCities;
  final GetSearchHistory getSearchHistory;
  final ClearSearchHistory clearSearchHistory;

  CitySearchBloc({
    required this.searchCities,
    required this.getSearchHistory,
    required this.clearSearchHistory
  }): super(CitySearchInitial()) {
    on<SearchCitiesEvent>(_onSearchCities);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
  }

  Future<void> _onSearchCities(
    SearchCitiesEvent event,
    Emitter<CitySearchState> emit
  ) async {
    if(event.query.isEmpty){
      emit(CitySearchEmpty());
      return;
    }

    emit(CitySearchLoading());

    final result = await searchCities(SearchCitiesParams(event.query));

    result.fold(
      (failure) => emit(CitySearchError(failure.message)), 
      (cities) {
        if(cities.isEmpty){
          emit(CitySearchEmpty());
        }else{
          emit(CitySearchLoaded(cities));
        }
      });
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<CitySearchState> emit
  ) async {
    final result = await getSearchHistory(NoParams());

    result.fold(
      (failure) => emit(CitySearchError(failure.message)), 
      (history) => emit(SearchHistoryLoaded(history))
      );
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<CitySearchState> emit
  ) async {
    await clearSearchHistory(NoParams());
    emit(const SearchHistoryLoaded([]));
  }

}