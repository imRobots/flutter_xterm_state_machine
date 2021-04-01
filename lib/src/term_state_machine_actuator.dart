import 'term_types.dart';

abstract class TermStateMachineActuator {
  void printText(String text);

  // c0
  bool bell(); // BEL
  bool backspace(); // BS
  bool carriageReturn(); // CR
  bool returnTerminalStatus(); // ENQ
  bool formFeedOrNewPage(); // FF
  bool lineFeedOrNewLine(); // LF
  bool switchStandardCharacter(); // SI
  bool switchAlternateCharacter(); // SO
  bool space(); // SP
  bool horizontalTab(); // TAB, HT
  bool verticalTab(); // VT

  // esc and c1
  bool index(); // IND
  bool nextLine(); // NEL
  bool horizontalTabSet(); // HTS
  bool reverseIndex(); // RI

  bool screenAlignmentTest(); // DECALN
  bool backIndex(); // DECBI
  bool saveCursor(); // DECSC
  bool restoreCursor(); // DECRC
  bool forwardIndex(); // DECFI
  bool applicationKeypad(); // DECKPAM
  bool normalKeypad(); // DECKPNM

  // csi
  bool insertBlackCharacter(int count); // ICH
  bool shiftLeft(int count); // SL
  bool cursorUp(int count); // CUU
  bool shiftRight(int count); // SR
  bool cursorDown(int count); // CUD
  bool cursorForward(int count); // CUF
  bool cursorBackward(int count); // CUB
  bool cursorNextLine(int count); // CNL
  bool cursorPrevLine(int count); //  CPL
  bool cursorCharacterAbsolute(int column); // CHA
  bool cursorPosition(int row, int column); // CUP
  bool cursorForwardTab(int count); // CHT
  bool eraseInDisplay(int type); // ED, DECSED
  bool eraseInLine(int type); // EL, DECSEL
  bool insertLine(int count); // IL
  bool deleteLine(int count); // DL
  bool deleteCharacter(int count); // DCH
  bool scrollUp(int count); // SU
  bool scrollDown(int count); // SD
  bool eraseCharacter(int count); // ECH
  bool cursorBackwardTab(int count); // CBT
  bool characterPositionAbsolute(int column); // HPA
  bool characterPositionRelative(int column); // HPR
  bool repeatPreCharacter(int count); // REP
  bool sendPrimaryDeviceAttributes(); // DA
  bool sendTertiaryDeviceAttributes(); // DA1
  bool sendSecondaryDeviceAttributes(); // DA2
  bool linePositionAbsolute(int row); // VPA
  bool linePositionRelative(int row); // VPR
  bool horizontalAndVerticalPosition(int row, int column); // HVP
  // TBC
  bool clearCurrentColumnTab();
  bool clearAllTab();

  // mode set
  bool modeChange(XTermMode mode);
  // DECSET
  bool cursorBlinking(bool enable);
  bool cursorShowOrHide(bool enable);
  bool useAlternateScreenBuffer();
  bool useNormalScreenBuffer();
  bool startBracketedPaste();
  bool endBracketedPaste();

  // SGR
  bool fontStyleChange();

  // osc
  bool setWindowIconName(String iconName);
  bool setWindowTitle(String title);
}
