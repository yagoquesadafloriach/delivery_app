import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  const Currency({required this.name, required this.symbol, required this.abbreviation});

  final String name;
  final String abbreviation;
  final String symbol;

  @override
  List<Object?> get props => [name, abbreviation, symbol];
}
