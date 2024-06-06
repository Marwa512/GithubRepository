import 'package:creative_minds/features/home/presentation/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/model/repository_model.dart';
import '../bloc/states.dart';
import '../widget/repository_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final PagingController<int, Repository> _pagingController =
      PagingController(firstPageKey: 1);
        final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
     _searchController.addListener(_onSearchChanged);
    context.read<HomeCubit>().loadCachedRepositories();
  }
  void _onSearchChanged() {
    setState(() {});
  }

Future<void> _fetchPage(int pageKey) async {
    final cubit = context.read<HomeCubit>();
    await cubit.getRepositoriesList(pageKey, 10);
    final state = cubit.state;
    if (state is GetRepositorySuccessState) {
      final newItems = state.repositories;
      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } else if (state is GetRepositoryFailureState) {
      _pagingController.error = state.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "GitHub Repositories",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<HomeCubit, RepositoryState>(
        builder: (context, state) {
          if (state is RepositoryInitialState ||
              state is GetRepositoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetRepositoryFailureState) {
            return Center(
                child: Text('Failed to load repositories: ${state.error}'));
          } else if (state is GetRepositorySuccessState) {
            final searchQuery = _searchController.text.toLowerCase();
            state.repositories.where((repo) {
              return repo.name.toLowerCase().contains(searchQuery) ||
                  repo.description.toLowerCase().contains(searchQuery) ||
                  repo.ownerUsername.toLowerCase().contains(searchQuery);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        context.read<HomeCubit>().refreshRepositories(),
                    child: PagedListView<int, Repository>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Repository>(
                        itemBuilder: (context, item, index) =>
                            RepositoryListItem(item),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(); // should never reach here
        },
      ),
    );
  }
   @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}


