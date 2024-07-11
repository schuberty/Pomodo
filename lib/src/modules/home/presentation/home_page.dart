import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../project/presentation/components/kanban_view/kanban_view.dart';
import '../../project/presentation/cubit/project_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<ProjectStoreCubit>().loadMainProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        shadowColor: Colors.black,
        title: const Text('Pomodo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ProjectStoreCubit, ProjectStoreState>(
            builder: (context, state) {
              if (state is! ProjectStoreLoaded) {
                return const SizedBox.shrink();
              }

              return const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Search will go here'),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ProjectStoreCubit, ProjectStoreState>(
              builder: (context, state) {
                if (state is ProjectStoreError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is! ProjectStoreLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return KanbanView(project: state.project);
              },
            ),
            // child: KanbanView(),
          )
        ],
      ),
    );
  }
}
