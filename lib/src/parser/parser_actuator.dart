import 'constants.dart';

abstract class ParserActuator {
  void print(String str);
  bool execute(int rune);
  bool escDispatch(EscActionCodes actionCodes);
  bool csiDispatch(CsiActionCodes actionCodes, List<int> params);
  bool oscDispatch(String str);
}
