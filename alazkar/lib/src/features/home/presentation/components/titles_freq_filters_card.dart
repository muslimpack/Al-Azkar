import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/home/data/models/titles_freq_enum.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleFreqFilterCard extends StatelessWidget {
  const TitleFreqFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<HomeBloc>(),
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const Loading();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TitlesFreqEnum.values.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: FilterChip(
                  label: Text(e.arabicName),
                  selected: state.freq.contains(e),
                  onSelected: (bool value) {
                    context.read<HomeBloc>().add(HomeToggleFilterEvent(e));
                  },
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
