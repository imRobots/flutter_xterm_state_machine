import 'range.dart';
import 'parser_actuator.dart';
import 'constants.dart';

class ParserTable {
  final ParserActuator _actuator;
  Map<VTState, VTAction> _entryEvents = {};
  Map<VTState, VTAction> _exitEvents = {};
  Map<VTState, Map<int, VTAction>> _events = {};
  Map<VTState, Map<int, VTState>> _transitions = {};

  VTState _state = VTState.Ground;
  int _rune = 0;
  List<int> _record = [];

  List<int> _prints = [];
  List<int> _collects = [];
  List<int> _params = [];

  List<int> _oscStr = [];

  ParserTable(this._actuator) {
    _initialParserTable();
  }

  void _initialParserTable() {
    // Anywhere
    _transition(VTState.Anywhere, VTState.Ground,
        runes: [0x18, 0x1A, 0x99, 0x9A],
        ranges: [Range(0x80, 0x8F), Range(0x91, 0x97)],
        action: VTAction.Execute);
    _transition(VTState.Anywhere, VTState.Ground, runes: [0x9C]);
    _transition(VTState.Anywhere, VTState.SosPmApcString,
        runes: [0x98, 0x9E, 0x9F]);
    _transition(VTState.Anywhere, VTState.Escape, runes: [0x1B]);
    _transition(VTState.Anywhere, VTState.DcsEntry, runes: [0x90]);
    _transition(VTState.Anywhere, VTState.OscString, runes: [0x9D]);
    _transition(VTState.Anywhere, VTState.CsiEntry, runes: [0x9B]);

    // Ground
    _event(VTState.Ground, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.Ground, VTAction.Print, ranges: [Range(0x20, 0x7F)]);

    // Escape
    _entry(VTState.Escape, VTAction.Clear);
    _event(VTState.Escape, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.Escape, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.Escape, VTState.Ground,
        action: VTAction.EscDispatch,
        ranges: [Range(0x30, 0x4F), Range(0x51, 0x57), Range(0x60, 0x7E)],
        runes: [0x59, 0x5A, 0x5C]);
    _transition(VTState.Escape, VTState.EscapeIntermediate,
        action: VTAction.Collect, ranges: [Range(0x20, 0x2F)]);
    _transition(VTState.Escape, VTState.CsiEntry, runes: [0x5B]);
    _transition(VTState.Escape, VTState.SosPmApcString,
        runes: [0x58, 0x5E, 0x5F]);
    _transition(VTState.Escape, VTState.DcsEntry, runes: [0x50]);
    _transition(VTState.Escape, VTState.OscString, runes: [0x5D]);

    // EscIntermediate
    _event(VTState.EscapeIntermediate, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.EscapeIntermediate, VTAction.Collect,
        ranges: [Range(0x20, 0x2F)]);
    _event(VTState.EscapeIntermediate, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.EscapeIntermediate, VTState.Ground,
        action: VTAction.EscDispatch, ranges: [Range(0x30, 0x7E)]);

    // CsiEntry
    _entry(VTState.CsiEntry, VTAction.Clear);
    _event(VTState.CsiEntry, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.CsiEntry, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.CsiEntry, VTState.CsiParam,
        action: VTAction.Param,
        ranges: [Range(0x30, 0x39)],
        runes: [0x3A, 0x3B]);
    _transition(VTState.CsiEntry, VTState.CsiParam,
        action: VTAction.Collect, ranges: [Range(0x3C, 0x3F)]);
    _transition(VTState.CsiEntry, VTState.CsiIntermediate,
        action: VTAction.Collect, ranges: [Range(0x20, 0x2F)]);
    _transition(VTState.CsiEntry, VTState.Ground,
        action: VTAction.CsiDispatch, ranges: [Range(0x40, 0x7E)]);

    // CsiParam
    _event(VTState.CsiParam, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.CsiParam, VTAction.Param,
        ranges: [Range(0x30, 0x39)], runes: [0x3A, 0x3B]);
    _event(VTState.CsiParam, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.CsiParam, VTState.Ground,
        action: VTAction.CsiDispatch, ranges: [Range(0x40, 0x7E)]);
    _transition(VTState.CsiParam, VTState.CsiIntermediate,
        action: VTAction.Collect, ranges: [Range(0x20, 0x2F)]);
    _transition(VTState.CsiParam, VTState.CsiIgnore,
        ranges: [Range(0x3C, 0x3F)]);

    // CsiIgnore
    _event(VTState.CsiIgnore, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.CsiIgnore, VTAction.Ignore,
        ranges: [Range(0x20, 0x3F)], runes: [0x7F]);
    _transition(VTState.CsiIgnore, VTState.Ground, ranges: [Range(0x40, 0x7E)]);

    // CsiIntermediate
    _event(VTState.CsiIntermediate, VTAction.Execute,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.CsiIntermediate, VTAction.Collect,
        ranges: [Range(0x20, 0x2F)]);
    _event(VTState.CsiIntermediate, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.CsiIntermediate, VTState.CsiIgnore,
        ranges: [Range(0x30, 0x3F)]);
    _transition(VTState.CsiIntermediate, VTState.Ground,
        action: VTAction.CsiDispatch, ranges: [Range(0x40, 0x7E)]);

    // SosPmApcString
    _event(VTState.SosPmApcString, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F), Range(0x20, 0x7F)],
        runes: [0x19]);
    _transition(VTState.SosPmApcString, VTState.Ground, runes: [0x9C]);

    // OscString
    _entry(VTState.OscString, VTAction.OscStart);
    _event(VTState.OscString, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.OscString, VTAction.OscPut, ranges: [Range(0x20, 0x7F)]);
    _exit(VTState.OscString, VTAction.OscEnd);
    _transition(VTState.OscString, VTState.Ground, runes: [0x9C]);

    // DcsEntry
    _entry(VTState.DcsEntry, VTAction.Clear);
    _event(VTState.DcsEntry, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.DcsEntry, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.DcsEntry, VTState.DcsIntermediate,
        action: VTAction.Collect, ranges: [Range(0x20, 0x2F)]);
    _transition(VTState.DcsEntry, VTState.DcsIgnore, runes: [0x3A]);
    _transition(VTState.DcsEntry, VTState.DcsParam,
        action: VTAction.Param, ranges: [Range(0x30, 0x39)], runes: [0x3B]);
    _transition(VTState.DcsEntry, VTState.DcsParam,
        action: VTAction.Collect, ranges: [Range(0x3C, 0x3F)]);
    _transition(VTState.DcsEntry, VTState.DcsPassThrough,
        ranges: [Range(0x40, 0x7E)]);

    // DcsIntermediate
    _event(VTState.DcsIntermediate, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.DcsIntermediate, VTAction.Collect,
        ranges: [Range(0x20, 0x2F)]);
    _event(VTState.DcsIntermediate, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.DcsIntermediate, VTState.DcsIgnore,
        ranges: [Range(0x30, 0x3F)]);
    _transition(VTState.DcsIntermediate, VTState.DcsPassThrough,
        ranges: [Range(0x40, 0x7E)]);

    // DcsParam
    _event(VTState.DcsParam, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F)], runes: [0x19]);
    _event(VTState.DcsParam, VTAction.Param,
        ranges: [Range(0x30, 0x39)], runes: [0x3B]);
    _event(VTState.DcsParam, VTAction.Ignore, runes: [0x7F]);
    _transition(VTState.DcsParam, VTState.DcsIgnore,
        ranges: [Range(0x3C, 0x3F)], runes: [0x3A]);
    _transition(VTState.DcsParam, VTState.DcsIntermediate,
        action: VTAction.Collect, ranges: [Range(0x20, 0x2F)]);
    _transition(VTState.DcsParam, VTState.DcsPassThrough,
        ranges: [Range(0x40, 0x7E)]);

    // DcsIgnore
    _event(VTState.DcsIgnore, VTAction.Ignore,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F), Range(0x20, 0x2F)],
        runes: [0x19]);
    _transition(VTState.DcsIgnore, VTState.Ground, runes: [0x9C]);

    // DcsPassthrough
    _entry(VTState.DcsPassThrough, VTAction.DcsHook);
    _event(VTState.DcsPassThrough, VTAction.DcsPut,
        ranges: [Range(0x00, 0x17), Range(0x1C, 0x1F), Range(0x20, 0x7E)],
        runes: [0x19]);
    _event(VTState.DcsPassThrough, VTAction.Ignore, runes: [0x7F]);
    _exit(VTState.DcsPassThrough, VTAction.DcsUnhook);
    _transition(VTState.DcsPassThrough, VTState.Ground, runes: [0x9C]);
  }

  void _entry(VTState state, VTAction action) {
    _entryEvents[state] = action;
  }

  void _event(VTState state, VTAction action,
      {List<Range>? ranges, List<int>? runes}) {
    if (!_events.containsKey(state)) {
      _events[state] = {};
    }
    if (ranges != null) {
      for (var range in ranges) {
        for (var i in range.toList()) {
          _events[state]![i] = action;
        }
      }
    }
    if (runes != null) {
      for (var i in runes) {
        _events[state]![i] = action;
      }
    }
  }

  void _exit(VTState state, VTAction action) {
    _exitEvents[state] = action;
  }

  void _transition(VTState state, VTState next,
      {VTAction? action, List<Range>? ranges, List<int>? runes}) {
    if (action != null) {
      _event(state, action, ranges: ranges, runes: runes);
    }
    if (!_transitions.containsKey(state)) {
      _transitions[state] = {};
    }
    if (ranges != null) {
      for (var range in ranges) {
        for (var i in range.toList()) {
          _transitions[state]![i] = next;
        }
      }
    }
    if (runes != null) {
      for (var i in runes) {
        _transitions[state]![i] = next;
      }
    }
  }

  void parse(Runes runes) {
    for (var rune in runes) {
      _rune = rune;
      if (rune >= 0xA0 && rune <= 0xFF) rune = rune - 0x80;
      if (rune >= 0x00 && rune <= 0x9F) {
        if (_actionFromAnywhere(rune)) continue;
        if (_events.containsKey(_state) && _events[_state]!.containsKey(rune)) {
          _doAction(_events[_state]![rune]!, _rune);
        }
        if (_transitions.containsKey(_state) &&
            _transitions[_state]!.containsKey(rune)) {
          _enterNextState(_transitions[_state]![rune]!);
        }
      } else {
        switch (_state) {
          case VTState.Ground:
            _prints.add(_rune);
            break;
          case VTState.OscString:
            _oscStr.add(_rune);
            break;
          default:
            assert(false, 'error: rune > 0xFF -> rune: $rune state:$_state');
            break;
        }
      }
    }
    _tryPrint();
  }

  void _tryPrint() {
    if (_state == VTState.Ground && _prints.isNotEmpty) {
      _actuator.print(String.fromCharCodes(_prints));
      _prints.clear();
    }
  }

  void _doAction(VTAction action, [int rune = 0]) {
    switch (action) {
      case VTAction.Ignore:
        break;
      case VTAction.Print:
        _prints.add(rune);
        break;
      case VTAction.Execute:
        _actuator.execute(rune);
        break;
      case VTAction.Clear:
        _collects.clear();
        _params.clear();
        _oscStr.clear();
        break;
      case VTAction.Collect:
        _collects.add(rune);
        _record.add(rune);
        break;
      case VTAction.Param:
        _params.add(rune);
        _record.add(rune);
        break;
      case VTAction.EscDispatch:
        _record.add(rune);
        var id = String.fromCharCodes([..._collects, rune]);
        if (EscCodeMaps.containsKey(id)) {
          _actuator.escDispatch(EscCodeMaps[id]!);
        } else {
          _prints.addAll([0x1B, ..._record]);
        }
        _collects.clear();
        _params.clear();
        _record.clear();
        break;
      case VTAction.CsiDispatch:
        _record.add(rune);
        var id = String.fromCharCodes([..._collects, rune]);
        var params = String.fromCharCodes(_params)
            .split(RegExp(r'[;:]'))
            .map((e) => int.tryParse(e) ?? -1);
        if (CsiCodeMaps.containsKey(id)) {
          _actuator.csiDispatch(CsiCodeMaps[id]!, params.toList());
        } else {
          _prints.addAll([0x1B, 0x5B, ..._record]);
        }
        _collects.clear();
        _params.clear();
        _record.clear();
        break;
      case VTAction.DcsHook:
        break;
      case VTAction.DcsPut:
        break;
      case VTAction.DcsUnhook:
        break;
      case VTAction.OscStart:
        _oscStr.clear();
        break;
      case VTAction.OscPut:
        _oscStr.add(rune);
        break;
      case VTAction.OscEnd:
        var str = String.fromCharCodes(_oscStr);
        _actuator.oscDispatch(str);
        _oscStr.clear();
        break;
    }
  }

  bool _actionFromAnywhere(int rune) {
    if (_transitions[VTState.Anywhere]!.containsKey(rune)) {
      var next = _transitions[VTState.Anywhere]![rune]!;
      if (_events[VTState.Anywhere]!.containsKey(rune)) {
        var action = _events[VTState.Anywhere]![rune]!;
        _doAction(action, _rune);
      }
      _enterNextState(next);
      return true;
    }
    return false;
  }

  void _enterNextState(VTState next) {
    if (_exitEvents.containsKey(_state)) {
      _doAction(_exitEvents[_state]!);
    }
    _tryPrint();
    _state = next;
    if (_entryEvents.containsKey(_state)) {
      _doAction(_entryEvents[_state]!);
    }
  }
}

enum VTState {
  Anywhere,
  Ground,
  Escape,
  EscapeIntermediate,
  CsiEntry,
  CsiIntermediate,
  CsiIgnore,
  CsiParam,
  OscString,
  SosPmApcString,
  DcsEntry,
  DcsIgnore,
  DcsIntermediate,
  DcsParam,
  DcsPassThrough
}

enum VTAction {
  Ignore,
  Print,
  Execute,
  Clear,
  Collect,
  Param,
  EscDispatch,
  CsiDispatch,
  DcsHook,
  DcsPut,
  DcsUnhook,
  OscStart,
  OscPut,
  OscEnd
}
