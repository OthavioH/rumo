import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/user/controllers/search_users_controller.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorar'),
      ),
      body: Builder(
        builder: (context) {
          final usersAsync = ref.watch(searchUsersControllerProvider);
          if(usersAsync.isLoading || usersAsync.valueOrNull == null) {
            return Center(child: CircularProgressIndicator());
          }
          final users = usersAsync.valueOrNull!;
          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            itemCount: users.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: Text('Seguir'),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
