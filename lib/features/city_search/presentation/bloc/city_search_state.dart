import 'package:equatable/equatable.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';

abstract class CitySearchState extends Equatable {
  const CitySearchState();

  @override
  List<Object> get props => [];
}

class CitySearchInitial extends CitySearchState {}
class CitySearchLoading extends CitySearchState {}
class CitySearchLoaded extends CitySearchState {
  final List<City> cities;
  
  const CitySearchLoaded(this.cities);

  @override
  List<Object> get props => [cities];
}


class SearchHistoryLoaded extends CitySearchState {
  final List<City> history;
  const SearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class CitySearchError extends CitySearchState {
  final String message;

  const CitySearchError(this.message);

  @override
  List<Object> get props => [message];
}


class CitySearchEmpty extends CitySearchState {}