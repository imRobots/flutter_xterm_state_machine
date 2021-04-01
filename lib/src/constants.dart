/**
 * C0 control codes
 * See = https://en.wikipedia.org/wiki/C0_and_C1_control_codes
 */
class C0 {
  /* Null (Caret = ^@, C = \0) */
  static const NUL = 0x00;
  /* Start of Heading (Caret = ^A) */
  static const SOH = 0x01;
  /* Start of Text (Caret = ^B) */
  static const STX = 0x02;
  /* End of Text (Caret = ^C) */
  static const ETX = 0x03;
  /* End of Transmission (Caret = ^D) */
  static const EOT = 0x04;
  /* Enquiry (Caret = ^E) */
  static const ENQ = 0x05;
  /* Acknowledge (Caret = ^F) */
  static const ACK = 0x06;
  /* Bell (Caret = ^G, C = \a) */
  static const BEL = 0x07;
  /* Backspace (Caret = ^H, C = \b) */
  static const BS = 0x08;
  /* Character Tabulation, Horizontal Tabulation (Caret = ^I, C = \t) */
  static const HT = 0x09;
  /* Line Feed (Caret = ^J, C = \n) */
  static const LF = 0x0A;
  /* Line Tabulation, Vertical Tabulation (Caret = ^K, C = \v) */
  static const VT = 0x0B;
  /* Form Feed (Caret = ^L, C = \f) */
  static const FF = 0x0C;
  /* Carriage Return (Caret = ^M, C = \r) */
  static const CR = 0x0D;
  /* Shift Out (Caret = ^N) */
  static const SO = 0x0E;
  /* Shift In (Caret = ^O) */
  static const SI = 0x0F;
  /* Data Link Escape (Caret = ^P) */
  static const DLE = 0x10;
  /* Device Control One (XON) (Caret = ^Q) */
  static const DC1 = 0x11;
  /* Device Control Two (Caret = ^R) */
  static const DC2 = 0x12;
  /* Device Control Three (XOFF) (Caret = ^S) */
  static const DC3 = 0x13;
  /* Device Control Four (Caret = ^T) */
  static const DC4 = 0x14;
  /* Negative Acknowledge (Caret = ^U) */
  static const NAK = 0x15;
  /* Synchronous Idle (Caret = ^V) */
  static const SYN = 0x16;
  /* End of Transmission Block (Caret = ^W) */
  static const ETB = 0x17;
  /* Cancel (Caret = ^X) */
  static const CAN = 0x18;
  /* End of Medium (Caret = ^Y) */
  static const EM = 0x19;
  /* Substitute (Caret = ^Z) */
  static const SUB = 0x1A;
  /* Escape (Caret = ^[, C = \e) */
  static const ESC = 0x1B;
  /* File Separator (Caret = ^\) */
  static const FS = 0x1C;
  /* Group Separator (Caret = ^]) */
  static const GS = 0x1D;
  /* Record Separator (Caret = ^^) */
  static const RS = 0x1E;
  /* Unit Separator (Caret = ^_) */
  static const US = 0x1F;
  /* Space */
  static const SP = 0x20;
  /* Delete (Caret = ^?) */
  static const DEL = 0x7F;
}

/**
 * C1 control codes
 * See = https://en.wikipedia.org/wiki/C0_and_C1_control_codes
 */
class C1 {
  /* padding character */
  static const PAD = 0x80;
  /* High Octet Preset */
  static const HOP = 0x81;
  /* Break Permitted Here */
  static const BPH = 0x82;
  /* No Break Here */
  static const NBH = 0x83;
  /* Index */
  static const IND = 0x84;
  /* Next Line */
  static const NEL = 0x85;
  /* Start of Selected Area */
  static const SSA = 0x86;
  /* End of Selected Area */
  static const ESA = 0x87;
  /* Horizontal Tabulation Set */
  static const HTS = 0x88;
  /* Horizontal Tabulation With Justification */
  static const HTJ = 0x89;
  /* Vertical Tabulation Set */
  static const VTS = 0x8a;
  /* Partial Line Down */
  static const PLD = 0x8b;
  /* Partial Line Up */
  static const PLU = 0x8c;
  /* Reverse Index */
  static const RI = 0x8d;
  /* Single-Shift 2 */
  static const SS2 = 0x8e;
  /* Single-Shift 3 */
  static const SS3 = 0x8f;
  /* Device Control String */
  static const DCS = 0x90;
  /* Private Use 1 */
  static const PU1 = 0x91;
  /* Private Use 2 */
  static const PU2 = 0x92;
  /* Set Transmit State */
  static const STS = 0x93;
  /* Destructive backspace, intended to eliminate ambiguity about meaning of BS. */
  static const CCH = 0x94;
  /* Message Waiting */
  static const MW = 0x95;
  /* Start of Protected Area */
  static const SPA = 0x96;
  /* End of Protected Area */
  static const EPA = 0x97;
  /* Start of String */
  static const SOS = 0x98;
  /* Single Graphic Character Introducer */
  static const SGCI = 0x99;
  /* Single Character Introducer */
  static const SCI = 0x9a;
  /* Control Sequence Introducer */
  static const CSI = 0x9b;
  /* String Terminator */
  static const ST = 0x9c;
  /* Operating System Command */
  static const OSC = 0x9d;
  /* Privacy Message */
  static const PM = 0x9e;
  /* Application Program Command */
  static const APC = 0x9f;
}
