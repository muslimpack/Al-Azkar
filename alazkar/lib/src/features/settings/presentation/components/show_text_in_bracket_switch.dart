import 'package:alazkar/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowTextInBracketsSwitch extends StatelessWidget {
  const ShowTextInBracketsSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text("إظهار ما بين قوسين"),
          subtitle: const Text("رؤية ما بين الأقواس في الأذكار"),
          value: state.showTextInBrackets,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleShowTextInBrackets();
          },
        );
      },
    );
  }
}
