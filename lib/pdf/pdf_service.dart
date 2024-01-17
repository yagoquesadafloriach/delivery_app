import 'dart:io';

import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfService {
  static Future<File> generate({
    required Order order,
    required List<Food> foods,
    required mat.BuildContext buildContext,
  }) async {
    final pdf = Document()
      ..addPage(
        MultiPage(
          build: (context) => [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(order.name),
                _buildDivider(),
                _buildFoodList(order: order, foods: foods, context: buildContext),
                _buildDivider(),
                _buildTotal(order: order, foods: foods, context: buildContext),
              ],
            ),
          ],
        ),
      );

    return saveDocument(name: 'test.pdf', pdf: pdf);
  }

  static Text _buildTitle(String name) {
    return Text(
      name,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  static Column _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
      ],
    );
  }

  static Widget _buildFoodList({required Order order, required List<Food> foods, required mat.BuildContext context}) {
    final l10n = context.l10n;
    final settingsCubit = context.read<SettingsCubit>();

    final headers = [l10n.food_name, l10n.quantity, l10n.unit_price, l10n.total];
    final data = order.items
        .map((orderItem) {
          final food = foods.firstWhere(
            (element) => element.id == orderItem.foodId,
            orElse: () => Food.empty,
          );

          if (food.isEmpty) return null;

          final total = food.price! * orderItem.quantities;

          return [
            food.name ?? '',
            '${orderItem.quantities}',
            _ifEuro(settingsCubit, food.price),
            _ifEuro(settingsCubit, total),
          ];
        })
        .where((data) => data != null)
        .toList();

    final dynamicData = data.map((list) => list!.cast<dynamic>()).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: dynamicData,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static String _ifEuro(SettingsCubit settingsCubit, double? value) {
    if (settingsCubit.getCurrencyFormattedText(value: value!).contains('€')) return '$value EUR';

    return settingsCubit.getCurrencyFormattedText(value: value);
  }

  static Widget _buildTotal({required Order order, required List<Food> foods, required mat.BuildContext context}) {
    final l10n = context.l10n;
    final settingsCubit = context.read<SettingsCubit>();

    var totalPrice = 0.0;

    for (final orderItem in order.items) {
      final food = foods.firstWhere(
        (element) => element.id == orderItem.foodId,
        orElse: () => Food.empty,
      );

      if (food.isNotEmpty) {
        totalPrice += food.price! * orderItem.quantities;
      }
    }

    return Text(
      '${l10n.total}: ${settingsCubit.getCurrencyFormattedText(value: totalPrice)}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  static Future<File> saveDocument({required String name, required Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<dynamic> openFile(File file) async {
    final path = file.path;

    await OpenFilex.open(path);
  }
}
