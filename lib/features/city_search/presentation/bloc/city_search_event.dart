import 'package:equatable/equatable.dart';

abstract class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object> get props => [];
}

class SearchCitiesEvent extends CitySearchEvent {
  final String query;

  const SearchCitiesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadSearchHistoryEvent extends CitySearchEvent {}
class ClearSearchHistoryEvent extends CitySearchEvent {}