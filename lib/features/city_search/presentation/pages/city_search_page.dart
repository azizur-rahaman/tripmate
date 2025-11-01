
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripmate/features/city_search/presentation/bloc/city_search_event.dart';
import 'package:tripmate/features/city_search/presentation/bloc/city_search_state.dart';
import 'package:tripmate/features/city_search/presentation/city_search_bloc.dart';
import 'package:tripmate/features/city_search/presentation/widgets/city_card.dart';
import 'package:tripmate/features/city_search/presentation/widgets/recent_searches_section.dart';
import 'package:tripmate/features/city_search/presentation/widgets/search_bar_widget.dart';
import 'package:tripmate/injection_container.dart';

class CitySearchPage extends StatelessWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CitySearchBloc>()
        ..add(LoadSearchHistoryEvent()),
      child: const CitySearchView(),
    );
  }
}

class CitySearchView extends StatelessWidget {
  const CitySearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Cities'),
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              context.read<CitySearchBloc>().add(SearchCitiesEvent(query));
            },
            onClear: () {
              context.read<CitySearchBloc>().add(LoadSearchHistoryEvent());
            },
          ),
          
          Expanded(
            child: BlocBuilder<CitySearchBloc, CitySearchState>(
              builder: (context, state) {
                if (state is CitySearchInitial) {
                  return const Center(
                    child: Text('Start searching for cities'),
                  );
                }
                
                if (state is CitySearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is CitySearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CitySearchBloc>()
                                .add(LoadSearchHistoryEvent());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('View Recent Searches'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is CitySearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cities found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching with a different term',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is CitySearchLoaded) {
                  return ListView.builder(
                    itemCount: state.cities.length,
                    itemBuilder: (context, index) {
                      final city = state.cities[index];
                      return CityCard(
                        city: city,
                        onTap: () {
                          // Navigate to city details (implement later)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Clicked on ${city.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                
                if (state is SearchHistoryLoaded) {
                  return RecentSearchesSection(
                    recentSearches: state.history,
                    onClearHistory: () {
                      context.read<CitySearchBloc>()
                          .add(ClearSearchHistoryEvent());
                    },
                    onCityTap: (city) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${city.name} from history'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}