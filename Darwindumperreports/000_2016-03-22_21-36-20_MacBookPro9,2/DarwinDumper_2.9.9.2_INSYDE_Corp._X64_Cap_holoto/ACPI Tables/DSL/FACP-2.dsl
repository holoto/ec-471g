/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20130823-32 [Sep 16 2013]
 * Copyright (c) 2000 - 2013 Intel Corporation
 * 
 * Disassembly of /Users/holoto/Desktop/Tools/DarwinDumperReports/000_2016-03-22_21-36-20_MacBookPro9,2/DarwinDumper_2.9.9.2_INSYDE_Corp._X64_Cap_holoto/ACPI Tables/AML/FACP-2.aml, Tue Mar 22 21:36:52 2016
 *
 * ACPI Data Table [FACP]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "FACP"    [Fixed ACPI Description Table (FADT)]
[004h 0004   4]                 Table Length : 0000010C
[008h 0008   1]                     Revision : 05
[009h 0009   1]                     Checksum : F6
[00Ah 0010   6]                       Oem ID : "ACRSYS"
[010h 0016   8]                 Oem Table ID : "ACRPRDCT"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "1025"
[020h 0032   4]        Asl Compiler Revision : 00040000

[024h 0036   4]                 FACS Address : A6FBA000
[028h 0040   4]                 DSDT Address : A6FEC000
[02Ch 0044   1]                        Model : 01
[02Dh 0045   1]                   PM Profile : 02 [Mobile]
[02Eh 0046   2]                SCI Interrupt : 0009
[030h 0048   4]             SMI Command Port : 000000B2
[034h 0052   1]            ACPI Enable Value : A0
[035h 0053   1]           ACPI Disable Value : A1
[036h 0054   1]               S4BIOS Command : 00
[037h 0055   1]              P-State Control : 80
[038h 0056   4]     PM1A Event Block Address : 00000400
[03Ch 0060   4]     PM1B Event Block Address : 00000000
[040h 0064   4]   PM1A Control Block Address : 00000404
[044h 0068   4]   PM1B Control Block Address : 00000000
[048h 0072   4]    PM2 Control Block Address : 00000450
[04Ch 0076   4]       PM Timer Block Address : 00000408
[050h 0080   4]           GPE0 Block Address : 00000420
[054h 0084   4]           GPE1 Block Address : 00000000
[058h 0088   1]       PM1 Event Block Length : 04
[059h 0089   1]     PM1 Control Block Length : 02
[05Ah 0090   1]     PM2 Control Block Length : 01
[05Bh 0091   1]        PM Timer Block Length : 04
[05Ch 0092   1]            GPE0 Block Length : 10
[05Dh 0093   1]            GPE1 Block Length : 00
[05Eh 0094   1]             GPE1 Base Offset : 00
[05Fh 0095   1]                 _CST Support : 85
[060h 0096   2]                   C2 Latency : 0065
[062h 0098   2]                   C3 Latency : 0039
[064h 0100   2]               CPU Cache Size : 0400
[066h 0102   2]           Cache Flush Stride : 0010
[068h 0104   1]            Duty Cycle Offset : 01
[069h 0105   1]             Duty Cycle Width : 03
[06Ah 0106   1]          RTC Day Alarm Index : 0D
[06Bh 0107   1]        RTC Month Alarm Index : 00
[06Ch 0108   1]            RTC Century Index : 00
[06Dh 0109   2]   Boot Flags (decoded below) : 0013
               Legacy Devices Supported (V2) : 1
            8042 Present on ports 60/64 (V2) : 1
                        VGA Not Present (V4) : 0
                      MSI Not Supported (V4) : 0
                PCIe ASPM Not Supported (V4) : 1
                   CMOS RTC Not Present (V5) : 0
[06Fh 0111   1]                     Reserved : 00
[070h 0112   4]        Flags (decoded below) : 000386A5
      WBINVD instruction is operational (V1) : 1
              WBINVD flushes all caches (V1) : 0
                    All CPUs support C1 (V1) : 1
                  C2 works on MP system (V1) : 0
            Control Method Power Button (V1) : 0
            Control Method Sleep Button (V1) : 1
        RTC wake not in fixed reg space (V1) : 0
            RTC can wake system from S4 (V1) : 1
                        32-bit PM Timer (V1) : 0
                      Docking Supported (V1) : 1
               Reset Register Supported (V2) : 1
                            Sealed Case (V3) : 0
                    Headless - No Video (V3) : 0
        Use native instr after SLP_TYPx (V3) : 0
              PCIEXP_WAK Bits Supported (V4) : 0
                     Use Platform Timer (V4) : 1
               RTC_STS valid on S4 wake (V4) : 1
                Remote Power-on capable (V4) : 1
                 Use APIC Cluster Model (V4) : 0
     Use APIC Physical Destination Mode (V4) : 0
                       Hardware Reduced (V5) : 0
                      Low Power S0 Idle (V5) : 0

[074h 0116  12]               Reset Register : [Generic Address Structure]
[074h 0116   1]                     Space ID : 01 [SystemIO]
[075h 0117   1]                    Bit Width : 08
[076h 0118   1]                   Bit Offset : 00
[077h 0119   1]         Encoded Access Width : 01 [Byte Access:8]
[078h 0120   8]                      Address : 00000000000000B2

[080h 0128   1]         Value to cause reset : FB
[081h 0129   3]                     Reserved : 000000
[084h 0132   8]                 FACS Address : 0000000000000000
[08Ch 0140   8]                 DSDT Address : 00000000A6FEC000
[094h 0148  12]             PM1A Event Block : [Generic Address Structure]
[094h 0148   1]                     Space ID : 01 [SystemIO]
[095h 0149   1]                    Bit Width : 20
[096h 0150   1]                   Bit Offset : 00
[097h 0151   1]         Encoded Access Width : 03 [DWord Access:32]
[098h 0152   8]                      Address : 0000000000000400

[0A0h 0160  12]             PM1B Event Block : [Generic Address Structure]
[0A0h 0160   1]                     Space ID : 00 [SystemMemory]
[0A1h 0161   1]                    Bit Width : 00
[0A2h 0162   1]                   Bit Offset : 00
[0A3h 0163   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0A4h 0164   8]                      Address : 0000000000000000

[0ACh 0172  12]           PM1A Control Block : [Generic Address Structure]
[0ACh 0172   1]                     Space ID : 01 [SystemIO]
[0ADh 0173   1]                    Bit Width : 10
[0AEh 0174   1]                   Bit Offset : 00
[0AFh 0175   1]         Encoded Access Width : 02 [Word Access:16]
[0B0h 0176   8]                      Address : 0000000000000404

[0B8h 0184  12]           PM1B Control Block : [Generic Address Structure]
[0B8h 0184   1]                     Space ID : 00 [SystemMemory]
[0B9h 0185   1]                    Bit Width : 00
[0BAh 0186   1]                   Bit Offset : 00
[0BBh 0187   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0BCh 0188   8]                      Address : 0000000000000000

[0C4h 0196  12]            PM2 Control Block : [Generic Address Structure]
[0C4h 0196   1]                     Space ID : 01 [SystemIO]
[0C5h 0197   1]                    Bit Width : 08
[0C6h 0198   1]                   Bit Offset : 00
[0C7h 0199   1]         Encoded Access Width : 01 [Byte Access:8]
[0C8h 0200   8]                      Address : 0000000000000450

[0D0h 0208  12]               PM Timer Block : [Generic Address Structure]
[0D0h 0208   1]                     Space ID : 01 [SystemIO]
[0D1h 0209   1]                    Bit Width : 20
[0D2h 0210   1]                   Bit Offset : 00
[0D3h 0211   1]         Encoded Access Width : 03 [DWord Access:32]
[0D4h 0212   8]                      Address : 0000000000000408

[0DCh 0220  12]                   GPE0 Block : [Generic Address Structure]
[0DCh 0220   1]                     Space ID : 01 [SystemIO]
[0DDh 0221   1]                    Bit Width : 80
[0DEh 0222   1]                   Bit Offset : 00
[0DFh 0223   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0E0h 0224   8]                      Address : 0000000000000420

[0E8h 0232  12]                   GPE1 Block : [Generic Address Structure]
[0E8h 0232   1]                     Space ID : 00 [SystemMemory]
[0E9h 0233   1]                    Bit Width : 00
[0EAh 0234   1]                   Bit Offset : 00
[0EBh 0235   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0ECh 0236   8]                      Address : 0000000000000000


[0F4h 0244  12]       Sleep Control Register : [Generic Address Structure]
[0F4h 0244   1]                     Space ID : 00 [SystemMemory]
[0F5h 0245   1]                    Bit Width : 00
[0F6h 0246   1]                   Bit Offset : 00
[0F7h 0247   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0F8h 0248   8]                      Address : 0000000000000000

[100h 0256  12]        Sleep Status Register : [Generic Address Structure]
[100h 0256   1]                     Space ID : 00 [SystemMemory]
[101h 0257   1]                    Bit Width : 00
[102h 0258   1]                   Bit Offset : 00
[103h 0259   1]         Encoded Access Width : 00 [Undefined/Legacy]
[104h 0260   8]                      Address : 0000000000000000


Raw Table Data: Length 268 (0x10C)

  0000: 46 41 43 50 0C 01 00 00 05 F6 41 43 52 53 59 53  FACP......ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 00 00 04 00 00 A0 FB A6 00 C0 FE A6 01 02 09 00  ................
  0030: B2 00 00 00 A0 A1 00 80 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 50 04 00 00 08 04 00 00  ........P.......
  0050: 20 04 00 00 00 00 00 00 04 02 01 04 10 00 00 85   ...............
  0060: 65 00 39 00 00 04 10 00 01 03 0D 00 00 13 00 00  e.9.............
  0070: A5 86 03 00 01 08 00 01 B2 00 00 00 00 00 00 00  ................
  0080: FB 00 00 00 00 00 00 00 00 00 00 00 00 C0 FE A6  ................
  0090: 00 00 00 00 01 20 00 03 00 04 00 00 00 00 00 00  ..... ..........
  00A0: 00 00 00 00 00 00 00 00 00 00 00 00 01 10 00 02  ................
  00B0: 04 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00C0: 00 00 00 00 01 08 00 01 50 04 00 00 00 00 00 00  ........P.......
  00D0: 01 20 00 03 08 04 00 00 00 00 00 00 01 80 00 00  . ..............
  00E0: 20 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ...............
  00F0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0100: 00 00 00 00 00 00 00 00 00 00 00 00              ............
