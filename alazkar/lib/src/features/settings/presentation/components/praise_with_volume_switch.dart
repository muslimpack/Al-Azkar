import 'package:alazkar/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PraiseWithVolumeSwitch extends StatelessWidget {
  const PraiseWithVolumeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SwitchListTile(
          secondary: const Icon(Icons.volume_down),
          value: state.praiseWithVolumeKeys,
          title: const Text("التسبيح بمفاتيح الصوت"),
          subtitle: const Text("استخدام مفاتيح الصوت للتسبيح"),
          onChanged: (value) {
            context.read<SettingsCubit>().togglePraiseWithVolumeKeys(
                  use: !state.praiseWithVolumeKeys,
                );
          },
        );
      },
    );
  }
}
