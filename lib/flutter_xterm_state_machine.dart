library flutter_xterm_state_machine;

import 'src/term_types.dart';
import 'src/term_state_machine_actuator.dart';
import 'src/term_state_machine.dart';

export 'src/term_types.dart';

class XTermStateMachine {
  final TermStateMachine _stateMachine;

  XTermStateMachine() : _stateMachine = TermStateMachine();

  XTermModes get modes => _stateMachine.modes;
  XTermFontStyle get fontStyle => _stateMachine.fontStyle;

  void setActuator(XTermStateMachineActuator actuator) {
    _stateMachine.setActuator(actuator);
  }

  void append(String text) {
    _stateMachine.append(text);
  }
}

abstract class XTermStateMachineActuator implements TermStateMachineActuator {}
