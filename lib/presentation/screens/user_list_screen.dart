import 'package:aviaraassignment/presentation/providers/user_provider.dart';
import 'package:aviaraassignment/presentation/screens/user_detail_screen.dart';
import 'package:aviaraassignment/presentation/widgets/error_widget.dart';
import 'package:aviaraassignment/presentation/widgets/loading_shimmer.dart';
import 'package:aviaraassignment/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userNotifierProvider.notifier).fetchUsers());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(userNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                ref.read(userNotifierProvider.notifier).searchUsers(value);
              },
            ),
          ),
          Expanded(
            child: state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingShimmer(),
              error: (message) => ErrorView(
                message: message,
                onRetry: () => ref.read(userNotifierProvider.notifier).fetchUsers(),
              ),
              empty: () => const Center(child: Text('No users found.')),
              success: (users, filteredUsers, hasMore, isPaginating) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredUsers.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredUsers.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final user = filteredUsers[index];
                    return UserCard(
                      user: user,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
