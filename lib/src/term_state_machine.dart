import 'package:flutter_xterm_state_machine/flutter_xterm_state_machine.dart';

import 'parser/parser_table.dart';
import 'parser/parser_actuator.dart';
import 'parser/constants.dart';
import 'term_state_machine_actuator.dart';
import 'constants.dart';

class TermStateMachine implements ParserActuator {
  late final TermStateMachineActuator _actuator;
  late ParserTable _parser;
  XTermModes modes = XTermModes();
  XTermFontStyle fontStyle = XTermFontStyle();

  TermStateMachine() {
    _parser = ParserTable(this);
  }

  void setActuator(TermStateMachineActuator actuator) {
    _actuator = actuator;
  }

  void append(String str) {
    _parser.parse(str.runes);
  }

  @override
  bool csiDispatch(CsiActionCodes actionCodes, List<int> params) {
    assert(params.length > 0, 'why params is empty?');
    int param = params.first;
    switch (actionCodes) {
      case CsiActionCodes.ICH_InsertBlankCharacter:
        param = param > 0 ? param : 1;
        return _actuator.insertBlackCharacter(param);
      case CsiActionCodes.SL_ShiftLeft:
        param = param > 0 ? param : 1;
        return _actuator.shiftLeft(param);
      case CsiActionCodes.CUU_CursorUp:
        param = param > 0 ? param : 1;
        return _actuator.cursorUp(param);
      case CsiActionCodes.SR_ShiftRight:
        param = param > 0 ? param : 1;
        return _actuator.shiftRight(param);
      case CsiActionCodes.CUD_CursorDown:
        param = param > 0 ? param : 1;
        return _actuator.cursorDown(param);
      case CsiActionCodes.CUF_CursorForward:
        param = param > 0 ? param : 1;
        return _actuator.cursorForward(param);
      case CsiActionCodes.CUB_CursorBackward:
        param = param > 0 ? param : 1;
        return _actuator.cursorBackward(param);
      case CsiActionCodes.CNL_CursorNextLine:
        param = param > 0 ? param : 1;
        return _actuator.cursorNextLine(param);
      case CsiActionCodes.CPL_CursorPrevLine:
        param = param > 0 ? param : 1;
        return _actuator.cursorPrevLine(param);
      case CsiActionCodes.CHA_CursorHorizontalAbsolute:
        param = param > 0 ? param : 1;
        return _actuator.cursorCharacterAbsolute(param);
      case CsiActionCodes.CUP_CursorPosition:
        param = param > 0 ? param : 1;
        assert(params.length > 1, 'two param');
        int p2 = params[1];
        p2 = p2 > 0 ? p2 : 1;
        return _actuator.cursorPosition(param, p2);
      case CsiActionCodes.CHT_CursorForwardTab:
        param = param > 0 ? param : 1;
        return _actuator.cursorForwardTab(param);
      case CsiActionCodes.ED_EraseDisplay:
        param = param >= 0 ? param : 1;
        return _actuator.eraseInDisplay(param);
      case CsiActionCodes.EL_EraseLine:
        param = param >= 0 ? param : 1;
        return _actuator.eraseInLine(param);
      case CsiActionCodes.IL_InsertLine:
        param = param > 0 ? param : 1;
        return _actuator.insertLine(param);
      case CsiActionCodes.DL_DeleteLine:
        param = param > 0 ? param : 1;
        return _actuator.deleteLine(param);
      case CsiActionCodes.DCH_DeleteCharacter:
        param = param > 0 ? param : 1;
        return _actuator.deleteCharacter(param);
      case CsiActionCodes.SU_ScrollUp:
        param = param > 0 ? param : 1;
        return _actuator.scrollUp(param);
      case CsiActionCodes.SD_ScrollDown:
        param = param > 0 ? param : 1;
        return _actuator.scrollDown(param);
      case CsiActionCodes.ECH_EraseCharacters:
        param = param > 0 ? param : 1;
        return _actuator.eraseCharacter(param);
      case CsiActionCodes.CBT_CursorBackTab:
        param = param > 0 ? param : 1;
        return _actuator.cursorBackwardTab(param);
      case CsiActionCodes.HPA_HorizontalPositionAbsolute:
        param = param > 0 ? param : 1;
        return _actuator.characterPositionAbsolute(param);
      case CsiActionCodes.HPR_HorizontalPositionRelative:
        param = param > 0 ? param : 1;
        return _actuator.characterPositionRelative(param);
      case CsiActionCodes.REP_RepeatCharacter:
        param = param > 0 ? param : 1;
        return _actuator.repeatPreCharacter(param);
      case CsiActionCodes.VPA_VerticalLinePositionAbsolute:
        param = param > 0 ? param : 1;
        return _actuator.linePositionAbsolute(param);
      case CsiActionCodes.VPR_VerticalPositionRelative:
        param = param > 0 ? param : 1;
        return _actuator.linePositionRelative(param);
      case CsiActionCodes.HVP_HorizontalVerticalPosition:
        param = param > 0 ? param : 1;
        assert(params.length > 1, 'tow param');
        int p2 = params[1];
        p2 = p2 > 0 ? p2 : 1;
        return _actuator.horizontalAndVerticalPosition(param, p2);
      case CsiActionCodes.TBC_TabClear:
        param = param >= 0 ? param : 1;
        switch (param) {
          case 0:
            return _actuator.clearCurrentColumnTab();
          case 3:
            return _actuator.clearAllTab();
          default:
            return false;
        }
      case CsiActionCodes.SM_SetMode:
        return _modeSetOrReset(param, true);
      case CsiActionCodes.DECSET_PrivateModeSet:
        return _privateModeSetOrReset(param, true);
      case CsiActionCodes.RM_ResetMode:
        return _modeSetOrReset(param, false);
      case CsiActionCodes.DECRST_PrivateModeReset:
        return _privateModeSetOrReset(param, false);
      case CsiActionCodes.SGR_SetGraphicsRendition:
        return _setCharacterAttributes(params);
      default:
        return false;
    }
  }

  bool _modeSetOrReset(int type, bool enable) {
    switch (type) {
      case 2:
        modes.mKAM = enable;
        return _actuator.modeChange(XTermMode.KAM);
      case 4:
        modes.mIRM = enable;
        return _actuator.modeChange(XTermMode.IRM);
      case 12:
        modes.mSRM = enable;
        return _actuator.modeChange(XTermMode.SRM);
      case 20:
        modes.mLNM = enable;
        return _actuator.modeChange(XTermMode.LNM);
      default:
        return false;
    }
  }

  bool _privateModeSetOrReset(int type, bool enable) {
    switch (type) {
      case 1:
        modes.mDECCKM = enable;
        return _actuator.modeChange(XTermMode.DECCKM);
      case 2:
        modes.mDECANM = enable;
        return _actuator.modeChange(XTermMode.DECANM);
      case 3:
        modes.mDECCOLM = enable;
        return _actuator.modeChange(XTermMode.DECCOLM);
      case 4:
        modes.mDECSCLM = enable;
        return _actuator.modeChange(XTermMode.DECSCLM);
      case 5:
        modes.mDECSCNM = enable;
        return _actuator.modeChange(XTermMode.DECSCNM);
      case 6:
        modes.mDECOM = enable;
        return _actuator.modeChange(XTermMode.DECOM);
      case 7:
        modes.mDECAWM = enable;
        return _actuator.modeChange(XTermMode.DECAWM);
      case 8:
        modes.mDECARM = enable;
        return _actuator.modeChange(XTermMode.DECARM);
      case 12:
      case 13:
        return _actuator.cursorBlinking(enable);
      case 25:
        return _actuator.cursorShowOrHide(enable);
      case 47:
        return enable
            ? _actuator.useAlternateScreenBuffer()
            : _actuator.useNormalScreenBuffer();
      case 66:
        modes.mDECNKM = enable;
        return _actuator.modeChange(XTermMode.DECNKM);
      case 67:
        modes.mDECBKM = enable;
        return _actuator.modeChange(XTermMode.DECBKM);
      case 69:
        modes.mDECLRMM = enable;
        return _actuator.modeChange(XTermMode.DECLRMM);
      case 95:
        modes.mDECNCSM = enable;
        return _actuator.modeChange(XTermMode.DECNCSM);
      case 2004:
        return enable
            ? _actuator.startBracketedPaste()
            : _actuator.endBracketedPaste();
      default:
        return false;
    }
  }

  bool _setCharacterAttributes(List<int> params) {
    int type = params.first;
    type = type > 0 ? type : 0;
    switch (type) {
      case 0:
        fontStyle.reset();
        return _actuator.fontStyleChange();
      case 1:
        fontStyle.bold = true;
        return _actuator.fontStyleChange();
      case 2:
        fontStyle.faint = true;
        return _actuator.fontStyleChange();
      case 3:
        fontStyle.italicized = true;
        return _actuator.fontStyleChange();
      case 4:
        fontStyle.underlined = true;
        return _actuator.fontStyleChange();
      case 5:
        fontStyle.blink = true;
        return _actuator.fontStyleChange();
      case 7:
        fontStyle.inverse = true;
        return _actuator.fontStyleChange();
      case 8:
        fontStyle.invisible = true;
        return _actuator.fontStyleChange();
      case 9:
        fontStyle.crossout = true;
        return _actuator.fontStyleChange();
      case 21:
        fontStyle.doubleunderlined = true;
        return _actuator.fontStyleChange();
      case 22:
        fontStyle.bold = false;
        fontStyle.faint = false;
        return _actuator.fontStyleChange();
      case 23:
        fontStyle.italicized = false;
        return _actuator.fontStyleChange();
      case 24:
        fontStyle.underlined = false;
        fontStyle.doubleunderlined = false;
        return _actuator.fontStyleChange();
      case 25:
        fontStyle.blink = false;
        return _actuator.fontStyleChange();
      case 27:
        fontStyle.inverse = false;
        return _actuator.fontStyleChange();
      case 28:
        fontStyle.invisible = false;
        return _actuator.fontStyleChange();
      case 29:
        fontStyle.crossout = false;
        return _actuator.fontStyleChange();
      case 30:
        fontStyle.setForeColorByTag(ColorTag.Black);
        return _actuator.fontStyleChange();
      case 31:
        fontStyle.setForeColorByTag(ColorTag.Red);
        return _actuator.fontStyleChange();
      case 32:
        fontStyle.setForeColorByTag(ColorTag.Green);
        return _actuator.fontStyleChange();
      case 33:
        fontStyle.setForeColorByTag(ColorTag.Yellow);
        return _actuator.fontStyleChange();
      case 34:
        fontStyle.setForeColorByTag(ColorTag.Blue);
        return _actuator.fontStyleChange();
      case 35:
        fontStyle.setForeColorByTag(ColorTag.Magenta);
        return _actuator.fontStyleChange();
      case 36:
        fontStyle.setForeColorByTag(ColorTag.Cyan);
        return _actuator.fontStyleChange();
      case 37:
        fontStyle.setForeColorByTag(ColorTag.White);
        return _actuator.fontStyleChange();
      case 38:
        if (params.length == 6) {
          // rgb
          fontStyle.setForeColorByRGB(params[3], params[4], params[5]);
        } else if (params.length == 3) {
          // index
          fontStyle.setForeColorByIndex(params[2]);
        } else {
          return false;
        }
        return _actuator.fontStyleChange();
      case 39:
        fontStyle.setForeColorByTag(ColorTag.Default);
        return _actuator.fontStyleChange();
      case 40:
        fontStyle.setBackColorByTag(ColorTag.Black);
        return _actuator.fontStyleChange();
      case 41:
        fontStyle.setBackColorByTag(ColorTag.Red);
        return _actuator.fontStyleChange();
      case 42:
        fontStyle.setBackColorByTag(ColorTag.Green);
        return _actuator.fontStyleChange();
      case 43:
        fontStyle.setBackColorByTag(ColorTag.Yellow);
        return _actuator.fontStyleChange();
      case 44:
        fontStyle.setBackColorByTag(ColorTag.Blue);
        return _actuator.fontStyleChange();
      case 45:
        fontStyle.setBackColorByTag(ColorTag.Magenta);
        return _actuator.fontStyleChange();
      case 46:
        fontStyle.setBackColorByTag(ColorTag.Cyan);
        return _actuator.fontStyleChange();
      case 47:
        fontStyle.setBackColorByTag(ColorTag.White);
        return _actuator.fontStyleChange();
      case 48:
        if (params.length == 6) {
          // rgb
          fontStyle.setBackColorByRGB(params[3], params[4], params[5]);
        } else if (params.length == 3) {
          // index
          fontStyle.setBackColorByIndex(params[2]);
        } else {
          return false;
        }
        return _actuator.fontStyleChange();
      case 49:
        fontStyle.setBackColorByTag(ColorTag.Default);
        return _actuator.fontStyleChange();
      case 90:
        fontStyle.setForeColorByTag(ColorTag.BrightBlack);
        return _actuator.fontStyleChange();
      case 91:
        fontStyle.setForeColorByTag(ColorTag.BrightRed);
        return _actuator.fontStyleChange();
      case 92:
        fontStyle.setForeColorByTag(ColorTag.BrightGreen);
        return _actuator.fontStyleChange();
      case 93:
        fontStyle.setForeColorByTag(ColorTag.BrightYellow);
        return _actuator.fontStyleChange();
      case 94:
        fontStyle.setForeColorByTag(ColorTag.BrightBlue);
        return _actuator.fontStyleChange();
      case 95:
        fontStyle.setForeColorByTag(ColorTag.BrightMagenta);
        return _actuator.fontStyleChange();
      case 96:
        fontStyle.setForeColorByTag(ColorTag.BrightCyan);
        return _actuator.fontStyleChange();
      case 97:
        fontStyle.setForeColorByTag(ColorTag.BrightWhite);
        return _actuator.fontStyleChange();
      case 100:
        fontStyle.setBackColorByTag(ColorTag.BrightBlack);
        return _actuator.fontStyleChange();
      case 101:
        fontStyle.setBackColorByTag(ColorTag.BrightRed);
        return _actuator.fontStyleChange();
      case 102:
        fontStyle.setBackColorByTag(ColorTag.BrightGreen);
        return _actuator.fontStyleChange();
      case 103:
        fontStyle.setBackColorByTag(ColorTag.BrightYellow);
        return _actuator.fontStyleChange();
      case 104:
        fontStyle.setBackColorByTag(ColorTag.BrightBlue);
        return _actuator.fontStyleChange();
      case 105:
        fontStyle.setBackColorByTag(ColorTag.BrightMagenta);
        return _actuator.fontStyleChange();
      case 106:
        fontStyle.setBackColorByTag(ColorTag.BrightCyan);
        return _actuator.fontStyleChange();
      case 107:
        fontStyle.setBackColorByTag(ColorTag.BrightWhite);
        return _actuator.fontStyleChange();
      default:
        return false;
    }
  }

  @override
  bool escDispatch(EscActionCodes actionCodes) {
    switch (actionCodes) {
      case EscActionCodes.IND_Index:
        return _actuator.index();
      case EscActionCodes.NEL_NextLine:
        return _actuator.nextLine();
      case EscActionCodes.HTS_HorizontalTabSet:
        return _actuator.horizontalTabSet();
      case EscActionCodes.RI_ReverseIndex:
        return _actuator.reverseIndex();
      case EscActionCodes.DECALN_ScreenAlignmentTest:
        return _actuator.screenAlignmentTest();
      case EscActionCodes.DECBI_BackIndex:
        return _actuator.backIndex();
      case EscActionCodes.DECSC_CursorSave:
        return _actuator.saveCursor();
      case EscActionCodes.DECRC_CursorRestore:
        return _actuator.restoreCursor();
      case EscActionCodes.DECFI_ForwardIndex:
        return _actuator.forwardIndex();
      case EscActionCodes.DECKPAM_KeypadApplicationMode:
        return _actuator.applicationKeypad();
      case EscActionCodes.DECKPNM_KeypadNormalMode:
        return _actuator.normalKeypad();
      default:
        return false;
    }
  }

  @override
  bool oscDispatch(String str) {
    assert(str.contains(';'), 'why osc str error?');
    List<String> ts = str.split(';');
    int type = int.tryParse(ts.first) ?? -1;
    switch (type) {
      case 0:
        _actuator.setWindowIconName(ts.last);
        _actuator.setWindowTitle(ts.last);
        return true;
      case 1:
        _actuator.setWindowIconName(ts.last);
        return true;
      case 2:
        _actuator.setWindowTitle(ts.last);
        return true;
      default:
        return false;
    }
  }

  @override
  bool execute(int rune) {
    switch (rune) {
      case C0.BEL:
        return _actuator.bell();
      case C0.BS:
        return _actuator.backspace();
      case C0.CR:
        return _actuator.carriageReturn();
      case C0.ENQ:
        return _actuator.returnTerminalStatus();
      case C0.FF:
        return _actuator.formFeedOrNewPage();
      case C0.LF:
        return _actuator.lineFeedOrNewLine();
      case C0.SI:
        return _actuator.switchStandardCharacter();
      case C0.SO:
        return _actuator.switchAlternateCharacter();
      case C0.SP:
        return _actuator.space();
      case C0.HT: // TAB
        return _actuator.horizontalTab();
      case C0.VT:
        return _actuator.verticalTab();
      case C1.IND:
        return _actuator.index();
      case C1.NEL:
        return _actuator.nextLine();
      case C1.HTS:
        return _actuator.horizontalTabSet();
      default:
        return false;
    }
  }

  @override
  void print(String str) {
    _actuator.printText(str);
  }
}
