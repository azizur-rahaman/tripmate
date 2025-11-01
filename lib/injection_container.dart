import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripmate/core/networks/network_info.dart';
import 'package:tripmate/features/city_search/domain/usecases/search_history.dart';
import 'package:tripmate/features/city_search/presentation/city_search_bloc.dart';

import 'features/city_search/data/datasources/city_local_data_source.dart';
import 'features/city_search/data/datasources/city_remote_data_source.dart';
import 'features/city_search/data/models/city_model.dart';
import 'features/city_search/data/repositories/city_repository_impl.dart';
import 'features/city_search/domain/repositories/city_repository.dart';
import 'features/city_search/domain/usecases/clear_search_history.dart';
import 'features/city_search/domain/usecases/search_cities.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ Features - City Search ============
  
  // Bloc
  sl.registerFactory(
    () => CitySearchBloc(
      searchCities: sl(),
      getSearchHistory: sl(),
      clearSearchHistory: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SearchCities(sl()));
  sl.registerLazySingleton(() => GetSearchHistory(sl()));
  sl.registerLazySingleton(() => ClearSearchHistory(sl()));

  // Repository
  sl.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<CityRemoteDataSource>(
    () => CityRemoteDataSourceImpl(
      geoDbApi: sl(),
      weatherApi: sl(),
      unsplashApi: sl(),
    ),
  );

  sl.registerLazySingleton<CityLocalDataSource>(
    () => CityLocalDataSourceImpl(sl()),
  );

  // ============ Core ============
  
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ============ External ============
  
  // Isar Database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CityModelSchema],
    directory: dir.path,
  );
  sl.registerLazySingleton(() => isar);

  // Dio
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  sl.registerLazySingleton(() => dio);

  // APIs
  sl.registerLazySingleton(() => GeoDbApi(sl()));
  sl.registerLazySingleton(() => WeatherApi(sl()));
  sl.registerLazySingleton(() => UnsplashApi(sl()));

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());
}