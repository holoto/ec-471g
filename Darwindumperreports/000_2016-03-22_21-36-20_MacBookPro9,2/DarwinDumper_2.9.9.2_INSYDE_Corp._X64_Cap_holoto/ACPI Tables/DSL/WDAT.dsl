/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20130823-32 [Sep 16 2013]
 * Copyright (c) 2000 - 2013 Intel Corporation
 * 
 * Disassembly of /Users/holoto/Desktop/Tools/DarwinDumperReports/000_2016-03-22_21-36-20_MacBookPro9,2/DarwinDumper_2.9.9.2_INSYDE_Corp._X64_Cap_holoto/ACPI Tables/AML/WDAT.aml, Tue Mar 22 21:37:29 2016
 *
 * ACPI Data Table [WDAT]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "WDAT"    [Watchdog Action Table]
[004h 0004   4]                 Table Length : 00000224
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : D2
[00Ah 0010   6]                       Oem ID : "ACRSYS"
[010h 0016   8]                 Oem Table ID : "ACRPRDCT"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "1025"
[020h 0032   4]        Asl Compiler Revision : 00040000

[024h 0036   4]                Header Length : 00000020
[028h 0040   2]                  PCI Segment : 00FF
[02Ah 0042   1]                      PCI Bus : FF
[02Bh 0043   1]                   PCI Device : FF
[02Ch 0044   1]                 PCI Function : FF
[02Dh 0045   3]                     Reserved : 000000
[030h 0048   4]                 Timer Period : 00000258
[034h 0052   4]                    Max Count : 000003FF
[038h 0056   4]                    Min Count : 00000002
[03Ch 0060   1]        Flags (decoded below) : 81
                                     Enabled : 1
                         Stopped When Asleep : 1
[03Dh 0061   3]                     Reserved : 000000
[040h 0064   4]         Watchdog Entry Count : 00000014

[044h 0068   1]              Watchdog Action : 01
[045h 0069   1]                  Instruction : 02
[046h 0070   2]                     Reserved : 0000

[048h 0072  12]              Register Region : [Generic Address Structure]
[048h 0072   1]                     Space ID : 01 [SystemIO]
[049h 0073   1]                    Bit Width : 10
[04Ah 0074   1]                   Bit Offset : 00
[04Bh 0075   1]         Encoded Access Width : 02 [Word Access:16]
[04Ch 0076   8]                      Address : 0000000000000460

[054h 0084   4]                        Value : 00000000
[058h 0088   4]                Register Mask : 000003FF

[05Ch 0092   1]              Watchdog Action : 04
[05Dh 0093   1]                  Instruction : 01
[05Eh 0094   2]                     Reserved : 0000

[060h 0096  12]              Register Region : [Generic Address Structure]
[060h 0096   1]                     Space ID : 01 [SystemIO]
[061h 0097   1]                    Bit Width : 10
[062h 0098   1]                   Bit Offset : 00
[063h 0099   1]         Encoded Access Width : 02 [Word Access:16]
[064h 0100   8]                      Address : 0000000000000460

[06Ch 0108   4]                        Value : 00000000
[070h 0112   4]                Register Mask : 000003FF

[074h 0116   1]              Watchdog Action : 05
[075h 0117   1]                  Instruction : 01
[076h 0118   2]                     Reserved : 0000

[078h 0120  12]              Register Region : [Generic Address Structure]
[078h 0120   1]                     Space ID : 01 [SystemIO]
[079h 0121   1]                    Bit Width : 10
[07Ah 0122   1]                   Bit Offset : 00
[07Bh 0123   1]         Encoded Access Width : 02 [Word Access:16]
[07Ch 0124   8]                      Address : 0000000000000472

[084h 0132   4]                        Value : 00000000
[088h 0136   4]                Register Mask : 000003FF

[08Ch 0140   1]              Watchdog Action : 06
[08Dh 0141   1]                  Instruction : 83
[08Eh 0142   2]                     Reserved : 0000

[090h 0144  12]              Register Region : [Generic Address Structure]
[090h 0144   1]                     Space ID : 01 [SystemIO]
[091h 0145   1]                    Bit Width : 10
[092h 0146   1]                   Bit Offset : 00
[093h 0147   1]         Encoded Access Width : 02 [Word Access:16]
[094h 0148   8]                      Address : 0000000000000472

[09Ch 0156   4]                        Value : 00000000
[0A0h 0160   4]                Register Mask : 000003FF

[0A4h 0164   1]              Watchdog Action : 08
[0A5h 0165   1]                  Instruction : 00
[0A6h 0166   2]                     Reserved : 0000

[0A8h 0168  12]              Register Region : [Generic Address Structure]
[0A8h 0168   1]                     Space ID : 01 [SystemIO]
[0A9h 0169   1]                    Bit Width : 10
[0AAh 0170   1]                   Bit Offset : 0B
[0ABh 0171   1]         Encoded Access Width : 02 [Word Access:16]
[0ACh 0172   8]                      Address : 0000000000000468

[0B4h 0180   4]                        Value : 00000000
[0B8h 0184   4]                Register Mask : 00000001

[0BCh 0188   1]              Watchdog Action : 09
[0BDh 0189   1]                  Instruction : 82
[0BEh 0190   2]                     Reserved : 0000

[0C0h 0192  12]              Register Region : [Generic Address Structure]
[0C0h 0192   1]                     Space ID : 01 [SystemIO]
[0C1h 0193   1]                    Bit Width : 10
[0C2h 0194   1]                   Bit Offset : 00
[0C3h 0195   1]         Encoded Access Width : 02 [Word Access:16]
[0C4h 0196   8]                      Address : 0000000000000468

[0CCh 0204   4]                        Value : 00000000
[0D0h 0208   4]                Register Mask : 00000800

[0D4h 0212   1]              Watchdog Action : 09
[0D5h 0213   1]                  Instruction : 02
[0D6h 0214   2]                     Reserved : 0000

[0D8h 0216  12]              Register Region : [Generic Address Structure]
[0D8h 0216   1]                     Space ID : 01 [SystemIO]
[0D9h 0217   1]                    Bit Width : 08
[0DAh 0218   1]                   Bit Offset : 00
[0DBh 0219   1]         Encoded Access Width : 01 [Byte Access:8]
[0DCh 0220   8]                      Address : 0000000000000070

[0E4h 0228   4]                        Value : 00000045
[0E8h 0232   4]                Register Mask : 000000FF

[0ECh 0236   1]              Watchdog Action : 09
[0EDh 0237   1]                  Instruction : 82
[0EEh 0238   2]                     Reserved : 0000

[0F0h 0240  12]              Register Region : [Generic Address Structure]
[0F0h 0240   1]                     Space ID : 01 [SystemIO]
[0F1h 0241   1]                    Bit Width : 08
[0F2h 0242   1]                   Bit Offset : 00
[0F3h 0243   1]         Encoded Access Width : 01 [Byte Access:8]
[0F4h 0244   8]                      Address : 0000000000000071

[0FCh 0252   4]                        Value : 00000001
[100h 0256   4]                Register Mask : 00000001

[104h 0260   1]              Watchdog Action : 0A
[105h 0261   1]                  Instruction : 00
[106h 0262   2]                     Reserved : 0000

[108h 0264  12]              Register Region : [Generic Address Structure]
[108h 0264   1]                     Space ID : 01 [SystemIO]
[109h 0265   1]                    Bit Width : 10
[10Ah 0266   1]                   Bit Offset : 0B
[10Bh 0267   1]         Encoded Access Width : 02 [Word Access:16]
[10Ch 0268   8]                      Address : 0000000000000468

[114h 0276   4]                        Value : 00000001
[118h 0280   4]                Register Mask : 00000001

[11Ch 0284   1]              Watchdog Action : 0B
[11Dh 0285   1]                  Instruction : 82
[11Eh 0286   2]                     Reserved : 0000

[120h 0288  12]              Register Region : [Generic Address Structure]
[120h 0288   1]                     Space ID : 01 [SystemIO]
[121h 0289   1]                    Bit Width : 10
[122h 0290   1]                   Bit Offset : 00
[123h 0291   1]         Encoded Access Width : 02 [Word Access:16]
[124h 0292   8]                      Address : 0000000000000468

[12Ch 0300   4]                        Value : 00000800
[130h 0304   4]                Register Mask : 00000800

[134h 0308   1]              Watchdog Action : 0B
[135h 0309   1]                  Instruction : 02
[136h 0310   2]                     Reserved : 0000

[138h 0312  12]              Register Region : [Generic Address Structure]
[138h 0312   1]                     Space ID : 01 [SystemIO]
[139h 0313   1]                    Bit Width : 08
[13Ah 0314   1]                   Bit Offset : 00
[13Bh 0315   1]         Encoded Access Width : 01 [Byte Access:8]
[13Ch 0316   8]                      Address : 0000000000000070

[144h 0324   4]                        Value : 00000045
[148h 0328   4]                Register Mask : 000000FF

[14Ch 0332   1]              Watchdog Action : 0B
[14Dh 0333   1]                  Instruction : 82
[14Eh 0334   2]                     Reserved : 0000

[150h 0336  12]              Register Region : [Generic Address Structure]
[150h 0336   1]                     Space ID : 01 [SystemIO]
[151h 0337   1]                    Bit Width : 08
[152h 0338   1]                   Bit Offset : 00
[153h 0339   1]         Encoded Access Width : 01 [Byte Access:8]
[154h 0340   8]                      Address : 0000000000000071

[15Ch 0348   4]                        Value : 00000000
[160h 0352   4]                Register Mask : 00000001

[164h 0356   1]              Watchdog Action : 10
[165h 0357   1]                  Instruction : 00
[166h 0358   2]                     Reserved : 0000

[168h 0360  12]              Register Region : [Generic Address Structure]
[168h 0360   1]                     Space ID : 01 [SystemIO]
[169h 0361   1]                    Bit Width : 08
[16Ah 0362   1]                   Bit Offset : 04
[16Bh 0363   1]         Encoded Access Width : 01 [Byte Access:8]
[16Ch 0364   8]                      Address : 000000000000046A

[174h 0372   4]                        Value : 00000000
[178h 0376   4]                Register Mask : 00000003

[17Ch 0380   1]              Watchdog Action : 11
[17Dh 0381   1]                  Instruction : 82
[17Eh 0382   2]                     Reserved : 0000

[180h 0384  12]              Register Region : [Generic Address Structure]
[180h 0384   1]                     Space ID : 01 [SystemIO]
[181h 0385   1]                    Bit Width : 10
[182h 0386   1]                   Bit Offset : 00
[183h 0387   1]         Encoded Access Width : 02 [Word Access:16]
[184h 0388   8]                      Address : 000000000000046A

[18Ch 0396   4]                        Value : 00000000
[190h 0400   4]                Register Mask : 00000030

[194h 0404   1]              Watchdog Action : 12
[195h 0405   1]                  Instruction : 00
[196h 0406   2]                     Reserved : 0000

[198h 0408  12]              Register Region : [Generic Address Structure]
[198h 0408   1]                     Space ID : 01 [SystemIO]
[199h 0409   1]                    Bit Width : 08
[19Ah 0410   1]                   Bit Offset : 04
[19Bh 0411   1]         Encoded Access Width : 01 [Byte Access:8]
[19Ch 0412   8]                      Address : 000000000000046A

[1A4h 0420   4]                        Value : 00000001
[1A8h 0424   4]                Register Mask : 00000003

[1ACh 0428   1]              Watchdog Action : 13
[1ADh 0429   1]                  Instruction : 82
[1AEh 0430   2]                     Reserved : 0000

[1B0h 0432  12]              Register Region : [Generic Address Structure]
[1B0h 0432   1]                     Space ID : 01 [SystemIO]
[1B1h 0433   1]                    Bit Width : 10
[1B2h 0434   1]                   Bit Offset : 00
[1B3h 0435   1]         Encoded Access Width : 02 [Word Access:16]
[1B4h 0436   8]                      Address : 000000000000046A

[1BCh 0444   4]                        Value : 00000010
[1C0h 0448   4]                Register Mask : 00000030

[1C4h 0452   1]              Watchdog Action : 20
[1C5h 0453   1]                  Instruction : 02
[1C6h 0454   2]                     Reserved : 0000

[1C8h 0456  12]              Register Region : [Generic Address Structure]
[1C8h 0456   1]                     Space ID : 01 [SystemIO]
[1C9h 0457   1]                    Bit Width : 08
[1CAh 0458   1]                   Bit Offset : 00
[1CBh 0459   1]         Encoded Access Width : 01 [Byte Access:8]
[1CCh 0460   8]                      Address : 0000000000000070

[1D4h 0468   4]                        Value : 00000045
[1D8h 0472   4]                Register Mask : 000000FF

[1DCh 0476   1]              Watchdog Action : 20
[1DDh 0477   1]                  Instruction : 00
[1DEh 0478   2]                     Reserved : 0000

[1E0h 0480  12]              Register Region : [Generic Address Structure]
[1E0h 0480   1]                     Space ID : 01 [SystemIO]
[1E1h 0481   1]                    Bit Width : 08
[1E2h 0482   1]                   Bit Offset : 00
[1E3h 0483   1]         Encoded Access Width : 01 [Byte Access:8]
[1E4h 0484   8]                      Address : 0000000000000071

[1ECh 0492   4]                        Value : 00000001
[1F0h 0496   4]                Register Mask : 00000001

[1F4h 0500   1]              Watchdog Action : 21
[1F5h 0501   1]                  Instruction : 02
[1F6h 0502   2]                     Reserved : 0000

[1F8h 0504  12]              Register Region : [Generic Address Structure]
[1F8h 0504   1]                     Space ID : 01 [SystemIO]
[1F9h 0505   1]                    Bit Width : 08
[1FAh 0506   1]                   Bit Offset : 00
[1FBh 0507   1]         Encoded Access Width : 01 [Byte Access:8]
[1FCh 0508   8]                      Address : 0000000000000070

[204h 0516   4]                        Value : 00000045
[208h 0520   4]                Register Mask : 000000FF

[20Ch 0524   1]              Watchdog Action : 21
[20Dh 0525   1]                  Instruction : 82
[20Eh 0526   2]                     Reserved : 0000

[210h 0528  12]              Register Region : [Generic Address Structure]
[210h 0528   1]                     Space ID : 01 [SystemIO]
[211h 0529   1]                    Bit Width : 08
[212h 0530   1]                   Bit Offset : 00
[213h 0531   1]         Encoded Access Width : 01 [Byte Access:8]
[214h 0532   8]                      Address : 0000000000000071

[21Ch 0540   4]                        Value : 00000000
[220h 0544   4]                Register Mask : 00000001

Raw Table Data: Length 548 (0x224)

  0000: 57 44 41 54 24 02 00 00 01 D2 41 43 52 53 59 53  WDAT$.....ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 00 00 04 00 20 00 00 00 FF 00 FF FF FF 00 00 00  .... ...........
  0030: 58 02 00 00 FF 03 00 00 02 00 00 00 81 00 00 00  X...............
  0040: 14 00 00 00 01 02 00 00 01 10 00 02 60 04 00 00  ............`...
  0050: 00 00 00 00 00 00 00 00 FF 03 00 00 04 01 00 00  ................
  0060: 01 10 00 02 60 04 00 00 00 00 00 00 00 00 00 00  ....`...........
  0070: FF 03 00 00 05 01 00 00 01 10 00 02 72 04 00 00  ............r...
  0080: 00 00 00 00 00 00 00 00 FF 03 00 00 06 83 00 00  ................
  0090: 01 10 00 02 72 04 00 00 00 00 00 00 00 00 00 00  ....r...........
  00A0: FF 03 00 00 08 00 00 00 01 10 0B 02 68 04 00 00  ............h...
  00B0: 00 00 00 00 00 00 00 00 01 00 00 00 09 82 00 00  ................
  00C0: 01 10 00 02 68 04 00 00 00 00 00 00 00 00 00 00  ....h...........
  00D0: 00 08 00 00 09 02 00 00 01 08 00 01 70 00 00 00  ............p...
  00E0: 00 00 00 00 45 00 00 00 FF 00 00 00 09 82 00 00  ....E...........
  00F0: 01 08 00 01 71 00 00 00 00 00 00 00 01 00 00 00  ....q...........
  0100: 01 00 00 00 0A 00 00 00 01 10 0B 02 68 04 00 00  ............h...
  0110: 00 00 00 00 01 00 00 00 01 00 00 00 0B 82 00 00  ................
  0120: 01 10 00 02 68 04 00 00 00 00 00 00 00 08 00 00  ....h...........
  0130: 00 08 00 00 0B 02 00 00 01 08 00 01 70 00 00 00  ............p...
  0140: 00 00 00 00 45 00 00 00 FF 00 00 00 0B 82 00 00  ....E...........
  0150: 01 08 00 01 71 00 00 00 00 00 00 00 00 00 00 00  ....q...........
  0160: 01 00 00 00 10 00 00 00 01 08 04 01 6A 04 00 00  ............j...
  0170: 00 00 00 00 00 00 00 00 03 00 00 00 11 82 00 00  ................
  0180: 01 10 00 02 6A 04 00 00 00 00 00 00 00 00 00 00  ....j...........
  0190: 30 00 00 00 12 00 00 00 01 08 04 01 6A 04 00 00  0...........j...
  01A0: 00 00 00 00 01 00 00 00 03 00 00 00 13 82 00 00  ................
  01B0: 01 10 00 02 6A 04 00 00 00 00 00 00 10 00 00 00  ....j...........
  01C0: 30 00 00 00 20 02 00 00 01 08 00 01 70 00 00 00  0... .......p...
  01D0: 00 00 00 00 45 00 00 00 FF 00 00 00 20 00 00 00  ....E....... ...
  01E0: 01 08 00 01 71 00 00 00 00 00 00 00 01 00 00 00  ....q...........
  01F0: 01 00 00 00 21 02 00 00 01 08 00 01 70 00 00 00  ....!.......p...
  0200: 00 00 00 00 45 00 00 00 FF 00 00 00 21 82 00 00  ....E.......!...
  0210: 01 08 00 01 71 00 00 00 00 00 00 00 00 00 00 00  ....q...........
  0220: 01 00 00 00                                      ....
