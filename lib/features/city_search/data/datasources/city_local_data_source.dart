import 'package:isar/isar.dart';
import 'package:tripmate/core/error/exceptions.dart';
import 'package:tripmate/features/city_search/data/models/city_model.dart';

abstract class CityLocalDataSource {
  Future<List<CityModel>> getSearchHistory();
  Future<void> cacheCity(CityModel city);
  Future<void> clearHistory();
  Future<CityModel?> getCachedCity(int cityId);
}


class CityLocalDataSourceImpl implements CityLocalDataSource {
  final Isar isar;

  CityLocalDataSourceImpl(this.isar);

  @override
  Future<List<CityModel>> getSearchHistory() async {
    try{
      final cities = await isar.cityModels
                      .where()
                      .sortBySearchedAtDesc()
                      .limit(10)
                      .findAll();
      return cities;
    }catch (e) {
      throw CacheException('Failed to get search history');
    }
  }

  @override
  Future<void> cacheCity(CityModel city) async {
    try{
       await isar.writeTxn( () async {
          // check if city already exists?
          final isExist = await isar.cityModels
          .filter()
          .cityIdEqualTo(city.cityId)
          .findFirst();

          if(isExist != null){
            // Update existing with new search time

            final updated = city.copyWith();
            await isar.cityModels.delete(isExist.isarId);
            await isar.cityModels.put(updated);
          } else {
            await isar.cityModels.put(city);
          }
       });
    } catch (e) {
      throw CacheException('Failed to cache city');
    }
  }

  @override
  Future<void> clearHistory() async {
    try{
      await isar.writeTxn(() async {
        await isar.cityModels.clear();
      });
    }catch (e) {
      throw CacheException('Failed to clear history');
    }
  }

  @override
  Future<CityModel?> getCachedCity(int cityId) async {
    try{
      return await isar.cityModels
                        .filter()
                        .cityIdEqualTo(cityId)
                        .findFirst();
    }catch (e) {
      throw CacheException('Failed to get cached city');
    }
  }
}