import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../shared/models/project_model.dart';
import '../../kanban/domain/objects/kanban_view_data.dart';
import '../../kanban/presentation/views/kanban_view/cubit/kanban_cubit.dart';
import '../../kanban/presentation/views/kanban_view/kanban_view.dart';
import '../../project/presentation/cubit/project_store_cubit.dart';

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
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(i18n.appTitle),
      ),
      body: UnfocusInputField(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            BlocBuilder<ProjectStoreCubit, ProjectStoreState>(
              builder: (context, state) {
                if (state is! ProjectStoreLoaded) {
                  return const SizedBox.shrink();
                }

                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: _KanbanSearchRow(),
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

                  final columnsData = parseKanbanData(state.project);

                  return BlocProvider<KanbanCubit>(
                    create: (context) => AppKanbanCubit(
                      columnsData: columnsData,
                      taskRepository: context.read(),
                    ),
                    child: KanbanView(project: state.project),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<KanbanColumnViewData> parseKanbanData(Project project) {
    final columnsData = <KanbanColumnViewData>[];

    for (final section in project.sections) {
      columnsData.add(
        KanbanColumnViewData(
          section: section,
          tasks: project.tasks.where((element) => element.sectionId == section.id).toList()
            ..sort((a, b) => a.order.compareTo(b.order)),
        ),
      );
    }

    return columnsData;
  }
}

// TODO: Connect filter to states
class _KanbanSearchRow extends StatelessWidget {
  const _KanbanSearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              hintText: i18n.home.label.searchTaskHint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              fillColor: AppColors.lightGrey,
              prefixIcon: const AssetWidget(
                Assets.searchIcon,
                color: AppColors.grey,
                fit: BoxFit.scaleDown,
              ),
              hintStyle: const TextStyle(color: AppColors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.outlineGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
            ),
          ),
        ),
        const Gap(8),
        IconButton(
          constraints: BoxConstraints.tight(const Size.square(48)),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(
              color: AppColors.outlineGrey,
            ),
          ),
          icon: const AssetWidget(
            Assets.filterIcon,
            color: AppColors.grey,
          ),
        )
        // IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.filter)),
      ],
    );
  }
}
