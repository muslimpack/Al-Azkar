import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/controller/cubit/zikr_source_filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZikrSourceFilterScreen extends StatefulWidget {
  const ZikrSourceFilterScreen({super.key});

  @override
  State<ZikrSourceFilterScreen> createState() => _ZikrSourceFilterScreenState();
}

class _ZikrSourceFilterScreenState extends State<ZikrSourceFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final zikrSourceFilterCubit = context.read<ZikrSourceFilterCubit>();
    return BlocBuilder<ZikrSourceFilterCubit, ZikrSourceFilterState>(
      bloc: zikrSourceFilterCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("اختيار مصدر الأذكار"),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              SwitchListTile(
                value: state.enableFilters,
                title: const Text("تفعيل تصفية الأذكار"),
                onChanged: (value) {
                  zikrSourceFilterCubit.toggleEnableFilters(value);
                },
              ),
              const Divider(),
              ...state.filters.map((filter) {
                return SwitchListTile(
                  value: filter.isActivated,
                  title: Text(filter.filter.arabicName),
                  onChanged: !state.enableFilters
                      ? null
                      : (value) {
                          zikrSourceFilterCubit.toggleFilter(filter);
                        },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
