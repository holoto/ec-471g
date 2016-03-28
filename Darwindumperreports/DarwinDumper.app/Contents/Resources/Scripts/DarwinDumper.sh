#!/bin/sh

# A script to run commands for gathering system information.
# Copyright (C) 2010 org.darwinx86.app <darwindumper@yahoo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# =======================================================================
#
# Originally by Trauma on 12/08/09.
# Many thanks to JrCs, sonotone, phcoder.
#
# Later additions and revisions by STLVNUB and blackosx.
#
# Re-structured and further developed by blackosx July 2012 -> October 2015
# Incorporating original DarwinDumper ideas and code.
#
# Thanks to the following users for providing testing/feedback, additional tools, suggestions and help.
# Slice, dmazar, STLVNUB, !Xabbu, THe KiNG, Trauma, JrCs, Kynnder, droplets & arsradu.

#set -x
#set -u

# =======================================================================================
# INITIALISATION & NON-SPECIFIC ROUTINES
# =======================================================================================

# ---------------------------------------------------------------------------------------
InitialiseBeforeUI()
{
    local cdir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd "$cdir"; cd ..; cd ..
    local resourcesDir="$( pwd )"/Resources
    if [ -d "$resourcesDir" ]; then
        local dataDir="$resourcesDir"/Data
        local driversDir="$resourcesDir"/Drivers
        local imagesDir="$resourcesDir"/Images
        local toolsDir="$resourcesDir"/Tools
        local scriptsDir="$resourcesDir"/Scripts

        # Global Vars
        gDDTmpFolder="/tmp/DarwinDumper" # Temporary working folder.
        gTmpPreLogFile="$gDDTmpFolder"/tmplogfile
        if [ -f "$gDDTmpFolder"/dd_version ]; then
            gtheVersion=$(cat "$gDDTmpFolder"/dd_version)
        else
            gtheVersion="Unknown"
        fi
        ioregViewerDir="$resourcesDir"/IOregViewer
        gTheLoader=""
        gtheprog="DarwinDumper"
        gScriptRunTime=0
        gLoadedPciUtilsDriver=0
        gLoadedVoodooHda=0
        gLoadedRadeonPci=0
        gLoadedPmem=0
        gRootPriv=0
        gUserPrefsFileName="org.tom.DarwinDumper"
        gUserPrefsFile="$HOME/Library/Preferences/$gUserPrefsFileName"
        gAppReportsFolderName="DarwinDumperReports"
        gMyFolder="$dataDir/$gAppReportsFolderName"
        gDataDir="$dataDir"
        gNvramCallFileList="$dataDir"/nvram_firmware_variable_calls.txt
        gLogIndent="          "
        gCodecID=""

        # Read and set user id and group as they're used in ProcessUserChoices()
        local tmp=$(cat "$gDDTmpFolder"/dd_user)
        theBoss="${tmp%:*}"
        theBossGroup="${tmp#*:}"

        # Global vars for holding which dumps are wanted.
        gCheckBox_acpi=0
        gCheckBox_acpiFromMem=0
        gCheckBox_asl=0
        gCheckBox_audioCodec=0
        gCheckBox_biosSystem=0
        gCheckBox_biosVideo=0
        gCheckBox_cpuInfo=0
        gCheckBox_devprop=0
        gCheckBox_bootLoaderBootSectors=0
        gCheckBox_diskLoaderConfigs=0
        gCheckBox_diskPartitionInfo=0
        gCheckBox_edid=0
        gCheckBox_bootlog=0
        gCheckBox_firmmemmap=0
        gCheckBox_memIntelGraphics=0
        gCheckBox_ioreg=0
        gCheckBox_kerneldmesg=0
        gCheckBox_kernelinfo=0
        gCheckBox_kexts=0
        gCheckBox_lspci=0
        gCheckBox_opencl=0
        gCheckBox_rtc=0
        gCheckBox_dmi=0
        gCheckBox_sip=0
        gCheckBox_smc=0
        gCheckBox_sysprof=0
        gCheckBox_rcscripts=0
        gCheckBox_nvram=0
        gCheckBox_enablehtml=0
        gButton_cancel=0
        gButton_runAll=0
        gButton_runSelected=0
        gRadio_privacy=""
        gRadio_archiveType=""
        gNoShow=0

        # Resources - Data
        pciids="$dataDir/pci.ids.gz"

        # Resources - Drivers
        pciutildrv="$driversDir/DirectHW.kext"
        pciutildrvLeo="$driversDir/Leo/DirectHW.kext"
        pciutildrvElCap="$driversDir/ElCap/DirectHW.kext"
        voodoohda="$driversDir/VoodooHDA.kext"
        voodoohdaPreML="$driversDir/PreML/VoodooHDA.kext"
        radeonPci="$driversDir/RadeonPCI.kext"
        radeonPciPreML="$driversDir/PreML/RadeonPCI.kext"
        radeonPciLeo="$driversDir/Leo/RadeonPCI.kext"
        pmemDrv="$driversDir/pmem.kext"

        # Resources - Scripts
        dumpACPIfromMem="$scriptsDir/dumpACPIfromMem.sh"
        gatherDiskUtilLoaderinfo="$scriptsDir/gatherDiskUtilLoaderinfo.sh"
        generateHTMLreport="$scriptsDir/generateHTMLreport_new.sh"
        makePrivate="$scriptsDir/privacy.pl"

        # Resources - Tools
        AnalyseVBIOS="$toolsDir/AnalyseVBIOS"
        atomdis="$toolsDir/atomdis"
        bdmesg="$toolsDir/bdmesg"
        smbiosreader="$toolsDir/smbios-reader"
        dmidecode="$toolsDir/dmidecode"
        gfxutil="$toolsDir/gfxutil"
        iasl="$toolsDir/iasl"
        smcutil="$toolsDir/SMC_util3"
        lspci="$toolsDir/lspci"
        sbmm="$toolsDir/FirmwareMemoryMap"
        rtcdumper="$toolsDir/cmosDumperForOsx"
        flashrom="$toolsDir/flashrom"
        lzma="$toolsDir/lzma"
        oclinfo="$toolsDir/oclinfo"
        ediddecode="$toolsDir/edid-decode"
        ioregwv="$toolsDir/ioregwv"
        getcodecid="$toolsDir/getcodecid"
        getdump="$toolsDir/getdump"
        radeonDump="$toolsDir/RadeonDump"
        radeonDumpLeo="$toolsDir/RadeonDumpLeo"
        radeonDecode="$toolsDir/radeon_bios_decode"
        nvramTool="$toolsDir/nvram"
        x86info="$toolsDir/x86info"
        dumpACPI="$toolsDir/dumpACPI"
        csrStat="$toolsDir/csrstat"

        # UI
        macgap="$resourcesDir/MacGap.app/Contents/MacOS/MacGap"
    else
        echo "DarwinDumper quit because it couldn't find the Resources folder." >> "$gTmpPreLogFile"
        exit 1
    fi
}

# ---------------------------------------------------------------------------------------
ProcessUserChoices()
{
    # Wait until temporary file exists and is greater than zero in size.
    # If user ran the UI, then this file will be generated from the UI.
    # If user ran from the command line then this file will have been created by the init script.
    while [ ! -s "$gDDTmpFolder"/dd_ui_return ];
    do
        sleep 1
    done

    # Read the temp file then remove it.
    oIFS="$IFS"; IFS=$','
    uiReturnArray=( $(cat "$gDDTmpFolder"/dd_ui_return) )
    IFS="$oIFS"

    # Loop through each option
    for (( x=0; x<${#uiReturnArray[@]}; x++ ))
    do
        # Remove unwanted characters and parse results.
        case "${uiReturnArray[$x]##*:}" in
                    "privacy")                gRadio_privacy="Private"
                                              echo "*User Chose: privacy" >> "$gTmpPreLogFile" ;;
                    "Report")                 gCheckBox_enablehtml=1
                                              echo "*User Chose: Report" >> "$gTmpPreLogFile" ;;
                    "ReportNone")             gRadio_reportType="ReportNone" # Is this still required?
                                              echo "*User Chose: No Report" >> "$gTmpPreLogFile" ;;
                    "ArchiveZip")             gRadio_archiveType="Archive.zip"
                                              echo "*User Chose: Archive Zip" >> "$gTmpPreLogFile" ;;
                    "ArchiveLzma")            gRadio_archiveType="Archive.lzma"
                                              echo "*User Chose: Archive Lzma" >> "$gTmpPreLogFile" ;;
                    "ArchiveNone")            gRadio_archiveType="Archive_None"
                                              echo "*User Chose: Not to archive" >> "$gTmpPreLogFile" ;;
                    "acpi")                   gCheckBox_acpi=1
                                              echo "*User Chose: ACPI tables" >> "$gTmpPreLogFile" ;;
                    "acpiFromMem")            gCheckBox_acpiFromMem=1
                                              echo "*User Chose: ACPI from memory" >> "$gTmpPreLogFile" ;;
                    "asl")                    gCheckBox_asl=1
                                              echo "*User Chose: Apple System Log" >> "$gTmpPreLogFile" ;;
                    "codecid")                gCheckBox_audioCodec=1
                                              echo "*User Chose: Audio Codec" >> "$gTmpPreLogFile" ;;
                    "cpuinfo")                gCheckBox_cpuInfo=1
                                              echo "*User Chose: CPU Information" >> "$gTmpPreLogFile" ;;
                    "biosSystem")             gCheckBox_biosSystem=1
                                              echo "*User Chose: System BIOS" >> "$gTmpPreLogFile" ;;
                    "biosVideo")              gCheckBox_biosVideo=1
                                              echo "*User Chose: Video BIOS" >> "$gTmpPreLogFile" ;;
                    "devprop")                gCheckBox_devprop=1
                                              echo "*User Chose: Device Properties" >> "$gTmpPreLogFile" ;;
                    "diskLoaderConfigs")      gCheckBox_diskLoaderConfigs=1
                                              echo "*User Chose: Disk Loader Configs" >> "$gTmpPreLogFile" ;;
                    "bootLoaderBootSectors")  gCheckBox_bootLoaderBootSectors=1
                                              echo "*User Chose: Boot Loaders and Disk Sectors" >> "$gTmpPreLogFile" ;;
                    "diskPartitionInfo")      gCheckBox_diskPartitionInfo=1
                                              echo "*User Chose: Disk Partitions" >> "$gTmpPreLogFile" ;;
                    "dmi")                    gCheckBox_dmi=1
                                              echo "*User Chose: DMI Tables" >> "$gTmpPreLogFile" ;;
                    "edid")                   gCheckBox_edid=1
                                              echo "*User Chose: EDID" >> "$gTmpPreLogFile" ;;
                    "bootlog")                gCheckBox_bootlog=1
                                              echo "*User Chose: Firmware (Boot) Log" >> "$gTmpPreLogFile" ;;
                    "firmmemmap")             gCheckBox_firmmemmap=1
                                              echo "*User Chose: Firmware Memory Map" >> "$gTmpPreLogFile" ;;
                    "memIntelGraphics")       gCheckBox_memIntelGraphics=1
                                              echo "*User Chose: Memory Dump Intel Graphics Regions" >> "$gTmpPreLogFile" ;;
                    "ioreg")                  gCheckBox_ioreg=1
                                              echo "*User Chose: IORegistry" >> "$gTmpPreLogFile" ;;
                    "kerneldmesg")            gCheckBox_kerneldmesg=1
                                              echo "*User Chose: Kernel dmesg" >> "$gTmpPreLogFile" ;;
                    "kernelinfo")             gCheckBox_kernelinfo=1
                                              echo "*User Chose: Kernel Info" >> "$gTmpPreLogFile" ;;
                    "kexts")                  gCheckBox_kexts=1
                                              echo "*User Chose: Kexts" >> "$gTmpPreLogFile" ;;
                    "lspci")                  gCheckBox_lspci=1
                                              echo "*User Chose: LSPCI" >> "$gTmpPreLogFile" ;;
                    "rcscripts")              gCheckBox_rcscripts=1
                                              echo "*User Chose: RC Scripts" >> "$gTmpPreLogFile" ;;
                    "nvram")                  gCheckBox_nvram=1
                                              echo "*User Chose: NVRAM" >> "$gTmpPreLogFile" ;;
                    "opencl")                 gCheckBox_opencl=1
                                              echo "*User Chose: Open CL" >> "$gTmpPreLogFile" ;;
                    "rtc")                    gCheckBox_rtc=1
                                              echo "*User Chose: RTC" >> "$gTmpPreLogFile" ;;
                    "sip")                    gCheckBox_sip=1
                                              echo "*User Chose: SIP" >> "$gTmpPreLogFile" ;;
                    "smc")                    gCheckBox_smc=1
                                              echo "*User Chose: SMC Keys" >> "$gTmpPreLogFile" ;;
                    "sysprof")                gCheckBox_sysprof=1
                                              echo "*User Chose: System Profiler" >> "$gTmpPreLogFile" ;;
                    "noshow")                 gNoShow=1
                                              echo "*User Chose: Not to show dump directory & html report on completion" >> "$gTmpPreLogFile" ;;
                    "user_quit")              gButton_cancel=1 # user quit
                                              echo "*User Chose: Quit" >> "$gTmpPreLogFile" ;;
                    "death")                  exit 1 # UI has completed and closed
                                              ;;
        esac
    done
}

# ---------------------------------------------------------------------------------------
InitialiseAfterUI()
{
    local rootSystem=$(CheckOsVersion)

    if [ -f "$gDDTmpFolder"/dd_reports_filepath ]; then
        gDumpDir=$( cat "$gDDTmpFolder"/dd_reports_filepath )
    else
        echo "Reports folder not defined."
        exit 1
    fi

    # find sequence number from latest directory in the Reports folder.
    local latestDumpDirName=$( ls -d "$gDumpDir"/[0-9][0-9][0-9]_* 2>/dev/null | tail -n 1 )
    if [ -z "$latestDumpDirName" ] || [ "$latestDumpDirName" == "" ]; then
        local lastSequenceNumber="000"
    else
        # Strip all before last forward slash
        lastSequenceNumber="${latestDumpDirName##*/}"
        # Remove all after and including first underscore
        lastSequenceNumber="${lastSequenceNumber%%_*}"
        # Remove any preceding zeros by converting to an actual number
        lastSequenceNumber="$[10#${lastSequenceNumber}]"
        # If user has 999 dumps, then reset to 0 (can't see this ever happening).
        if [ $lastSequenceNumber -eq 999 ]; then
            lastSequenceNumber="000"
        else
            # increment sequence number
            ((lastSequenceNumber++))
        fi
    fi

    #Pad as a string length of 3. For example: 006
    lastSequenceNumber=$( printf %03d $lastSequenceNumber )

    # Find Mac Model to add to the folder name.
    local macModel=$( /usr/sbin/system_profiler SPHardwareDataType 2>/dev/null | grep "Model Identifier:" )
    macModel="${macModel##*: }"

    # Create indexed, time stamped folder to hold this dump.
    local timeStamp=$( date "+%F_%H-%M-%S" )
    gThisIndexedDumpFolder="${gDumpDir}/${lastSequenceNumber}_${timeStamp}_${macModel}"
    mkdir "${gThisIndexedDumpFolder}"

    # Get the bootloader type and version
    gTheLoader=$(GetTheLoaderTypeAndVersion)

    # Create dump folder name.
    gFolderName="${gtheprog}_${gtheVersion}_${gTheLoader}_${rootSystem}_${theBoss}"

    # SetMasterDumpFolder
    gMasterDumpFolder="${gThisIndexedDumpFolder}/${gFolderName}"

    # Set temporary directory for copying and loading kexts from.
    gTMPDir=/tmp

    # Set log file path
    gLogFile="$gMasterDumpFolder"/" DarwinDumper_log.txt"

    # Set up dump folder paths.
    gDumpFolderAcpi="$gMasterDumpFolder/ACPI Tables"
    gDumpFolderAcpiAml="$gDumpFolderAcpi/AML"
    gDumpFolderAcpiDsl="$gDumpFolderAcpi/DSL"
    gDumpFolderAcpiAmlFromMem="$gDumpFolderAcpi/AML_from_Memory"
    gDumpFolderAudio="$gMasterDumpFolder/Audio"
    gDumpFolderBios="$gMasterDumpFolder/BIOS"
    gDumpFolderBiosSystem="$gDumpFolderBios/System"
    gDumpFolderBiosVideo="$gDumpFolderBios/Video"
    gDumpFolderBootLoader="$gMasterDumpFolder/Boot Loaders"
    gDumpFolderBootLoaderConfigs="$gDumpFolderBootLoader/Configuration Files"
    gDumpFolderBootLoaderDrivers="$gDumpFolderBootLoader/Drivers"
    gDumpFolderBootLog="$gMasterDumpFolder/BootLog"
    gDumpFolderCPU="$gMasterDumpFolder/CPU"
    gDumpFolderDevProps="$gMasterDumpFolder/Device Properties"
    gDumpFolderDisks="$gMasterDumpFolder/Disks"
    gDumpFolderDiskBootSectors="$gDumpFolderDisks/Boot Sectors"
    gDumpFolderDiskPartitionInfo="$gDumpFolderDisks/Partition Info"
    gDumpFolderDmi="$gMasterDumpFolder/DMI Tables"
    gDumpFolderEdid="$gMasterDumpFolder/EDID"
    gDumpFolderIoreg="$gMasterDumpFolder/IORegistry"
    gDumpFolderKernelInfo="$gMasterDumpFolder/Kernel Info"
    gDumpFolderKernelLogs="$gMasterDumpFolder/Kernel Logs"
    gDumpFolderKexts="$gMasterDumpFolder/Kexts"
    gDumpFolderLspci="$gMasterDumpFolder/LSPCI"
    gDumpFolderMemory="$gMasterDumpFolder/Memory"
    gDumpFolderMemoryRegions="$gDumpFolderMemory/Regions"
    gDumpFolderNvram="$gMasterDumpFolder/NVRAM"
    gDumpFolderOpenCl="$gMasterDumpFolder/OpenCL"
    gDumpFolderRcScripts="$gMasterDumpFolder/RC Scripts"
    gDumpFolderRtc="$gMasterDumpFolder/RTC"
    gDumpFolderSip="$gMasterDumpFolder/SIP"
    gDumpFolderSmc="$gMasterDumpFolder/SMC"
    gDumpFolderSysProf="$gMasterDumpFolder/System Profiler"

    # Export dump folder paths to make them available to the other scripts.
    export gDDTmpFolder
    export gLogFile
    export gLogIndent
    export iasl
    export gDumpFolderAcpi
    export gDumpFolderAcpiAml
    export gDumpFolderAcpiDsl
    export gDumpFolderAcpiAmlFromMem
    export gDumpFolderAudio
    export gDumpFolderBios
    export gDumpFolderBiosSystem
    export gDumpFolderBiosVideo
    export gDumpFolderBootLoader
    export gDumpFolderBootLoaderConfigs
    export gDumpFolderBootLoaderDrivers
    export gDumpFolderBootLog
    export gDumpFolderCPU
    export gDumpFolderDevProps
    export gDumpFolderDisks
    export gDumpFolderDiskBootSectors
    export gDumpFolderDiskPartitionInfo
    export gDumpFolderDmi
    export gDumpFolderEdid
    export gDumpFolderIoreg
    export gDumpFolderKernelInfo
    export gDumpFolderKernelLogs
    export gDumpFolderKexts
    export gDumpFolderLspci
    export gDumpFolderMemory
    export gDumpFolderNvram
    export gDumpFolderOpenCl
    export gDumpFolderRcScripts
    export gDumpFolderRtc
    export gDumpFolderSip
    export gDumpFolderSmc
    export gDumpFolderSysProf

    # Create / Clean temp directory
    if [ -d "$gTMPDir"/DirectHW.kext ];then
       rm -Rf "$gTMPDir"/DirectHW.kext
    fi
}

# ---------------------------------------------------------------------------------------
setPrefsOwnPerms()
{
    if [ -f "$gUserPrefsFile".plist ]; then
        chmod 755 "$gUserPrefsFile".plist
        chown "$theBoss":"$theBossGroup" "$gUserPrefsFile".plist
    fi
}

# ---------------------------------------------------------------------------------------
GetTheLoaderTypeAndVersion()
{
    # Discover current firmware architecture as, for example:
    # Apple's 64-bit efi can launch OS X 10.6 kernel in 32-bit.
    # Note: This is not the kernel architecture.
    local efi=$( ioreg -l -p IODeviceTree | grep firmware-abi | awk '{print $5}' )
    local efiBITS="${efi:5:2}"
    if [ "${efiBITS}" == "32" ]; then
    	efiBITS="IA32"
    elif [ "${efiBITS}" == "64" ]; then
       	efiBITS="X64"
    else
    	efiBITS="WhoKnows"
    fi

    # Discover current bootloader and associated version.
    gRefitVers=""
    local ozmosisVers=""
    local theLoader=$(ioreg -l -pIODeviceTree | grep firmware-vendor | awk '{print $5}' | sed 's/_/ /g' | tr -d "<\">" | xxd -r -p)
    case "$theLoader" in
            "CLOVER")              gRefitVers=$( ioreg -lw0 -pIODeviceTree | grep boot-log | tr [[:lower:]] [[:upper:]] )
                                   if [ "$gRefitVers" != "" ]; then
                                       if [[ "$gRefitVers" == *72454649742072657620* ]]; then
                                           gRefitVers=$( echo "$gRefitVers" | tr -d "    |       "boot-log" = <\">" | LANG=C sed -e 's/.*72454649742072657620//' -e 's/206F6E20.*//' | xxd -r -p | sed 's/:/ /g' )
                                       elif [[ "$gRefitVers" == *436C6F7665722072657620* ]]; then
                                           gRefitVers=$( echo "$gRefitVers" | tr -d "    |       "boot-log" = <\">" | LANG=C sed -e 's/.*436C6F7665722072657620//' -e 's/206F6E20.*//' | xxd -r -p | sed 's/:/ /g' )
                                       else
                                           gRefitVers="0000"
                                       fi
                                   fi
	                               theLoader="Clover_${efiBITS}_${gRefitVers}" ;;
            "American Megatrends") gRefitVers=$( ioreg -lw0 -pIODeviceTree | grep boot-log | tr [[:lower:]] [[:upper:]] )
                                   if [ "$gRefitVers" != "" ]; then
                                       # Check for "rEFIt rev "
                                       if [[ "$gRefitVers" == *72454649742072657620* ]]; then
                                           gRefitVers=$( echo "$gRefitVers" | tr -d "    |       "boot-log" = <\">" | LANG=C sed -e 's/.*72454649742072657620//' -e 's/206F6E20.*//' | xxd -r -p | sed 's/:/ /g' )
                                           theLoader="AMI_${efiBITS}_${gRefitVers}"
                                       # Check for "Clover rev "
                                       elif [[ "$gRefitVers" == *436C6F7665722072657620* ]]; then
                                           gRefitVers=$( echo "$gRefitVers" | tr -d "    |       "boot-log" = <\">" | LANG=C sed -e 's/.*436C6F7665722072657620//' -e 's/206F6E20.*//' | xxd -r -p | sed 's/:/ /g' )
                                           theLoader="AMI_${efiBITS}_${gRefitVers}"
                                       # Check for "Ozmosis"
                                       elif [[ "$gRefitVers" == *4F7A6D6F73697320* ]]; then
                                           ozmosisVers=$( echo "$gRefitVers" | tr -d "    |       "boot-log" = <\">" | LANG=C sed -e 's/.*4F7A6D6F73697320//' -e 's/20.*//' | xxd -r -p | sed 's/:/ /g' )
                                           theLoader="Ozmosis_${ozmosisVers}"
                                           gRefitVers=""
                                       # If none of the above, set version to 0000
                                       else
                                           theLoader="AMI_${efiBITS}_0000"
                                       fi
	                               fi
	                               ;;
            "")                    theLoader="Unknown_${efiBITS}" ;;
            "Apple")               local tmp=""
                                   tmp=$( ioreg -p IODeviceTree | grep RevoEFI )
                                   if [ ! "$tmp" == "" ]; then
                                       theLoader="RevoBoot_${efiBITS}"
                                   else
                                       theLoader="${theLoader}_${efiBITS}"
                                   fi
                                   ;;
            *)                     local len=$(echo "${#theLoader}")
                                   if [ $len -le 32 ]; then
                                       theLoader="${theLoader}_${efiBITS}"
                                   else
                                       theLoader="${theLoader:0:31}_${efiBITS}"
                                   fi
                                   ;;
            esac
    theLoader=$( echo "${theLoader}" | tr ' ' '_' ) # check for spaces in firmware name, now global variable
    echo "$theLoader"
}

# ---------------------------------------------------------------------------------------
CreateDumpDirs()
{
    local dirToMake="$1"

    for dumpDirs in "$dirToMake";
    do
        if [ ! -d "${dumpDirs}" ]; then
    	    mkdir -p "${dumpDirs}"
    	fi
    done
}

# ---------------------------------------------------------------------------------------
CheckOsVersion()
{
    local osVer=$( uname -r )
    local osVer=${osVer%%.*}
    local rootSystem=""

    if [ "$osVer" == "8" ]; then
	    rootSystem="Tiger"
    elif [ "$osVer" == "9" ]; then
	    rootSystem="LEO"
    elif [ "$osVer" == "10" ]; then
	    rootSystem="SL"
    elif [ "$osVer" == "11" ]; then
	    rootSystem="Lion"
    elif [ "$osVer" == "12" ]; then
	    rootSystem="ML"
	elif [ "$osVer" == "13" ]; then
	    rootSystem="Mav"
	elif [ "$osVer" == "14" ]; then
	    rootSystem="Yos"
	elif [ "$osVer" == "15" ]; then
	    rootSystem="Cap"
	else
	    rootSystem="Unknown"
    fi
    echo "$rootSystem"  # This line acts as a return to the caller.
}

# ---------------------------------------------------------------------------------------
SetPermsAndLoadDriver()
{
    local driverToLoad="$1"
    local driverName="$2"

    if [ -d "$driverToLoad" ]; then
        chmod -R 755 "$driverToLoad"
        chown -R 0:0 "$driverToLoad"
        echo "${gLogIndent}Driver: Loading $driverName" >> "${gLogFile}"
        /sbin/kextload "$driverToLoad"
        # Check driver was successfully loaded
        local isLoaded=$( kextstat -l | egrep "${driverName}" )
        if [ ! "$isLoaded" == "" ]; then
            echo "${gLogIndent}Driver: $driverName loaded successfully." >> "${gLogFile}"
            return 0
        else
            echo "${gLogIndent}Driver: *ERROR - $driverName failed to load." >> "${gLogFile}"
            return 1
        fi
    fi
}

# ---------------------------------------------------------------------------------------
UnloadAndRemoveDriver()
{
    local driverToUnload="$1"
    local driverName="$2"

    local isLoaded=$( kextstat -l | egrep "$driverName" )
    if [ ! "$isLoaded" == "" ]; then
        echo "${gLogIndent}Driver: Unloading $driverName" >> "${gLogFile}"
        /sbin/kextunload "$driverToUnload"
        # For VoodooHDA - run twice.
        if [ "$driverName" == "VoodooHDA" ]; then
            /sbin/kextunload "$driverToUnload" 2>/dev/null
        fi
    fi

    # Remove the temporary copy of the driver.
    if [ -d "$driverToUnload" ]; then
        rm -r "$driverToUnload"
    fi

    # Check if driver unloading was successful.
    isLoaded=$( kextstat -l | egrep "$driverName" )
    if [ ! "$isLoaded" == "" ]; then
        echo "${gLogIndent}Driver: *ERROR - $driverName failed to be unloaded." >> "${gLogFile}"
    else
        echo "${gLogIndent}Driver: $driverName successfully unloaded." >> "${gLogFile}"
    fi
}


# ---------------------------------------------------------------------------------------
LoadPciUtilsDriver()
{
    # Check to see if VoodooHDA is already loaded on the users system
    local isLoaded=$( kextstat -l | egrep "DirectHW" )
    if [ "$isLoaded" == "" ]; then

        checkArch=$( uname -a )
        if [[ "$checkArch" == *_64* ]]; then

            checkSystemVersion=$(CheckOsVersion)
            if [ "$checkSystemVersion" == "Cap" ]; then
                cp -r "$pciutildrvElCap" "$gTMPDir"
            else
                cp -r "$pciutildrv" "$gTMPDir"
            fi
            local driverName="${pciutildrv##*/}"

        else
            cp -r "$pciutildrvLeo" "$gTMPDir"
            local driverName="${pciutildrvLeo##*/}"
        fi

        SetPermsAndLoadDriver "$gTMPDir/$driverName" "DirectHW"
        local didDriverLoad=$? # 1 = no / 0 = yes
        if [ ${didDriverLoad} = 0 ]; then
            gLoadedPciUtilsDriver=1 # make a note we loaded it.
        fi
    else
        echo "${gLogIndent}Driver: PciUtils driver is already loaded." >> "${gLogFile}"
    fi
}

# ---------------------------------------------------------------------------------------
UnloadPciUtilsDriver()
{
    if [ $gLoadedPciUtilsDriver -eq 1 ]; then
        # Only unload if we loaded it.

        checkArch=$( uname -a )
        if [[ "$checkArch" == *_64* ]]; then
            local driverName="${pciutildrv##*/}"
        else
            local driverName="${pciutildrvLeo##*/}"
        fi

        UnloadAndRemoveDriver "$gTMPDir/$driverName" "DirectHW"
    fi
}

# ---------------------------------------------------------------------------------------
LoadVoodooHdaDriver()
{
    local checkSystemVersion=""

    # Check to see if VoodooHDA is already loaded on the users system
    local isLoaded=$( kextstat -l | egrep "VoodooHDA" )
    if [ "$isLoaded" == "" ]; then
        # It's not currently loaded, so try to load it.

        checkSystemVersion=$(CheckOsVersion)
        if [ "$checkSystemVersion" == "Tiger" ] || [ "$checkSystemVersion" == "LEO" ] || [ "$checkSystemVersion" == "SL" ]; then
            cp -R "$voodoohdaPreML" "$gTMPDir" # This is a different version of VoodooHDA.kext
        else
            cp -R "$voodoohda" "$gTMPDir" # This is one version of VoodooHDA.kext
        fi

        SetPermsAndLoadDriver "$gTMPDir/VoodooHDA.kext" "VoodooHDA"
        local didDriverLoad=$? # 1 = no / 0 = yes
        if [ ${didDriverLoad} = 0 ]; then
            gLoadedVoodooHda=1 # make a note we loaded it.
        fi
    else
        echo "${gLogIndent}VoodooHDA driver is already loaded." >> "${gLogFile}"
    fi
}

# ---------------------------------------------------------------------------------------
UnloadVoodooHdaDriver()
{
    if [ $gLoadedVoodooHda -eq 1 ]; then
        # Only unload if we loaded it.

        UnloadAndRemoveDriver "$gTMPDir/VoodooHDA.kext" "VoodooHDA"
    fi
}

# ---------------------------------------------------------------------------------------
LoadRadeonPciDriver()
{
    local checkSystemVersion=""

    # Check to see if RadeonPCI.kext is already loaded on the users system
    local isLoaded=$( kextstat -l | egrep "RadeonPCI" )
    if [ "$isLoaded" == "" ]; then
        # It's not currently loaded, so try to load it.

        checkSystemVersion=$(CheckOsVersion)
        if [ "$checkSystemVersion" == "LEO" ]; then
            cp -R "$radeonPciLeo" "$gTMPDir" # This is one version of RadeonPCI.kext
        elif [ "$checkSystemVersion" == "SL" ] || [ "$checkSystemVersion" == "Lion" ] ; then
            cp -R "$radeonPciPreML" "$gTMPDir" # This is another version of RadeonPCI.kext
        else
            cp -R "$radeonPci" "$gTMPDir" # This is a different version of RadeonPCI.kext
        fi

        SetPermsAndLoadDriver "$gTMPDir/RadeonPCI.kext" "RadeonPCI"
        local didDriverLoad=$? # 1 = no / 0 = yes
        if [ ${didDriverLoad} = 0 ]; then
            gLoadedRadeonPci=1 # make a note we loaded it.
        fi
    else
        echo "${gLogIndent}RadeonPCI driver is already loaded." >> "${gLogFile}"
    fi
}

# ---------------------------------------------------------------------------------------
UnloadRadeonPciDriver()
{
    if [ $gLoadedRadeonPci -eq 1 ]; then
        # Only unload if we loaded it.

        UnloadAndRemoveDriver "$gTMPDir/RadeonPCI.kext" "RadeonPCI"
    fi
}

# ---------------------------------------------------------------------------------------
LoadPmemDriver()
{
    local checkSystemVersion=""

    # Check to see if pmem.kext is already loaded on the users system
    local isLoaded=$( kextstat -l | egrep "com.rekall.driver" )
    if [ "$isLoaded" == "" ]; then
        # It's not currently loaded, so try to load it.

        checkSystemVersion=$(CheckOsVersion)
        if [ ! "$checkSystemVersion" == "Tiger" ] && [ ! "$checkSystemVersion" == "LEO" ] && [ ! "$checkSystemVersion" == "SL" ]; then
            cp -R "$pmemDrv" "$gTMPDir"
        else
            echo "${gLogIndent}Pmem driver only works on 10.7 and newer." >> "${gLogFile}"
        fi
        echo "${gLogIndent}Memory: Attempting to load pmem driver kext to access memory." >> "${gLogFile}"
        SetPermsAndLoadDriver "$gTMPDir/pmem.kext" "com.rekall.driver"
        local didDriverLoad=$? # 1 = no / 0 = yes
        if [ ${didDriverLoad} = 0 ]; then
            gLoadedPmem=1 # make a note we loaded it.
        fi
    else
        echo "${gLogIndent}Pmem driver kext is already loaded." >> "${gLogFile}"
    fi
}

# ---------------------------------------------------------------------------------------
UnloadPmemDriver()
{
    if [ $gLoadedPmem -eq 1 ]; then
        # Only unload if we loaded it.
        UnloadAndRemoveDriver "$gTMPDir/pmem.kext" "com.rekall.driver"
    fi
}

# ---------------------------------------------------------------------------------------
CheckRoot()
{
    if [ "$( whoami )" != "root" ]; then
        #echo "Running this requires you to be root."
        #sudo "$0"
        gRootPriv=0
    else
        gRootPriv=1
    fi
}

# ---------------------------------------------------------------------------------------
CheckSuccess()
{
    local passedPathAndFile="$1"
    if [ ! -f "${passedPathAndFile}" ]; then
         echo "${gLogIndent}Check: ** ${passedPathAndFile##$gMasterDumpFolder} failed to be created." >> "${gLogFile}"
    else
        echo "${gLogIndent}Check: ${passedPathAndFile##*$gMasterDumpFolder} created." >> "${gLogFile}"
        # Check for empty file.
        if [ ! -s "${passedPathAndFile}" ]; then
            echo "${gLogIndent}Check: ${passedPathAndFile##*$gMasterDumpFolder} is 0K in size!" >> "${gLogFile}"
            echo "Check: ${passedPathAndFile##*$gMasterDumpFolder} is 0K in size!"
        fi
    fi
}

# ---------------------------------------------------------------------------------------
WriteTimeToLog()
{
    local passedString="$1"
    if [ ! "$passedString" == "" ]; then
        printf '%03ds : %s\n' $(($(date +%s)-gScriptRunTime)) "$passedString" >> "${gLogFile}"
    fi
}

# ---------------------------------------------------------------------------------------
Privatise()
{
    # ---------------------------------------------------------------------------------------
    CreateMask()
    {
        # This takes a string and creates a masked string by
        # replacing the centre 80% of characters with a *
        # for ACSII strings or 2A for hex strings.
        # The masked string is returned.
        # Thanks for helping with this function JrCs.

        local origStr="$1"
        local stringType="$2"
        local maskElement="*"
        if [[ -n "$origStr" ]];then
            tmp=$(( ${#origStr} * 6 ))                 # Multiply length of string by 6 ( so to keep 6% of chars - 3% at start, 3% at end ).
            if [ $(( ${#tmp} -2 )) -lt 0 ]; then       # Add check for short strings which would otherwise cause a substring expression < 0 error.
                tmp=0
            else
                tmp=${tmp:0:$(( ${#tmp} - 2)) }        # Calculate the number of chars at each end of the string to retain.
            fi
            [[ -z "$tmp" ]] && tmp=1                   # Keep at least 1 char at start and end.
            nbToMask=$(( ${#origStr} - ( 2 * $tmp ) )) # Calculate the length of the required mask.
            if [ "$stringType" == "Hex" ]; then        # If hex then halve mask length as mask char will be two hex chars.
                nbToMask=$(( $nbToMask / 2 ))
                maskElement="2A"
            fi
            if [[ $nbToMask -gt 0 ]]; then             # Create mask string.
                mask=$(printf "${maskElement}"'%.0s' $( jot '' 1 $nbToMask ) )
            else
                mask=""
            fi
            echo ${origStr:0:$tmp}${mask}${origStr: -$tmp}  # return final string.
            #echo ${mask}${origStr: -( 2 * $tmp ) } # Mask from front, leaving end as original.
        fi
    }

    # ---------------------------------------------------------------------------------------
    CreateFindReplaceString()
    {
        # This takes a string array of original values.
        # Each value then has an associated mask created.
        # A sed find and replace string is created and returned.

        local passedValues=( "$@" )
        for (( n=0; n < ${#passedValues[@]}; n++ ))
        do
            passedValuesMask+=( $(CreateMask "${passedValues[$n]}") )
            passedValuesSearchReplaceString="${passedValuesSearchReplaceString}s/${passedValues[$n]}/${passedValuesMask[$n]}/g;"
        done
        echo "$passedValuesSearchReplaceString"
    }

    # ---------------------------------------------------------------------------------------
    GetValue()
    {
        # This takes a search item, for example "IOPlatformSerialNumber" and returns
        # a string array with all matching values found within ioreg.
        # It works for items with single or multiple appearances, for example "IOMACAddress".

        local keyToGet="$1"
        local planeToUse="$2"
        local keyValueRead=""
        local keyValue=""

        if [[ -n "$keyToGet" ]]; then
            # Read key from system as user might not have dumped ioreg to file.
            if [ ! "$keyToGet" == "SystemSerialNumber" ] && [ ! "$planeToUse" == "IODeviceTree" ]; then
                keyValueRead=( $(ioreg -lw0 -p "$planeToUse" | grep "$keyToGet" | tr -d '"' | tr -d '<>' ) )
            else
                # Don't remove the quote marks.
                keyValueRead=( $(ioreg -lw0 -p "$planeToUse" | grep "$keyToGet" | tr -d '<>' ) )
            fi
            keyValueNumCheck=$(( ${#keyValueRead[@]} -1 ))
            grabNext=0
            for (( n=0; n < ${#keyValueRead[@]}; n++ ))
            do
                if [[ -n "${keyValueRead[$n]}" ]] && [ ! "${keyValueRead[$n]}" == "$keyToGet" ]; then
                    if [ $grabNext -eq 1 ]; then
                        keyValue+=( "${keyValueRead[$n]}" )
                        grabNext=0
                    fi
                    if [ "${keyValueRead[$n]}" == "=" ]; then # Next element will be data we want
                        grabNext=1
                    fi
                fi
            done
            echo "${keyValue[@]}"
        fi
    }

    # ---------------------------------------------------------------------------------------
    Cleanup()
    {
        local fileToRemove="$1"
        if [ -f "$fileToRemove"e ]; then
            rm "$fileToRemove"e
        fi
    }

    # ---------------------------------------------------------------------------------------
    ApplyMask()
    {
        local origStr="$1"
        local maskedStr="$2"
        local targetFile="$3"
        if [ "$maskedStr" == "" ]; then # Used for pre-constructed search/replace string.
            LANG=C sed -ie "${origStr}" "$targetFile"
        else
            LANG=C sed -ie "s/${origStr}/${maskedStr}/g" "$targetFile"
        fi
        Cleanup "$targetFile"
    }

    # ---------------------------------------------------------------------------------------
    PatchFullIoregDump()
    {
        local searchString="$1"
        local replacementString="$2"

        # Check Full IOReg Dump
        if [ -d "$gDumpFolderIoreg"/IORegViewer ]; then
            local dirToCheck="$gDumpFolderIoreg"/IORegViewer/Resources/dataFiles
            if [ -d "$dirToCheck" ]; then

                # Loop through each sub directory
                local subDirs=($( ls "$dirToCheck" ))
                for (( n=0; n < ${#subDirs[@]}; n++ ))
                do
                    local filesToPatch=()
                    cd "$dirToCheck/${subDirs[$n]}"

                    # Build array of all files to patch for this item.
                    filesToPatch=( $( grep -l "$searchString" * ))

                    # Loop through array and patch each file.
                    for (( m=0; m < ${#filesToPatch[@]}; m++ ))
                    do
                        # Add for quoted SystemSerialNumber
                        if [ "${filesToPatch[$m]}" ] && [ "$searchString" == "SystemSerialNumber" ] && [[ ! "$replacementString" == *g* ]]; then
                            # Serial number will be like this:  \"A\",\"B\",\"C\",....   replace with \"*\",\"*\",\"*\",.....
                            LANG=C sed -ie 's/\\'"\"${replacementString}"'/\\\"*/g' "$dirToCheck"/"${subDirs[$n]}"/"${filesToPatch[$m]}"
                            break
                        fi

                        if [ "${filesToPatch[$m]}" ]; then
                            ApplyMask "$replacementString" "" "$dirToCheck"/"${subDirs[$n]}"/"${filesToPatch[$m]}"
                        fi
                    done
                    cd ..
                done
            fi
        fi
    }

    # ---------------------------------------------------------------------------------------
    maskBootloaderConfigData()
    {
        local passedFileName="$1"
        local passedValueToFind="$2"
        local tmpValue=""
        declare -a tmpFileArray

        local oIFS="$IFS"; IFS=$'\n'
        tmpFileArray=( $(find "$gDumpFolderBootLoaderConfigs" -type f -name "$passedFileName") )
        IFS="$oIFS"
        for (( p=0; p<${#tmpFileArray[@]}; p++ ))
        do
            # Count the number of instances of the search string in file and loop through each.
            # Notes: grep -A places a line containing -- between contiguous groups of matches (returning 3 lines).
            #        So, a single entry will return 2 lines because there are 2 lines (key and string).
            #        Any further entries will return a number in multiples of 3 (+ the original 2 lines).
            #        For example, three occurrences will have the first 2 lines + 2 lots of 3 lines (key, string, --) (8 in total).
            #
            # Search idea taken from Jadran's parse script (find data and read the next line) - Thanks Jadran.

            local tmpValue=$( grep -A 1 "<key>${passedValueToFind}</key>" "${tmpFileArray[$p]}" | wc -l )
            for (( o=$tmpValue; o>=2; o=$o-3 ))
            do
                local tmpValue=$( grep -A 1 "<key>${passedValueToFind}</key>" "${tmpFileArray[$p]}" | head -n $o | tail -2 | sed 1d | sed -e 's/<\/string>//g' )

                # only mask if not already masked (or contains 2 consecutive asterisks)
                # and only process if string is longer than 3 chars
                if [[ ! "$tmpValue" == *\*\** ]] && [ "${#tmpValue}" -gt 3 ]; then

                    # Remove opening <string>
                    tmpValue=${tmpValue#*<string>}
                    # Remove any trailing whitespace characters
                    tmpValue="${tmpValue%"${tmpValue##*[![:space:]]}"}"
                    if [ ! $tmpValue == "" ]; then
                        local tmpValueSearchReplace=$(CreateFindReplaceString "${tmpValue}")
                        ApplyMask "$tmpValueSearchReplace" "" "${tmpFileArray[$p]}"
                    fi
                fi
            done
        done
    }

    # ---------------------------------------------------------------------------------------
    SearchAndMask()
    {
        local passedFileToMask="$1"
        local passedStringToFindFirst="$2"
        local passedStringToFindSecond="$3"
        local passedStringToStop="$4"

        if [ -f "$passedFileToMask" ]; then
            local foundToken=0
            while read -r lineRead
            do
                if [ $foundToken -eq 2 ] && [ "$lineRead" == "$passedStringToStop" ]; then
                    foundToken=0
                    break
                fi
                if [ $foundToken -eq 2 ]; then
                    local lineMasked=$(CreateMask "$lineRead")
                    ApplyMask "$lineRead" "$lineMasked" "$passedFileToMask"
                fi
                if [ $foundToken -eq 1 ]; then
                    if [[ "$lineRead" == *"${passedStringToFindSecond}"* ]]; then
                        ((foundToken++))
                    fi
                fi
                if [[ "$lineRead" == *"${passedStringToFindFirst}"* ]]; then
                    foundToken=1
                fi
            done < "$passedFileToMask"
        fi
    }

    WriteTimeToLog "Making dump(s) private.."
    echo "S:privacy" >> "$gDDTmpFolder"/dd_completed

    local targetIOreg="$gDumpFolderIoreg/IOReg.txt"
    local targetIOregDT="$gDumpFolderIoreg/IORegDT.txt"
    local targetSMBIOS="$gDumpFolderDmi/SMBIOS.txt"
    local targetSMBIOSbin="$gDumpFolderDmi/SMBIOS.bin"
    local targetSysProfTxt="$gDumpFolderSysProf/System-Profiler.txt"
    local targetSysProfSpx="$gDumpFolderSysProf/System-Profiler.spx"
    local targetNvramVars="$gDumpFolderNvram/uefi_firmware_vars.txt"
    local targetNvramPlist="$gDumpFolderNvram/nvram.plist"
    local targetNvramHexDump="$gDumpFolderNvram/nvram_hexdump.txt"

    local fmmToken=$( echo $(GetValue "fmm-mobileme-token-FMM" "IOService") | sed 's/^ *//g' )
    if [ ! "$fmmToken" == "" ]; then
        local fmmTokenSearchReplace=$(CreateFindReplaceString "${fmmToken[@]}")
    fi
    local serialNo=$( echo $(GetValue "IOPlatformSerialNumber" "IOService") | sed 's/^ *//g' )
    local serialNoSearchReplace=$(CreateFindReplaceString "${serialNo[@]}")
    local uuidNo=( $( echo $(GetValue "IOPlatformUUID" "IOService") | sed 's/^ *//g' ) )
    local uuidNoSearchReplace=$(CreateFindReplaceString "${uuidNo[@]}")
    local macAddress=( $( echo $(GetValue "IOMACAddress" "IOService") | sed 's/^ *//g' ) )
    local macAddressSearchReplace=$(CreateFindReplaceString "${macAddress[@]}")
    local usbSerialNo=( $( echo $(GetValue "USB Serial Number" "IOService") | sed 's/^ *//g' ) ) # iPhone / iPad can be here.
    local usbSerialNoSearchReplace=$(CreateFindReplaceString "${usbSerialNo[@]}")
    local systemId=( $( echo $(GetValue "system-id" "IODeviceTree") | sed 's/^ *//g' ) )
    local systemIdSearchReplace=$(CreateFindReplaceString "${systemId[@]}")
    local systemSerialNumber=( $( echo $(GetValue "SystemSerialNumber" "IODeviceTree") | sed 's/^ *//g' ) )
    local systemSerialNumberSearchReplace=$(CreateFindReplaceString "${systemSerialNumber[@]}")
    local serialNumber=( $( echo $(GetValue "serial-number" "IODeviceTree") | sed 's/^ *//g' ) )
    local serialNumberSearchReplace=$(CreateFindReplaceString "${serialNumber[@]}")

    # Mask IORegistry text files
    if [ -f "$targetIOreg" ]; then
        if [ ! "$fmmToken" == "" ]; then
            ApplyMask "$fmmTokenSearchReplace" "" "$targetIOreg"
        fi
        ApplyMask "$serialNoSearchReplace" "" "$targetIOreg"
        ApplyMask "$uuidNoSearchReplace" "" "$targetIOreg"
        ApplyMask "$macAddressSearchReplace" "" "$targetIOreg"
        ApplyMask "$usbSerialNoSearchReplace" "" "$targetIOreg"
    fi
    if [ -f "$targetIOregDT" ]; then
        ApplyMask "$serialNoSearchReplace" "" "$targetIOregDT"
        ApplyMask "$uuidNoSearchReplace" "" "$targetIOregDT"
        ApplyMask "$systemIdSearchReplace" "" "$targetIOregDT"
        ApplyMask "$systemSerialNumberSearchReplace" "" "$targetIOregDT"
        ApplyMask "$serialNumberSearchReplace" "" "$targetIOregDT"
    fi

    # Mask IORegistry Web Viewer files
    if [ ! "$fmmToken" == "" ]; then
        PatchFullIoregDump "fmm-mobileme-token-FMM" "$fmmTokenSearchReplace"
    fi
    PatchFullIoregDump "IOPlatformSerialNumber" "$serialNoSearchReplace"
    PatchFullIoregDump "IOPlatformUUID" "$uuidNoSearchReplace"
    PatchFullIoregDump "IOMACAddress" "$macAddressSearchReplace"
    PatchFullIoregDump "USB Serial Number" "$usbSerialNoSearchReplace"
    PatchFullIoregDump "system-id" "$systemIdSearchReplace"
    PatchFullIoregDump "serial-number" "$serialNumberSearchReplace"
    PatchFullIoregDump "SystemSerialNumber" "$systemSerialNumberSearchReplace" # may fail... so we do it again differently.
    # Special situation for masking systemSerialNumber in IORegistry Web Viewer.
    # On a real Mac each letter is enclosed in double quotes and these need to be escaped
    # Loop through each character of the serial number
    for (( s=0; s<${#serialNo}; s++ ))
    do
        local singleChar=${serialNo:$s:1}
        PatchFullIoregDump "SystemSerialNumber" "$singleChar"
    done

    # Mask System Profiler files.
    if [ -f "$targetSysProfTxt" ]; then
        ApplyMask "$usbSerialNoSearchReplace" "" "$targetSysProfTxt"
    fi
    if [ -f "$targetSysProfSpx" ]; then
        ApplyMask "$usbSerialNoSearchReplace" "" "$targetSysProfSpx"
    fi

    # Mask NVRAM Variables
    if [ ! "$fmmToken" == "" ]; then
        SearchAndMask "$targetNvramPlist" "fmm-mobileme-token-FMM" "<data>" "</data>"
        SearchAndMask "$targetNvramHexDump" "fmm-mobileme-token-FMM" "------------------------------------" ""
    fi
    SearchAndMask "$targetNvramHexDump" "platform-uuid" "------------------------------------" ""
    SearchAndMask "$targetNvramVars" "4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14:MLB" "------------------------------------" ""
    SearchAndMask "$targetNvramVars" "4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14:ROM" "------------------------------------" ""
    SearchAndMask "$targetNvramVars" "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:SystemSerial" "------------------------------------" ""

    # Mask bootloader configuration files.
    if [ -d "$gDumpFolderBootLoaderConfigs" ]; then
        maskBootloaderConfigData "CurrentCloverBootedConfig.plist" "SerialNumber"
        maskBootloaderConfigData "CurrentCloverBootedConfig.plist" "CustomUUID"
        maskBootloaderConfigData "config.plist" "SerialNumber"
        maskBootloaderConfigData "config.plist" "CustomUUID"
        maskBootloaderConfigData "config.plist" "SmUUID"
        maskBootloaderConfigData "config.plist" "MLB"
        maskBootloaderConfigData "config.plist" "ROM"
        maskBootloaderConfigData "SMBIOS.plist" "SMserial"
        maskBootloaderConfigData "org.chameleon.Boot.plist" "SystemId"
        maskBootloaderConfigData "settings.plist" "PlatformUUID"
        maskBootloaderConfigData "settings.plist" "SerialNumber" # retain for older versions.
        maskBootloaderConfigData "xpc_smbios.plist" "SerialNumber"
        maskBootloaderConfigData "settings.plist" "MLBData"
        maskBootloaderConfigData "Defaults.plist" "SystemSerial"
        maskBootloaderConfigData "Defaults.plist" "HardwareSignature"
    fi

    # Mask DMI dump files.
    if [ -f "$targetSMBIOS" ] || [ -f "$targetSMBIOSbin" ]; then
        # read UUID from ioreg
        local smbiosUuid=$( ioreg -lw0 | grep "SMBIOS" | egrep -v "AppleSMBIOS|SMBIOS-EPS|IOService" | tr '[:lower:]' '[:upper:]' )
        smbiosUuid="${smbiosUuid#*01020304}"
        smbiosUuid="${smbiosUuid:0:32}"

        if [ -f "$targetSMBIOS" ]; then
            ApplyMask "$serialNoSearchReplace" "" "$targetSMBIOS"

            # Find DMI type 2 Base Board Serial Number
            local region=$( grep -A 5 "Base Board Information" "$targetSMBIOS"  )
            local baseBoardSerial=${region##*Serial Number}
            baseBoardSerial=$( echo "${baseBoardSerial}" | head -n1 | tr -cd '[[:alnum:]]')
            local baseBoardSerialSearchReplace=$(CreateFindReplaceString "$baseBoardSerial")
            ApplyMask "$baseBoardSerialSearchReplace" "" "$targetSMBIOS"

            # Create formatted string for .txt file.
            local smbiosUuidFormatted="${smbiosUuid:0:8}-${smbiosUuid:8:4}-${smbiosUuid:12:4}-${smbiosUuid:16:4}-${smbiosUuid:20:12}"
            smbiosUuidFormatted=$(CreateFindReplaceString "$smbiosUuidFormatted")
            ApplyMask "$smbiosUuidFormatted" "" "$targetSMBIOS"
        fi
        if [ -f "$targetSMBIOSbin" ]; then
            ApplyMask "$serialNoSearchReplace" "" "$targetSMBIOSbin"

            local smbiosUuidBin=$( echo "$smbiosUuid" | sed 's/\(..\)/\1\\x/g' )
            smbiosUuidBin="\x$smbiosUuidBin"
            smbiosUuidBin="${smbiosUuidBin%*\\x}"

            # Create Mask
            local length=${#smbiosUuidBin}
            local parts=$(($length/4)) # Divide by 4 to allow for escaped back slash. \xE0
            smbiosUuidMask=$( printf "\\\\x2A"'%.0s' $( jot '' 1 $parts ) )

            # Apply
            local smbiosPerlSearchReplaceString="s|${smbiosUuidBin}|${smbiosUuidMask}|g"
            perl -pi -e "$smbiosPerlSearchReplaceString" "$targetSMBIOSbin"

            if [ "$baseBoardSerial" != "" ]; then
                # Convert to hex
                local baseBoardSerialHex=$( xxd -pu <<< "$baseBoardSerial" | tr [[:lower:]] [[:upper:]]  )
                baseBoardSerialHex=$( echo "$baseBoardSerialHex" | rev | cut -c 3- | rev )  # remove last 2 chars

                # Create formatted string for .bin file.
                baseBoardSerialBin=$( echo "$baseBoardSerialHex" | sed 's/\(..\)/\1\\x/g' )
                baseBoardSerialBin="\x$baseBoardSerialBin"
                baseBoardSerialBin="${baseBoardSerialBin%*\\x}"

                 # Create Mask
                local length=${#baseBoardSerialBin}
                local parts=$(($length/4)) # Divide by 4 to allow for escaped back slash. \xE0
                baseBoardSerialMask=$( printf "\\\\x2A"'%.0s' $( jot '' 1 $parts ) )

                # Apply
                smbiosPerlSearchReplaceString="s|${baseBoardSerialBin}|${baseBoardSerialMask}|g"
                perl -pi -e "$smbiosPerlSearchReplaceString" "$targetSMBIOSbin"
            fi
        fi
    fi

    # Mask Ozmosis Bootlog
    local checkOzmosisLog=$( find "$gDumpFolderBootLog" -type f -name "*Ozmosis*BootLog.txt" 2>/dev/null )
    if [ ! $checkOzmosisLog == "" ]; then
        ApplyMask "$serialNoSearchReplace" "" "$checkOzmosisLog"
        # Mask custom UUID
        local tmp=$( ioreg -lw0 | grep platform-uuid | tr -d '"' | tr -d '<>' | tr [[:lower:]] [[:upper:]] )
        tmp="${tmp##* }"
        platformUuid="${tmp:6:2}${tmp:4:2}${tmp:2:2}${tmp:0:2}-${tmp:10:2}${tmp:8:2}-${tmp:14:2}${tmp:12:2}-${tmp:16:2}${tmp:18:2}-${tmp:20:12}"
        local platformUuidSearchReplace=$(CreateFindReplaceString "${platformUuid[@]}")
        ApplyMask "$platformUuidSearchReplace" "" "$checkOzmosisLog"
    fi

    echo "Completed Privatising Dumps"
    echo "F:privacy" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
CloseLog()
{
    gScriptRunTime="$(($(date +%s)-gScriptRunTime))"
    echo "========================================================
DarwinDumper Completed in: ${gScriptRunTime} seconds
========================================================" >> "${gLogFile}"
}

# ---------------------------------------------------------------------------------------
ArchiveDumpFolder()
{
    local prevDateTime
    local existingDumpFolders=()
    local checkIcon=""

    if [ "$gRadio_archiveType" == "Archive.zip" ]; then
        echo "S:archive" >> "$gDDTmpFolder"/dd_completed
        echo "Compressing latest DarwinDumper folder using .zip"
        cd "${gThisIndexedDumpFolder}"
        zip -r -q "${gFolderName}".zip "${gFolderName}"
        sleep 1
        echo "F:archive" >> "$gDDTmpFolder"/dd_completed
    elif [ "$gRadio_archiveType" == "Archive.lzma" ]; then
        echo "S:archive" >> "$gDDTmpFolder"/dd_completed
        echo "Compressing latest DarwinDumper folder using .lzma"
        cd "${gThisIndexedDumpFolder}"
        tar -pvczf "${gFolderName}".tar.gz "${gFolderName}" &> /dev/null
        sleep 1
        "$lzma" e "${gThisIndexedDumpFolder}/${gFolderName}".tar.gz "${gThisIndexedDumpFolder}/${gFolderName}".tar.lzma
        chmod 755 "${gThisIndexedDumpFolder}/${gFolderName}".tar.lzma
        rm "${gThisIndexedDumpFolder}/${gFolderName}".tar.gz
        sleep 1
        echo "F:archive" >> "$gDDTmpFolder"/dd_completed
    fi
}

# ---------------------------------------------------------------------------------------
Finish()
{
    if [ -f "$gDDTmpFolder"/diskutilLoaderInfo.txt ]; then
        rm "$gDDTmpFolder"/diskutilLoaderInfo.txt # Created in the gatherDiskUtilLoaderinfo.sh script
    fi

    # Has the user asked not to open the folder and html file? (0 = show, 1 = do not show).
    if [ $gNoShow -ne 1 ]; then
        open "${gThisIndexedDumpFolder}/${gFolderName}"
        if [ -f "${gThisIndexedDumpFolder}/${gFolderName}"/" DarwinDump.htm" ]; then
            open "${gThisIndexedDumpFolder}/${gFolderName}"/" DarwinDump.htm"
        fi
    fi

    # If we created the containing indexed folder when running as root then the owner will be root.
    # Set it to the user which started to process.
    chown -R "${theBoss}":$theBossGroup "${gThisIndexedDumpFolder}"
}

#
# =======================================================================================
# SYSTEM SCAN & DUMP FILE ROUTINES
# =======================================================================================
#

# ---------------------------------------------------------------------------------------
DumpFilesAcpiTables()
{
    local acpi_tbls
    local tbl
    local tbl_name
    local tbl_data
    local dsdtSsdtAmlFiles=()
    local dsdtSsdtDslFiles=()

    echo "S:acpi" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderAcpi"

    # Snow Leopard's and Lion's plutil does not support the -p option.
    # We will now continue to read ACPI tables from ioreg for all except Yosemite.
    # In this case take ACPI tables from ioreg.
    checkSystemVersion=$(CheckOsVersion)
    if [ "$checkSystemVersion" == "Tiger" ] || [ "$checkSystemVersion" == "LEO" ] || [ "$checkSystemVersion" == "SL" ] || [ "$checkSystemVersion" == "Lion" ] || [ "$checkSystemVersion" == "ML" ] || [ "$checkSystemVersion" == "Mav" ]; then
        acpi_tbls=$( ioreg -lw0 | grep "ACPI Tables" | cut -f2 -d"{" | tr "," " " )
    else
        "$dumpACPI" > "$gDDTmpFolder"/acpiTables.plist
        acpi_tbls=$( /usr/bin/plutil -p "$gDDTmpFolder"/acpiTables.plist | sed 's/ //g' | cut -f2 -d "{" | tr "," " " | tr -d "}" )
    fi

    if [ ! "$acpi_tbls" == "" ]; then
        CreateDumpDirs "$gDumpFolderAcpiAml"
        for tbl in $acpi_tbls
        do
            tbl_name=$( echo $tbl | cut -f1 -d"=" | tr -d "\"" )
            echo "${gLogIndent}Found ACPI table: $tbl_name" >> "${gLogFile}"
            tbl_data=$( echo $tbl | cut -f2 -d"<" | tr -d ">" )
            echo $tbl_data | xxd -r -p > "$gDumpFolderAcpiAml"/$tbl_name.aml
            if [ ! $tbl_name == "DSDT" ] && [[ ! $tbl_name == SSDT* ]]; then
                "$iasl" -d "$gDumpFolderAcpiAml"/$tbl_name.aml &> /dev/null
                if [ -f "$gDumpFolderAcpiAml"/$tbl_name.dsl ]; then
                    echo "${gLogIndent}Disassembled ACPI table: $tbl_name" >> "${gLogFile}"
                else
                    echo "${gLogIndent}** Error disassembling ACPI table: $tbl_name" >> "${gLogFile}"
                fi
            fi
        done

        #Disassemble DSDT and any SSDT's as multiple tables from single namespace
        local oIFS="$IFS"; IFS=$'\n'
        dsdtSsdtAmlFiles+=( $( ls "$gDumpFolderAcpiAml"/SSDT*.aml ))
        if [ -f "$gDumpFolderAcpiAml"/DSDT.aml ]; then
            dsdtSsdtAmlFiles+=( "$gDumpFolderAcpiAml"/DSDT.aml )
        fi
        echo "${gLogIndent}Disassembling DSDT and SSDT's (${#dsdtSsdtAmlFiles[@]} files in total) as multiple tables from single namespace..." >> "${gLogFile}"
        local output=$( "$iasl" -da "$gDumpFolderAcpiAml"/SSDT*.aml "$gDumpFolderAcpiAml"/DSDT*.aml 2>&1 )

        # Check for any errors.
        if [[ $output == *Error* ]] || [[ $output == *Exception* ]]; then
            echo "${gLogIndent}** Error disassembling. Attaching iasl log to logfile." >> "${gLogFile}"
            echo "--------------------------------------------------------" >> "${gLogFile}"
            echo "$output" >> "${gLogFile}"
            echo "--------------------------------------------------------" >> "${gLogFile}"

            dsdtSsdtDslFiles+=( $( ls "$gDumpFolderAcpiAml"/SSDT*.dsl ))
            if [ -f "$gDumpFolderAcpiAml"/DSDT.dsl ]; then
                dsdtSsdtDslFiles+=( "$gDumpFolderAcpiAml"/DSDT.dsl )
            fi
            if [ ${#dsdtSsdtAmlFiles[@]} -ne ${#dsdtSsdtDslFiles[@]} ]; then
                echo "${gLogIndent}$((${#dsdtSsdtAmlFiles[@]}-${#dsdtSsdtDslFiles[@]})) .dsl files are missing. Will try disassembling as single files." >> "${gLogFile}"

                # Loop through list and find out which dsl files are missing
                for (( a=0; a < ${#dsdtSsdtAmlFiles[@]}; a++ ))
                do
                    if [[ ! "${dsdtSsdtDslFiles[*]}" =~ "${dsdtSsdtAmlFiles[$a]}" ]]; then
                        # Need to disassemble this as a single file
                        "$iasl" -d "${dsdtSsdtAmlFiles[$a]}" &> /dev/null
                        if [ -f "${dsdtSsdtAmlFiles[$a]}" ]; then
                            echo "${gLogIndent}Disassembled ACPI table: ${dsdtSsdtAmlFiles[$a]##*/}" >> "${gLogFile}"
                        else
                            echo "${gLogIndent}** Error disassembling ACPI table: ${dsdtSsdtAmlFiles[$a]##*/}" >> "${gLogFile}"
                        fi
                    fi
                done
            fi
        else
            echo "${gLogIndent}Disassembling was successful." >> "${gLogFile}"
        fi
        IFS="$oIFS"

        if [[ $( find "$gDumpFolderAcpiAml" -name *.dsl ) ]]; then
            CreateDumpDirs "$gDumpFolderAcpiDsl"
            mv "$gDumpFolderAcpiAml"/*.dsl "$gDumpFolderAcpiDsl"/
        fi
    fi
    printf '%03ds : -Completed AcpiTables\n' $(($(date +%s)-gScriptRunTime)) >> "${gLogFile}"
    echo "Completed ACPI Tables"
    echo "F:acpi" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesAudioCodec()
{
    # ---------------------------------------------------------------------------------------
    RunGetCodecID()
    {
        # Check which version of the getcodecid tool to run.
        local checkSystemVersion=$(CheckOsVersion)
        if [ "$checkSystemVersion" == "Tiger" ] || [ "$checkSystemVersion" == "LEO" ]; then
            gCodecID="Not Available"
            echo "$gCodecID" >> "$gDumpFolderAudio"/AudioCodecID.txt
            CheckSuccess "$gDumpFolderAudio/AudioCodecID.txt"
            echo "${gLogIndent}Audio: getcodecid failed to dump a codec ID." >> "${gLogFile}"
        else
            echo "${gLogIndent}Audio: Running getcodecid" >> "${gLogFile}"
            gunzip -c "$pciids" > "$gDDTmpFolder"/pci.ids && echo "${gLogIndent}Audio: pci.ids uncompressed" >> "${gLogFile}"
            oIFS="$IFS"; IFS=$'\n'
            gCodecID=( $("$getcodecid") )
            IFS="$oIFS"
            for ((c=0; c<${#gCodecID[@]}; c++));
            do
                if [[ "${gCodecID[$c]}" == *Controller* ]]; then
                    cVid="${gCodecID[$c]:13:4}"
                    cVendor=$( grep "^$cVid" "$gDDTmpFolder"/pci.ids )
                    cVendor=$( echo "$cVendor" | sed "s/^"$cVid"[ \t]*//;" )
                    cDid="${gCodecID[$c]:18:4}"
                    cDevice=$( grep "$(printf '\t'$cDid)" "$gDDTmpFolder"/pci.ids )
                    cDevice=$( echo "$cDevice" | sed "s/"$cDid"[ \t]*//;s/^[[:space:]]*//" )
                    echo "Controller: $cVendor $cDevice" >> "$gDumpFolderAudio"/AudioCodecID.txt
                else
                    echo "----------------------------------------" >> "$gDumpFolderAudio"/AudioCodecID.txt
                    local auDrv="${gCodecID[$c]%\**}"
                    auDrv="${auDrv##*\*}"
                    echo "$auDrv" >> "$gDumpFolderAudio"/AudioCodecID.txt
                    local codec="${gCodecID[$c]##*$auDrv\*}"
                    echo "Codec: $codec" | sed 's/(/[/g;s/)/]/g' >> "$gDumpFolderAudio"/AudioCodecID.txt
                fi
            done
            CheckSuccess "$gDumpFolderAudio/AudioCodecID.txt"
            echo "${gLogIndent}Audio: getcodecid completed audio codec ID dump" >> "${gLogFile}"
        fi
    }

    # ---------------------------------------------------------------------------------------
    RunVoodooHDAGetdump()
    {
        echo "${gLogIndent}Audio: Waiting 2 seconds before running VoodooHDA's getdump." >> "${gLogFile}"
        sleep 2
        echo "${gLogIndent}Audio: Running VoodooHDA's getdump..." >> "${gLogFile}"
        voodooDump=$( "$getdump" )

        if [ ! "$voodooDump" == "" ]; then
            echo "${gLogIndent}Audio: VoodooHDA's getdump was successful." >> "${gLogFile}"
            if [[ "$hdaCheck" == *AppleHDA* ]]; then
                echo "${gLogIndent}Audio: VoodooHDA's getdump may produce more info if AppleHDA is disabled." >> "${gLogFile}"
            fi
            echo "$voodooDump" > "$gDumpFolderAudio"/VoodooHDAGetdump.txt
        else
            echo "${gLogIndent}Audio: VoodooHDA's getdump tool failed to produce a dump." >> "${gLogFile}"
            echo "VoodooHDA's getdump tool failed to produce a dump." >> "$gDumpFolderAudio"/VoodooHDAGetdump.txt
            if [[ "$hdaCheck" == *AppleHDA* ]]; then
                echo "${gLogIndent}Audio: AppleHDA needs to be disabled for this dump to work properly." >> "${gLogFile}"
                echo "NOTE: AppleHDA was loaded when this dump was attempted." >> "$gDumpFolderAudio"/VoodooHDAGetdump.txt
                echo "If you wish to get a successful dump using VoodooHDA and it's associated getdump tool then AppleHDA will have to be disabled." >> "$gDumpFolderAudio"/VoodooHDAGetdump.txt
                echo "The simplest option to do that will be to add AppleHDADisabler.kext to your system, rebuild caches and reboot. Then try this dump again." >> "$gDumpFolderAudio"/VoodooHDAGetdump.txt
            else
                echo "NOTE: Apple HDA was not currently loaded at this time." >> "$gDumpFolderAudio"/VoodooHDAGetdump.txt
            fi
        fi
    }

    echo "S:codecid" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderAudio"

    # Check if either the AppleHDA or VoodooHDA drivers are loaded.
    local hdaCheck=$( kextstat | grep HDA )
    if [[ "$hdaCheck" == *AppleHDA* ]]; then
        echo "${gLogIndent}Audio: AppleHDA is loaded." >> "${gLogFile}"
    else
        echo "${gLogIndent}Audio: AppleHDA is not loaded." >> "${gLogFile}"
    fi

    if [[ "$hdaCheck" == *VoodooHDA* ]]; then
        echo "${gLogIndent}Audio: VoodooHDA is loaded." >> "${gLogFile}"
    else
        echo "${gLogIndent}Audio: VoodooHDA is not loaded." >> "${gLogFile}"
    fi

    # Try to run VoodooHDA's getdump tool.
    # Ideally this should be run with AppleHDA disabled and not registered in ioreg.

    # If VoodooHDA is not already present then try to load it
    if [[ ! "$hdaCheck" == *VoodooHDA* ]]; then
        echo "${gLogIndent}Audio: Attempting to load VoodooHDA.kext to run the getdump tool." >> "${gLogFile}"
        if [ $gRootPriv -eq 1 ]; then
            LoadVoodooHdaDriver
        else
            echo "${gLogIndent}Audio: ** Root privileges are required to load VoodooHDA.kext." >> "${gLogFile}"
        fi
    fi

    # Check again: Is VoodooHDA loaded on the system?
    local hdaCheck=$( kextstat | grep HDA )
    if [[ "$hdaCheck" == *VoodooHDA* ]]; then
        RunVoodooHDAGetdump
        # Run getcodecid tool to scan and print the codecs.
        RunGetCodecID
        UnloadVoodooHdaDriver
    else
        echo "${gLogIndent}Audio: Failed to load VoodooHDA.kext." >> "${gLogFile}"
        # Run getcodecid tool to scan and print the codecs.
        RunGetCodecID
    fi

    WriteTimeToLog "-Completed DumpFilesAudioCodec"
    echo "F:codecid" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesBiosROM()
{
    echo "S:biosSystem" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderBiosSystem"
    if [ $gRootPriv -eq 1 ]; then
        LoadPciUtilsDriver

        "$flashrom" -p internal > "$gDumpFolderBiosSystem"/flashrom_check.txt
        local checkChips=$( grep "Multiple flash chip definitions match the detected chip(s)" "$gDumpFolderBiosSystem"/flashrom_check.txt)
        if [ ! "$checkChips" == "" ]; then
            echo "${gLogIndent}Multiple flash chip definitions match the detected chip(s)" >> "${gLogFile}"
            local chipNames=($(echo "${checkChips##*: \"}" | tr "\", \"" "\n"))
            echo "${gLogIndent}Running flashrom with chipname ${chipNames[0]}" >> "${gLogFile}"
            "$flashrom" -p internal -c "${chipNames[0]}" -r "$gDumpFolderBiosSystem"/biosbackup.rom -o "$gDumpFolderBiosSystem"/flashrom_log.txt &> /dev/null
        else # Only a single chip present
            "$flashrom" -p internal -r "$gDumpFolderBiosSystem"/biosbackup.rom -o "$gDumpFolderBiosSystem"/flashrom_log.txt &> /dev/null
        fi
        CheckSuccess "$gDumpFolderBiosSystem/biosbackup.rom"
        UnloadPciUtilsDriver

        if [ -f "$gDumpFolderBiosSystem"/flashrom_check.txt ]; then
            rm "$gDumpFolderBiosSystem"/flashrom_check.txt
        fi
    else
        echo "** Root privileges required to dump system bios." >> "${gLogFile}"
    fi
    WriteTimeToLog "-Completed DumpFilesBiosROM"
    echo "Completed BIOS System ROM"
    echo "F:biosSystem" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesBiosVideoROM()
{
    declare -a vendorIds
    declare -a deviceIds
    declare -a ioregRomDumpHex

    echo "S:biosVideo" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderBiosVideo"
    if [ $gRootPriv -eq 1 ]; then

        # Use Andy Vandijck's RadeonDump tool to dump from memory address 0xC0000 which can
        # be the shadow ROM used by the BIOS (PC's only, not real Macs). The tool can dump
        # VBIOS ROM's for ATI, Nvidia and intel.

        LoadRadeonPciDriver

        # The RadeonDump tool saves the ROM to the same DIR it's called from.
        cd "$gDumpFolderBiosVideo"

        local checkSystemVersion=$(CheckOsVersion)
        echo "${gLogIndent}Running RadeonDump" >> "${gLogFile}"
        if [ "$checkSystemVersion" == "Leo" ]; then
            "$radeonDumpLeo" -d &> /dev/null
        else
            "$radeonDump" -d &> /dev/null
        fi

        local numDumpedRoms=$( ls "$gDumpFolderBiosVideo" | wc -l )
        numDumpedRoms="${numDumpedRoms//[[:space:]]}"
        echo "${gLogIndent}Number of legacy VBIOS ROM's dumped: $numDumpedRoms" >> "${gLogFile}"

        UnloadRadeonPciDriver

        # If there are more GPU's reported by System Profiler than ROM's dumped with Andy's
        # RadeonDump then an attempt is made to extract any ATI legacy VBIOS ROM from IORegistry.

        # Get the system GPUs from System Profiler.
        oIFS="$IFS"; IFS=$'\n'
        vendorIds+=( $(/usr/sbin/system_profiler SPDisplaysDataType | grep "Vendor:" ))
        deviceIds+=( $(/usr/sbin/system_profiler SPDisplaysDataType | grep "Device ID:" ))
        IFS="$oIFS"
        local numGpus=${#vendorIds[@]}

        # Check the number of ROMs dumped against that shown in system profiler.
        if [ $numGpus -gt $numDumpedRoms ]; then
            # System Profiler shows more GPUs than were dumped - One reason is this could be a real Mac.
            echo "${gLogIndent}Note: System Profiler shows more GPUs than dumped VBIOS ROM's." >> "${gLogFile}"

            # Look for, and save any ATI ROM(s) from IORegistry in to array
            ioregRomDumpHex+=( $( ioreg -lw0 | grep "ATY,bin_image" | sed 's/.*= <//g;s/>//g' ))
            echo "${gLogIndent}Number of ATI ROM images found in IORegistry: ${#ioregRomDumpHex[@]}" >> "${gLogFile}"

            # Loop through array and write any found ROM's to file.
            for (( d=0; d<${#ioregRomDumpHex[@]}; d++ ))
            do
                # Scan ROM for Vendor & Device ID
                # Want to find 0x50434952 (ASCII for PCIR)
                local hexToFind="50434952"
                local hexPosition="${ioregRomDumpHex[$d]%%$hexToFind*}"
                hexPosition="${#hexPosition}"

                # Read the next 4 bytes (taking in to account little endian)
                local romVendorID=${ioregRomDumpHex[$d]:$(($hexPosition+10)):2}${ioregRomDumpHex[$d]:$(($hexPosition+8)):2}
                local romDeviceID=${ioregRomDumpHex[$d]:$(($hexPosition+14)):2}${ioregRomDumpHex[$d]:$(($hexPosition+12)):2}

                local filename="$gDumpFolderBiosVideo"/"$romVendorID"."$romDeviceID".from_ioreg_${d}.rom
                echo "${ioregRomDumpHex[$d]}" | xxd -r -p > "$filename"

                # Check if file was successfully written
                if [ -f "$filename" ]; then
                    echo "${gLogIndent}Extracted legacy VBIOS ROM from IORegistry" >> "${gLogFile}"
                else
                    echo "${gLogIndent}Failed to write $filename to file" >> "${gLogFile}"
                fi
            done
        elif [ $numGpus -lt $numDumpedRoms ]; then
            echo "${gLogIndent}** Note: More VBIOS ROMs were dumped than System Profiler shows!" >> "${gLogFile}"
        fi

        # Look for any EFI VBIOS ROMS (Thanks to xsmile for info).
        # The only place to look for now is in an ACPI table named VFCT
        acpiTableToFind="VFCT"

        # Find and read ACPI table data
        echo "${gLogIndent}Looking for existence of ACPI table: $acpiTableToFind" >> "${gLogFile}"
        checkSystemVersion=$(CheckOsVersion)
        if [ "$checkSystemVersion" == "Tiger" ] || [ "$checkSystemVersion" == "LEO" ] || [ "$checkSystemVersion" == "SL" ] || [ "$checkSystemVersion" == "Lion" ] || [ "$checkSystemVersion" == "ML" ] || [ "$checkSystemVersion" == "Mav" ]; then
            acpi_tbls=$( ioreg -lw0 | grep "ACPI Tables" | cut -f2 -d"{" | tr "," " " )
        else # Yosemite no longer has ACPI tables in ioreg.
           "$dumpACPI" > "$gDDTmpFolder"/acpiTables.plist
            acpi_tbls=$( /usr/bin/plutil -p "$gDDTmpFolder"/acpiTables.plist | sed 's/ //g' | cut -f2 -d "{" | tr "," " " | tr -d "}" )
        fi

        # Does ACPI Table exist?
        if [ ! "$acpi_tbls" == "" ]; then
            for tbl in $acpi_tbls
            do
                tbl_name=$( echo $tbl | cut -f1 -d"=" | tr -d "\"" )
                if [ $tbl_name == "$acpiTableToFind" ]; then
                    echo "${gLogIndent}Found ACPI table: $tbl_name" >> "${gLogFile}"
                    tbl_data=$( echo $tbl | cut -f2 -d"<" | tr -d ">" )
                    break
                fi
            done
        fi

        # Extract GOP EFI ROM
        if [ ! "$tbl_data" == "" ]; then

            # Check to see if table data contains signature.
            if [[ "$tbl_data" == *55aa* ]]; then
                echo "${gLogIndent}ACPI table $tbl_name contains signature" >> "${gLogFile}"

                # Scan ROM for Vendor & Device ID
                hexToFind="55aa"
                romImage="${tbl_data#*$hexToFind}"
                romImage="55aa${romImage}"

                hexToFind="50434952"
                hexPosition="${romImage%%$hexToFind*}"
                hexPosition="${#hexPosition}"

                # Read the next 4 bytes (taking in to account little endian)
                romVendorID=${romImage:$(($hexPosition+10)):2}${romImage:$(($hexPosition+8)):2}
                romDeviceID=${romImage:$(($hexPosition+14)):2}${romImage:$(($hexPosition+12)):2}

                echo "${gLogIndent}Identified ROM VendorID:$romVendorID | DeviceID:$romDeviceID" >> "${gLogFile}"

                filename="$gDumpFolderBiosVideo"/$romVendorID.$romDeviceID.from_ACPI_$acpiTableToFind.rom
                echo "$romImage" | xxd -r -p > "$filename"

                # Check if file was successfully written
                if [ -f "$filename" ]; then
                    echo "${gLogIndent}Extracted VBIOS ROM from ACPI $tbl_name" >> "${gLogFile}"
                else
                    echo "${gLogIndent}Failed to write $filename to file" >> "${gLogFile}"
                fi
            else
                echo "No Signature found"
            fi
        fi

        # Check for ROMs and perform decode, analysis, disassembly.
        declare -a videoRomFile
        oIFS="$IFS"; IFS=$'\n'
        videoRomFile=($( find "$gDumpFolderBiosVideo" -type f -name "*.rom" 2>/dev/null ))
        IFS="$oIFS"

        for (( v=0; v<${#videoRomFile[@]}; v++ ))
        do
            local romFileName="${videoRomFile[$v]##*/}"
            # Check to see if this is an ATI ROM
            if [ "${romFileName:0:4}" == "1002" ]; then
                if [ -f "${videoRomFile[$v]}" ]; then
                    # Decode any ATI ROM's with Andy's radeon_bios_decode tool.
                    "$radeonDecode" < "${videoRomFile[$v]}" > "${videoRomFile[$v]}".decoded.txt
                    echo "${gLogIndent}Decoded VBIOS ROM file:$romFileName" >> "${gLogFile}"
                    "$atomdis" "${videoRomFile[$v]}" F > "${gDumpFolderBiosVideo}/$romFileName".disassembled.txt
                    echo "${gLogIndent}Disassembled VBIOS ROM file:$romFileName" >> "${gLogFile}"
                fi
            fi
            # Check to see if this is an NVIDIA ROM
            if [ "${romFileName:0:4}" == "10DE" ]; then
                if [ -f "${videoRomFile[$v]}" ]; then
                    # Run AnalyseVBIOS against the nvidia rom.
                    "$AnalyseVBIOS" "${videoRomFile[$v]}" > "${gDumpFolderBiosVideo}/$romFileName".analysed.txt
                    echo "${gLogIndent}Analysed VBIOS ROM file:$romFileName" >> "${gLogFile}"
                fi
            fi
        done

    else
        echo "** Root privileges required to dump video bios." >> "${gLogFile}"
    fi
    WriteTimeToLog "-Completed DumpFilesBiosVideoROM"
    echo "Completed BIOS Video ROM"
    echo "F:biosVideo" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesCpuInfo()
{
    echo "S:cpuinfo" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderCPU"

    # Run x86info binary as normal user, regardless of running with root privileges or not.
    sudo -u "$theBoss" "$x86info" -a > "$gDumpFolderCPU"/cpuinfo.txt
    CheckSuccess "$gDumpFolderCPU"/cpuinfo.txt

    WriteTimeToLog "-Completed DumpFilesCpuInfo"
    echo "Completed CPU Info"
    echo "F:cpuinfo" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesDeviceProperties()
{
    echo "S:devprop" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderDevProps"
    ioreg -lw0 -p IODeviceTree -n efi -r -x | grep device-properties | sed 's/.*<//;s/>.*//;' | cat > "$gDumpFolderDevProps"/device-properties.hex
    CheckSuccess "$gDumpFolderDevProps"/device-properties.hex
    "$gfxutil" -s -i hex -o xml "$gDumpFolderDevProps"/device-properties.hex "$gDumpFolderDevProps"/device-properties.plist
    CheckSuccess "$gDumpFolderDevProps/device-properties.plist"

    WriteTimeToLog "-Completed DumpFilesDeviceProperties"
    echo "Completed Device Properties"
    echo "F:devprop" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesDiskUtilConfigsAndLoaders()
{
    "$gatherDiskUtilLoaderinfo" "${gMasterDumpFolder}" "$1" "$2" "$3"

    # Run Slice's genconfig tool if using Clover rev1672 or newer.
    # The tool is NOT in DarwinDumper but instead will have been installed
    # on the users' system in /usr/bin/local by the Clover installer.

    # Find if Clover was used to boot the system
    if [ ! $gRefitVers == "" ] && [ $gRefitVers -gt 1672 ]; then

        # Did the user ask to dump the bootloader configs?
        if [ $gCheckBox_diskLoaderConfigs -eq 1 ]; then

            # Check directory exists before running binary.
            if [ ! -d "$gDumpFolderBootLoaderConfigs" ]; then
                mkdir -p "$gDumpFolderBootLoaderConfigs"
            fi

            if [ -d "$gDumpFolderBootLoaderConfigs" ]; then
                 # Check to see if the tool is installed on the running system
                 if [ -f /usr/local/bin/clover-genconfig ]; then
                     echo "${gLogIndent}/usr/local/bin/clover-genconfig found - dump current Clover boot config" >> "${gLogFile}"
                     /usr/local/bin/clover-genconfig > "$gDumpFolderBootLoaderConfigs"/CurrentCloverBootedConfig.plist
                 else
                     echo "${gLogIndent}/usr/local/bin/clover-genconfig not installed." >> "${gLogFile}"
                 fi
            fi
        fi
    fi

    # ---------------------------------------------------------------------------------------
    BuildBootLoadersFile()
    {
        local passedTextLine="$1"
        if [ ! "$passedTextLine" == "" ]; then
            buildString="${buildString}"$(printf "${passedTextLine}\n")
            buildString="${buildString}\n"
        fi
    }

    local fileToRead="$gDDTmpFolder"/diskutilLoaderInfo.txt # Created in the gatherDiskUtilLoaderinfo.sh script
    local finalOutFile="$gDumpFolderBootLoader/Boot Loaders.txt"
    buildString=""
    declare -a description

    if [ $gCheckBox_bootLoaderBootSectors -eq 1 ]; then
        mkdir -p "$gDumpFolderBootLoader"
    fi

    if [ -f "$fileToRead" ]; then
        while read -r lineRead
        do
            if [ ! "${lineRead:0:1}" == "=" ]; then
                codeRead="${lineRead%%:*}"
                detailsRead="${lineRead#*:}"
                if [ "$detailsRead" == "" ]; then
                    detailsRead=" "
                fi

                case "$codeRead" in
                    "WD") BuildBootLoadersFile " @ @ @ @ @ @ @ @ " # Add blank separator line to string for outfile.
                          BuildBootLoadersFile " @ @ @ @ @ @ @ @ " # Add blank separator line to string for outfile.
                          device="${detailsRead}" ;;
                    "DN") description+=("$device ${detailsRead}") # Append device model and physical byte info to array
                          BuildBootLoadersFile "!!${#description[@]}" # we search for !!n and replace with description later
                          BuildBootLoadersFile "ACT@DEVICE@TYPE@NAME@SIZE@MBR (Stage0)@PBR (Stage1)@BootFile (Stage 2)@UEFI BootFile"
                          ;;
                    "DS") diskSize="${detailsRead}" ;;
                    "DT") diskType="${detailsRead}" ;;
                    "S0") stageZero="${detailsRead}"
                          BuildBootLoadersFile " @ @${diskType}@ @${diskSize}@${stageZero}" ;;
                    "VA") volumeActive="${detailsRead}" ;;
                    "VD") volumeDevice="${detailsRead}" ;;
                    "VT") volumeType="${detailsRead}" ;;
                    "VN") volumeName="${detailsRead}" ;;
                    "VS") volumeSize="${detailsRead}" ;;
                    "S1") stageOne="${detailsRead}"
                          BuildBootLoadersFile "${volumeActive}@${volumeDevice}@${volumeType}@${volumeName}@${volumeSize}@ @${stageOne}" ;;
                    "BF") bootFile="${detailsRead}" ;;
                    "S2") if [ "${detailsRead}" == "" ] || [[ "${detailsRead}" =~ ^\ +$ ]] ;then # if blank or only whitespace
                              stageTwo=""
                          else
                              stageTwo="(${detailsRead})"
                          fi
                          BuildBootLoadersFile " @ @ @ @ @ @ @${bootFile}${stageTwo}";;
                    "UF") uefiFile="${detailsRead}" ;;
                    "U2") if [ "${detailsRead}" == "" ] || [[ "${detailsRead}" =~ ^\ +$ ]] ;then # if blank or only whitespace
                              uefiFileVersion=""
                          else
                              uefiFileVersion="(${detailsRead})"
                          fi
                          BuildBootLoadersFile " @ @ @ @ @ @ @ @${uefiFile}${uefiFileVersion}" ;;
                esac
            fi
        done < "$fileToRead"
        printf "$buildString" | column -t -s@ >> "$finalOutFile"

        #Add device number and physical block size - held in $description[]
        for (( d=0; d<${#description[@]}; d++ ))
        do
            idx=$(($d + 1))
            LANG=C sed -ie "s/!!${idx}/${description[$d]}/" "$finalOutFile"
        done

        # Add separator lines in to text file.
        # Find longest line length
        lineLen=$( awk ' { if ( length > x ) { x = length } }END{ print x }' "$finalOutFile" )
        # Create string to insert above title
        topLine=$( LANG=C printf "="'%.0s' $( jot '' 1 $lineLen ))
        # Create string to insert below title
        botLine=$( LANG=C printf "–"'%.0s' $( jot '' 1 $lineLen ))
        # Add double lines before ACT, after disk name / physical block size line
        LANG=C sed -ie 's/^ACT/'"${topLine}"'\'$'\nACT/g' "$finalOutFile"
        # Add lines after title line
        LANG=C sed -ie 's/BootFile$/BootFile\'$'\n'"${botLine}"'/g' "$finalOutFile"
        # Tidy up
        if [ -f "$finalOutFile"e ]; then
            rm "$finalOutFile"e
        fi

        echo "F:bootLoaderBootSectors" >> "$gDDTmpFolder"/dd_completed
    fi
    WriteTimeToLog "-Completed DumpFilesDiskUtilConfigsAndLoaders"
    echo "Completed DiskUtil, Configs and Boot Loaders"
}

# ---------------------------------------------------------------------------------------
DumpFilesBootLog()
{
    # Different loaders identify differently so rather than try to work
    # out which loader was used before running bdmesg, let's just run it
    # anyway and remove the resulting file it doesn't contain a dump.
    echo "S:bootlog" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderBootLog"
    "$bdmesg" > "$gDumpFolderBootLog/${gTheLoader}_BootLog.txt"
    # Read size of the file and delete if smaller than 4KB
    local fileSize=$( du -k "$gDumpFolderBootLog/${gTheLoader}_BootLog.txt" | cut -f1 )
    if [ $fileSize -le 4 ]; then
        rm "$gDumpFolderBootLog/${gTheLoader}_BootLog.txt"
        echo "${gLogIndent}Boot Log not available."
        echo "${gLogIndent}Boot Log not available." >> "${gLogFile}"
    else
        echo "Dumped ${gTheLoader} boot log."
        echo "${gLogIndent}Dumped ${gTheLoader} boot log." >> "${gLogFile}"
        CheckSuccess "$gDumpFolderBootLog/${gTheLoader}_BootLog.txt"
    fi
    WriteTimeToLog "-Completed DumpFilesBootLog"
    echo "Completed Boot Log"
    echo "F:bootlog" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesFirmwareMemoryMap()
{
    echo "S:firmmemmap" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderMemory"

    # Check Security Integrity Configuration allows dtace if running El Capitan
    checkSystemVersion=$(CheckOsVersion)
    if [ "$checkSystemVersion" == "Cap" ]; then
        local checkProbe=$( sudo dtrace -l | grep fbt | head -n 1 )
        
        # Note: I found once when booted with SIP Dtrace enabled that the fbt check above returned:
        # 141023        fbt com.dong.driver.RadeonPCI _ZN19RadeonPCIUserClient11clientCloseEv [RadeonPCIUserClient::clientClose()] entry
        # This return was enough to allow the FirmwareMemoryMap script to run which should not happen.
         
        if [ "${checkProbe}" != "" ] && [[ "${checkProbe}" != *com.dong.driver.RadeonPCI* ]]; then
            if [ $gRootPriv -eq 1 ]; then
                "$sbmm" > "$gDumpFolderMemory/FirmwareMemoryMap.txt"
                wait
                CheckSuccess "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            else
                echo "** Root privileges required to dump firmware memory map." >> "${gLogFile}"
            fi
        else
            # Write to command line and file
            local message="The OS X security settings disallow the memory map dump from running.";
            echo "$message"; echo "$message" > "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            message="If you wish to run this then you can do one of the following, then reboot:";
            echo "$message"; echo "$message" >> "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            message="1 - Disable security by booting in to the Recovery HD and using the Security Configuration utility.";
            echo "$message"; echo "$message" >> "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            message="2 - Change bootloader csr-active-config settings to enable CSR_ALLOW_UNRESTRICTED_DTRACE bit";
            echo "$message"; echo "$message" >> "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            message="* Don't forget to reverse this change after performing the dump.";
            echo "$message"; echo "$message" >> "$gDumpFolderMemory/FirmwareMemoryMap.txt"
        fi
    else
        if [ $gRootPriv -eq 1 ]; then
            "$sbmm" > "$gDumpFolderMemory/FirmwareMemoryMap.txt"
            wait
            CheckSuccess "$gDumpFolderMemory/FirmwareMemoryMap.txt"
        else
            echo "** Root privileges required to dump firmware memory map." >> "${gLogFile}"
        fi
    fi

  	WriteTimeToLog "-Completed DumpFilesFirmwareMemoryMap"
    echo "Completed Firmware Memory Map"
    echo "F:firmmemmap" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpACPIfromMem()
{
    echo "S:dumpacpifrommem" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderAcpiAmlFromMem"
    if [ $gRootPriv -eq 1 ]; then

        # Has a firmware memory map already been created?
        if [ ! -f "$gDumpFolderMemory/FirmwareMemoryMap.txt" ]; then
            echo "${gLogIndent}Memory: ** Memory map required before reading ACPI tables from memory." >> "${gLogFile}"
            echo "${gLogIndent}Memory: ** Running firmware memory map dump option." >> "${gLogFile}"
            # Generate memory dump
            DumpFilesFirmwareMemoryMap "$gDumpFolderAcpiAmlFromMem"
        fi

        LoadPmemDriver
        "$dumpACPIfromMem" "${gDumpFolderAcpiAmlFromMem}"
        UnloadPmemDriver
    else
        echo "${gLogIndent}Memory: ** Root privileges are required to dump ACPI tables from memory." >> "${gLogFile}"
    fi
    WriteTimeToLog "-Completed DumpACPIfromMem"
    echo "Completed ACPI Tables from Memory"
    echo "F:dumpacpifrommem" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesIntelGraphicsMemoryRegions()
{
    convertHexToDec()
    {
        local passedHex="$1"
        local len="${#passedHex}"
        local converted=0
        if [ $len -eq 2 ]; then
            (( converted = 16#$(echo $passedHex | sed 's,\(..\),\1,g') ))
        elif [ $len -eq 4 ]; then
            (( converted = 16#$(echo $passedHex | sed 's,\(..\)\(..\),\1\2,g') ))
        elif [ $len -eq 8 ]; then
            (( converted = 16#$(echo $passedHex | sed 's,\(..\)\(..\)\(..\)\(..\),\1\2\3\4,g') ))
        elif [ $len -eq 16 ]; then
            (( converted = 16#$(echo $passedHex | sed 's,\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\),\1\2\3\4\5\6\7\8,g') ))
        fi
        echo $converted
    }

    echo "S:intelGraphicsMemRegions" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderMemoryRegions"

    if [ $gRootPriv -eq 1 ]; then
        LoadPmemDriver

        # Set up array of start and ending memory addresses (thanks Pike).
        declare -a AddressRegionsFinish
        AddressRegionsStart+=( "00000000" );AddressRegionsFinish+=( "00000fff" )
        AddressRegionsStart+=( "00002000" );AddressRegionsFinish+=( "00002fff" )
        AddressRegionsStart+=( "00003000" );AddressRegionsFinish+=( "000031ff" )
        AddressRegionsStart+=( "00003200" );AddressRegionsFinish+=( "00003fff" )
        AddressRegionsStart+=( "00005000" );AddressRegionsFinish+=( "00005fff" )
        AddressRegionsStart+=( "00006000" );AddressRegionsFinish+=( "00006fff" )
        AddressRegionsStart+=( "00007000" );AddressRegionsFinish+=( "00007fff" )
        AddressRegionsStart+=( "00007400" );AddressRegionsFinish+=( "000088ff" )
        AddressRegionsStart+=( "0000a000" );AddressRegionsFinish+=( "0000afff" )
        AddressRegionsStart+=( "00010000" );AddressRegionsFinish+=( "00013fff" )
        AddressRegionsStart+=( "00030000" );AddressRegionsFinish+=( "0003ffff" )
        AddressRegionsStart+=( "00060000" );AddressRegionsFinish+=( "0006ffff" )
        AddressRegionsStart+=( "00070000" );AddressRegionsFinish+=( "00072fff" )
        AddressRegionsStart+=( "00073000" );AddressRegionsFinish+=( "00073fff" )

        # Read each memory region and write to disk
        if [ "${#AddressRegionsStart[@]}" -gt 0 ]; then

            echo "${gLogIndent}Memory: Scanning memory regions." >> "${gLogFile}"
            echo "Scanning memory regions."

            local byteCount=2048
            for ((a=0; a<"${#AddressRegionsStart[@]}"; a++))
            do
                # Calculate length of region.
                local startAddr="${AddressRegionsStart[$a]}"
                local finishAddr="${AddressRegionsFinish[$a]}"

                local regionStart=$(convertHexToDec ${startAddr})
                local regionFinish=$(convertHexToDec ${finishAddr})
                local regionLength=$(( $regionFinish - $regionStart ))
                ((regionLength++))

                local blockCount=$(( $regionLength / $byteCount ))
                local skipBytes=$(( $regionStart / $byteCount ))

                echo "${gLogIndent}Memory: Writing $regionLength bytes from (${startAddr} to ${finishAddr}) to disk" >> "${gLogFile}"
                sudo dd 2>/dev/null if=/dev/pmem bs=$byteCount count=$blockCount skip=$skipBytes > "${gDumpFolderMemoryRegions}/IntelGraphics_${startAddr}_${finishAddr}"
           done
           echo "${gLogIndent}Memory: Scanning complete." >> "${gLogFile}"
           echo "Scanning complete."
        fi
        UnloadPmemDriver
    else
        echo "${gLogIndent}Memory: ** Root privileges are required to dump memory regions." >> "${gLogFile}"
    fi

}

# ---------------------------------------------------------------------------------------
DumpFilesIoreg()
{
    local ioregwvSaveDir="/tmp/dataFiles" # This is hardcoded in to the ioregwv binary.
    local ioregServiceDumpFile="$gDumpFolderIoreg"/IORegDump
    local ioregDTDumpFile="$gDumpFolderIoreg"/IORegDTDump
    local ioregACPIDumpFile="$gDumpFolderIoreg"/IORegACPIDump
    local ioregPowerDumpFile="$gDumpFolderIoreg"/IORegPOWERDump
    local ioregUSBDumpFile="$gDumpFolderIoreg"/IORegUSBDump

    echo "S:ioreg" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderIoreg"

    echo "${gLogIndent}Running ioregwv..." >> "${gLogFile}"
    "$ioregwv" -lw0 -pIOService >/dev/null
    "$ioregwv" -lw0 -pIODeviceTree >/dev/null
    "$ioregwv" -lw0 -pIOACPIPlane >/dev/null
    "$ioregwv" -lw0 -pIOPower >/dev/null
    "$ioregwv" -lw0 -pIOUSB >/dev/null

    # Add necessary scripts to IOReg dump folder.
    cp -R "$ioregViewerDir" "$gDumpFolderIoreg" #/IORegViewer/

    # Add created files from /tmp to DarwinDump folder.
    if [ -d "$ioregwvSaveDir" ]; then
        cp -R "$ioregwvSaveDir" "$gDumpFolderIoreg"/IORegViewer/Resources

       # Clean up
        rm -rf "$ioregwvSaveDir"
    fi

    # Add alias to viewer file in to IORegistry directory.
    ln -s "$gDumpFolderIoreg"/IORegViewer/IORegFileViewer.html "$gDumpFolderIoreg"/IORegFileViewer

    # Also add normal ioreg text dumps
    ioreg -lw0 > "$gDumpFolderIoreg"/IOReg.txt
    ioreg -lw0 -pIODeviceTree > "$gDumpFolderIoreg"/IORegDT.txt

 	WriteTimeToLog "-Completed DumpFilesIoreg"
    echo "Completed Ioreg"
    echo "F:ioreg" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesAppleSystemLog()
{
    echo "S:asl" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderKernelLogs"

    # Get last boot log from Apple System Logs
    echo "${gLogIndent}Attempting to read last ASL boot log..." >> "${gLogFile}"

    local hostName=$( scutil --get LocalHostName )
    declare -a appleSystemLogs
    appleSystemLogs=($( find /var/log/asl -type f -name "*.U0.G80.asl" 2>/dev/null ))

    local iterations=$((${#appleSystemLogs[@]}-1))
    for (( v=$iterations; v>=0; v-- ))
    do
        local checkDarwin=$( grep "Darwin Kernel Version" "${appleSystemLogs[$v]}")
        if [ ! "$checkDarwin" == "" ]; then
            /usr/bin/syslog -f "${appleSystemLogs[$v]}" > "$gDDTmpFolder"/asl_tmp.txt
            grep -E "localhost kernel|$hostName kernel" "$gDDTmpFolder"/asl_tmp.txt > "$gDDTmpFolder"/asl_log.txt
            echo "${gLogIndent}Found ${appleSystemLogs[$v]}" >> "${gLogFile}"
            # Get 500 (—B 500) lines, in reverse order (tail -r) from the last occurrence (-m 1) of string Darwin Kernel Version
            tail -r "$gDDTmpFolder"/asl_log.txt | grep 'Darwin Kernel Version' -m 1 -B 500 | tail -r > "$gDumpFolderKernelLogs"/AppleSystemLog.txt
            CheckSuccess "$gDumpFolderKernelLogs/AppleSystemLog.txt"
            rm "$gDDTmpFolder"/asl_log.txt
            rm "$gDDTmpFolder"/asl_tmp.txt
            break
        fi
    done

    if [ ! -f "$gDumpFolderKernelLogs"/AppleSystemLog.txt ]; then
        local timeSinceBoot=$( /usr/sbin/system_profiler SPSoftwareDataType | grep "Time" )
        timeSinceBoot="${timeSinceBoot##*: }"
        echo "Apple System Log file /var/log/asl/*.U0.G80.asl no longer exists." > "$gDumpFolderKernelLogs"/AppleSystemLog.txt
        echo "System was last booted on ${lastBootedNoSpace}. It's been running for $timeSinceBoot" >> "$gDumpFolderKernelLogs"/AppleSystemLog.txt
        echo "${gLogIndent}System has been booted for $timeSinceBoot" >> "${gLogFile}"
        echo "${gLogIndent}Apple System Log file no longer exists." >> "${gLogFile}"
    fi

 	WriteTimeToLog "-Completed DumpFilesAppleSystemLog"
    echo "Completed Apple System Log"
    echo "F:asl" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesKernelLogs()
{
    echo "S:kerneldmesg" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderKernelLogs"
    if [ $gRootPriv -eq 1 ]; then
        echo "${gLogIndent}Attempting to dump kernel buffer using dmesg..." >> "${gLogFile}"
        /sbin/dmesg > "$gDumpFolderKernelLogs"/dmesg.txt
        CheckSuccess "$gDumpFolderKernelLogs/dmesg.txt"
    else
        echo "** Root privileges required to dump kernel dmesg." >> "${gLogFile}"
    fi

 	WriteTimeToLog "-Completed DumpFilesKernelLogs"
    echo "Completed Kernel Logs"
    echo "F:kerneldmesg" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesKernelInfo()
{
    echo "S:kernelinfo" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderKernelInfo"
    uname -v | cat > "$gDumpFolderKernelInfo"/kernel_version.txt
    /usr/sbin/sysctl -a | grep cpu | cat >> "$gDumpFolderKernelInfo"/sysctl_cpu.txt
    CheckSuccess "$gDumpFolderKernelInfo/sysctl_cpu.txt"
    /usr/sbin/sysctl -a | grep hw | cat >> "$gDumpFolderKernelInfo"/sysctl_hw.txt
    CheckSuccess "$gDumpFolderKernelInfo/sysctl_hw.txt"
    # Add machdep.xcpm dump - Thanks Pike - http://bit.ly/NHg1JH
    /usr/sbin/sysctl -a machdep.xcpm | cat >> "$gDumpFolderKernelInfo"/sysctl_machdep_xcpm.txt
    CheckSuccess "$gDumpFolderKernelInfo/sysctl_machdep_xcpm.txt"
 	WriteTimeToLog "-Completed DumpFilesKernelInfo"
    echo "Completed Kernel Info"
    echo "F:kernelinfo" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesKextLists()
{
    echo "S:kexts" >> "$gDDTmpFolder"/dd_completed

    CreateDumpDirs "$gDumpFolderKexts"
    echo "${gLogIndent}Dumping Kext lists..." >> "${gLogFile}"
    /usr/sbin/kextstat -l | egrep -v "com.apple" > "$gDumpFolderKexts"/NonAppleKexts.txt
    CheckSuccess "$gDumpFolderKexts/NonAppleKexts.txt"
    /usr/sbin/kextstat -l | egrep "com.apple" > "$gDumpFolderKexts"/AppleKexts.txt
    CheckSuccess "$gDumpFolderKexts/AppleKexts.txt"
    WriteTimeToLog "-Completed DumpFilesKextLists"
    echo "Completed Kext Lists"
    echo "F:kexts" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesLspci()
{
    # ---------------------------------------------------------------------------------------
    Updatepciids()
    {
        local SRC="http://pci-ids.ucw.cz/v2.2/pci.ids.gz"
        local DEST="$pciids"
        local DL

        # Update pciids file every week. Check to see if current file
        # is older than seven days - if so, update.
        if [ $( find "$DEST" -mtime +7 ) ]; then
            echo  "${gLogIndent}Update pciids database" >> "${gLogFile}"

            # Test server is available
            local testConnection=$(curl --silent --head http://pci-ids.ucw.cz | egrep "OK")
            if [ "$testConnection" ]; then
                echo "${gLogIndent}Update pciids" >> "${gLogFile}"
                if which curl >/dev/null ; then
                	DL="curl -o $DEST $SRC"
                elif which wget >/dev/null ; then
            	    DL="wget -O $DEST $SRC"
                elif which lynx >/dev/null ; then
            	    DL="eval lynx -source $SRC >$DEST"
                else
            	    echo  "${gLogIndent}update-pciids: cannot find curl, wget or lynx" >> "${gLogFile}"
        	        return 1
                fi

                if ! $DL ; then
        	        echo  "${gLogIndent}update-pciids: download failed" >> "${gLogFile}"
        	        rm -f $DEST
        	        return 1
                fi
            else
                echo "${gLogIndent}Note: pciids server not available." >> "${gLogFile}"
            fi
        else
            echo "${gLogIndent}pciids file < 7 days old. No update required." >> "${gLogFile}"
        fi
    }

    if [ $gRootPriv -eq 1 ]; then
        Updatepciids
        if [[ $( find "${pciids}" ) ]]; then

            echo "${gLogIndent}Dumping LSPCI info..." >> "${gLogFile}"
            echo "S:lspci" >> "$gDDTmpFolder"/dd_completed
            CreateDumpDirs "$gDumpFolderLspci"
            LoadPciUtilsDriver
            "$lspci" -i "$pciids" -nnvv > "$gDumpFolderLspci/lspci (nnvv).txt"
            CheckSuccess "$gDumpFolderLspci/lspci (nnvv).txt"
 	        "$lspci" -i "$pciids" -nnvvbxxxx > "$gDumpFolderLspci/lspci detailed (nnvvbxxxx).txt"
 	        CheckSuccess "$gDumpFolderLspci/lspci detailed (nnvvbxxxx).txt"
	        "$lspci" -i "$pciids" -nnvvt > "$gDumpFolderLspci/lspci tree (nnvvt).txt"
	        CheckSuccess "$gDumpFolderLspci/lspci tree (nnvvt).txt"
        	"$lspci" -i "$pciids" -M > "$gDumpFolderLspci/lspci map (M).txt"
        	CheckSuccess "$gDumpFolderLspci/lspci map (M).txt"
        	UnloadPciUtilsDriver
        else
    	    echo "${gLogIndent}Error DumpFilesLspci" >> "${gLogFile}"
        fi
    else
        echo "** Root privileges required to load DirectHW.kext and run lspci." >> "${gLogFile}"
    fi
    WriteTimeToLog "-Completed DumpFilesLspci"
    echo "Completed lspci"
    echo "F:lspci" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesOpenCLInfo()
{
    echo "S:opencl" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderOpenCl"
    "$oclinfo" > "$gDumpFolderOpenCl/openCLinfo.txt"
    CheckSuccess "$gDumpFolderOpenCl/openCLinfo.txt"
    WriteTimeToLog "-Completed DumpFilesOpenCLInfo"
    echo "Completed OpenCL Info"
    echo "F:opencl" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesRtc()
{
    echo "S:rtc" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderRtc"
    "$rtcdumper" > "$gDumpFolderRtc/RTCDump${rtclength}.txt"
    CheckSuccess "$gDumpFolderRtc/RTCDump${rtclength}.txt"
    wait
    WriteTimeToLog "-Completed DumpFilesRtc"
    echo "Completed RTC"
    echo "F:rtc" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesDmiTables()
{
    echo "S:dmi" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderDmi"
    cd "$gDumpFolderDmi"
    "$smbiosreader"
    mv "$gDumpFolderDmi"/dump.bin "$gDumpFolderDmi/SMBIOS.bin"
    CheckSuccess "$gDumpFolderDmi/SMBIOS.bin"
    "$dmidecode" -i "$gDumpFolderDmi/SMBIOS.bin" | cat > "$gDumpFolderDmi/SMBIOS.txt"
    CheckSuccess "$gDumpFolderDmi/SMBIOS.txt"
    WriteTimeToLog "-Completed DumpFilesDmiTables"
    echo "Completed DMI Tables"
    echo "F:dmi" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpSip()
{
    echo "S:sip" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderSip"
    "$csrStat" > "$gDumpFolderSip/SIP_status.txt"
    LANG=C sed -ie 's/\[1m//g;s/\[0m//g' "$gDumpFolderSip/SIP_status.txt"
    [[ -f "$gDumpFolderSip/SIP_status.txt"e ]] && rm "$gDumpFolderSip/SIP_status.txt"e
    CheckSuccess "$gDumpFolderSip/SIP_status.txt"
    WriteTimeToLog "-Completed DumpSip"
    echo "Completed SIP"
    echo "F:sip" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesSmcKeys()
{
    echo "S:smc" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderSmc"
    "$smcutil" -l | cat > "$gDumpFolderSmc/SMC-keys.txt"
    CheckSuccess "$gDumpFolderSmc/SMC-keys.txt"
    "$smcutil" -f | cat > "$gDumpFolderSmc/SMC-fans.txt"
    CheckSuccess "$gDumpFolderSmc/SMC-fans.txt"
    WriteTimeToLog "-Completed DumpFilesSmcKeys"
    echo "Completed SMC Keys"
    echo "F:smc" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesSystemProfilerInfo()
{
    echo "S:sysprof" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderSysProf"
    /usr/sbin/system_profiler -xml -detailLevel mini | cat > "$gDumpFolderSysProf"/System-Profiler.spx
    CheckSuccess "$gDumpFolderSysProf/System-Profiler.spx"
    /usr/sbin/system_profiler -detailLevel mini > "$gDumpFolderSysProf"/System-Profiler.txt
    CheckSuccess "$gDumpFolderSysProf/System-Profiler.txt"
    WriteTimeToLog "-Completed DumpFilesSystemProfilerInfo"
    echo "Completed System Profiler"
    echo "F:sysprof" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesRcScripts()
{
    echo "S:rcscripts" >> "$gDDTmpFolder"/dd_completed

    # Dump any Clover RC scripts.
    local filesToFind=(rc.local rc.shutdown.local rc.clover.lib)
    for (( f=0; f<${#filesToFind[@]}; f++ ))
    do
        if [ -f /etc/${filesToFind[$f]} ]; then
            CreateDumpDirs "$gDumpFolderRcScripts"
            cp /etc/${filesToFind[$f]} "$gDumpFolderRcScripts/${filesToFind[$f]}"
            CheckSuccess "$gDumpFolderRcScripts/${filesToFind[$f]}"
        fi
    done

    local dirsToFind=(rc.boot.d rc.shutdown.d)
    for (( f=0; f<${#dirsToFind[@]}; f++ ))
    do
        if [ -d /etc/${dirsToFind[$f]} ]; then
        CreateDumpDirs "$gDumpFolderRcScripts"
        cp -R /etc/${dirsToFind[$f]} "$gDumpFolderRcScripts"
    fi
    done

    WriteTimeToLog "-Completed DumpFilesRcScripts"
    echo "Completed RC Scripts"
    echo "F:rcscripts" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesNvram()
{
    # Apple Specific Vars
    echo "S:nvram" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderNvram"
    "$nvramTool" -x -p >"$gDumpFolderNvram"/nvram.plist
    CheckSuccess "$gDumpFolderNvram/nvram.plist"
    "$nvramTool" -hp >"$gDumpFolderNvram"/nvram_hexdump.txt
    CheckSuccess "$gDumpFolderNvram/nvram_hexdump.txt"
    echo "Completed NVRAM - Apple specific vars"

    # UEFI Firmware Vars
    echo "S:misc" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderNvram"
    "$nvramTool" -ha > "$gDumpFolderNvram/uefi_firmware_vars.txt"
    CheckSuccess "$gDumpFolderNvram/nvram.plist"

    WriteTimeToLog "-Completed DumpFilesNvram"
    echo "Completed NVRAM - UEFI firmware vars"
    echo "F:nvram" >> "$gDDTmpFolder"/dd_completed
}

# ---------------------------------------------------------------------------------------
DumpFilesEdid()
{
    echo "S:edid" >> "$gDDTmpFolder"/dd_completed
    CreateDumpDirs "$gDumpFolderEdid"

    # check in case there's more than one EDID occurrence in ioreg
    local numEdid=$(/usr/sbin/ioreg -lw0 | grep IODisplayEDID | wc -l | tr -d ' ')
    if [ $numEdid -gt 1 ]; then
        echo "${gLogIndent}Found $numEdid EDID's in ioreg" >> "${gLogFile}"
        for (( e=1; e<=$numEdid; e++ ))
        do
            local lineWanted="sed -n ${e}p"
            /usr/sbin/ioreg -lw0 | grep IODisplayEDID | sed -ne 's/.*EDID" = <//p' | tr -d '>' | $lineWanted > "$gDumpFolderEdid"/EDID${e}.hex
            "$ediddecode" "$gDumpFolderEdid"/EDID${e}.hex | cat > "$gDumpFolderEdid/EDID${e}.txt"
            CheckSuccess "$gDumpFolderEdid/EDID${e}.txt"
            /usr/bin/xxd -r -p "$gDumpFolderEdid"/EDID${e}.hex > "$gDumpFolderEdid"/EDID${e}.bin
            CheckSuccess "$gDumpFolderEdid/EDID${e}.bin"
        done
    elif [ $numEdid -eq 1 ]; then
        echo "${gLogIndent}Found 1 EDID in ioreg" >> "${gLogFile}"
        /usr/sbin/ioreg -lw0 | grep IODisplayEDID | sed -ne 's/.*EDID" = <//p' | tr -d '>' > "$gDumpFolderEdid"/EDID.hex
        "$ediddecode" "$gDumpFolderEdid"/EDID.hex | cat > "$gDumpFolderEdid/EDID.txt"
        CheckSuccess "$gDumpFolderEdid/EDID.txt"
        /usr/bin/xxd -r -p "$gDumpFolderEdid"/EDID.hex > "$gDumpFolderEdid"/EDID.bin
        CheckSuccess "$gDumpFolderEdid/EDID.bin"
    fi #else

        # If booted using Clover, check bootlog for EDID.
        "$bdmesg" > "$gDumpFolderEdid/${gTheLoader}_BootLog.txt"
        if [ -f "$gDumpFolderEdid/${gTheLoader}_BootLog.txt" ]; then
            local checkClover=$( grep Clover "$gDumpFolderEdid/${gTheLoader}_BootLog.txt" )
            if [ "$checkClover" != "" ]; then
                echo "${gLogIndent}Checking Clover bootlog for EDID data" >> "${gLogFile}"
                local cloverBootLog="$gDumpFolderEdid/${gTheLoader}_BootLog.txt"
                declare -a readLog

                oIFS="$IFS"; IFS=$'\n';
                readLog=( $( grep -A16 EdidDiscovered "$cloverBootLog" ))
                IFS="$oIFS"

                # Check next line contains fixed EDID header 00 FF FF FF FF FF FF 00
                if [[ "${readLog[1]}" == *"00 FF FF FF FF FF FF 00"* ]]; then
                    if [ ${#readLog[@]} -gt 0 ]; then
                        readTo=0
                        edidSize=${readLog[0]##*size=}
                        if [[ $edidSize == 128* ]]; then
                            readTo=9
                        elif [[ $edidSize == 256* ]]; then
                            readTo=17
                        fi
                        if [ $readTo -gt 0 ]; then
                            for ((e=1; e<$readTo; e++));
                            do
                                tmp="${readLog[$e]##*| }"
                                tmp="${tmp//[[:space:]]}"
                                edidHex="${edidHex}$tmp"
                            done
                        else
                            echo "${gLogIndent}EDID data found is invalid size: $edidSize" >> "${gLogFile}"
                        fi
                        echo "${gLogIndent}EDID data found. Writing to file" >> "${gLogFile}"
                        echo "$edidHex" > "$gDumpFolderEdid"/EDID_from_Clover_bootlog.hex
                        "$ediddecode" "$gDumpFolderEdid"/EDID_from_Clover_bootlog.hex | cat > "$gDumpFolderEdid/EDID_from_Clover_bootlog.txt"
                        CheckSuccess "$gDumpFolderEdid/EDID_from_Clover_bootlog.txt"
                        /usr/bin/xxd -r -p "$gDumpFolderEdid"/EDID_from_Clover_bootlog.hex > "$gDumpFolderEdid"/EDID_from_Clover_bootlog.bin
                        CheckSuccess "$gDumpFolderEdid/EDID_from_Clover_bootlog.bin"
                    else
                        echo "${gLogIndent}No EDID data found in bootlog" >> "${gLogFile}"
                    fi
                else
                    echo "${gLogIndent}No EDID data found under EdidDiscovered in bootlog" >> "${gLogFile}"
                fi
            fi
        fi
        rm "$gDumpFolderEdid/${gTheLoader}_BootLog.txt"
    #fi
    WriteTimeToLog "-Completed DumpFilesEdid"
    echo "Completed EDID"
    echo "F:edid" >> "$gDDTmpFolder"/dd_completed
}
#
# =======================================================================================
# MAIN
# =======================================================================================
#

InitialiseBeforeUI
ProcessUserChoices
CheckRoot
InitialiseAfterUI

gScriptRunTime="$(date +%s)"
gSic=""

# Call routines to scan system and dump text files.
# as long as the cancel button was not ticked.
if [ $gButton_cancel -eq 0 ]; then
    CreateDumpDirs "$gMasterDumpFolder"
    echo "========================================================" > "${gLogFile}"
    echo "Welcome to DarwinDumper ${gtheVersion}" >> "${gLogFile}"
    echo "$( date )" >> "${gLogFile}"
    tmp=$( /usr/sbin/system_profiler SPSoftwareDataType | grep "System Version:" | sed 's/^ *//g' )
    echo "$tmp" >> "${gLogFile}"

    # Get Security Integrity Configuration if running El Capitan
    checkSystemVersion=$(CheckOsVersion)
    if [ "$checkSystemVersion" == "Cap" ]; then

        # csr setting would have already been read by init script.
        # result would have been written to file, like: 0,0,1,1,1,0,0,0
        if [ -f "$gDDTmpFolder"/dd_csr ]; then
            readCsrFromFile=$( cat "$gDDTmpFolder"/dd_csr )
            readCsrFromFile=$( echo "$readCsrFromFile" | tr -d ',' )  
            
            csrIntKern=$( "$csrStat" | grep -o '(0x.*' | cut -c10-11 | tr [[:lower:]] [[:upper:]] )

            if [ "$csrIntKern" == "80" ]; then
                gSic="80"
            else
                csrDec=$( echo "$((2#$readCsrFromFile))" )            
                gSic=$( printf "%x\n" $csrDec )
            fi

            if [ "$gSic" != "" ]; then
                if [ "$gSic" == "0" ]; then
                    gSic="Enabled (00) | Internal ($csrIntKern)"
                elif [ "$gSic" == "6f" ]; then
                    gSic="Disabled ($gSic) | Internal ($csrIntKern)"
	            else
	                [[ ${#gSic} -eq 1 ]] && gSic=0$gSic
    	            gSic="Custom ($gSic) | Internal ($csrIntKern)"
    	        fi
            fi

        else # if this does not exist then El Capitan defaults to security enabled.
            gSic="Enabled (00) | Internal ($csrIntKern)"
        fi
        echo "Security Integrity Configuration: $gSic" >> "${gLogFile}"
    fi

    echo "========================================================" >> "${gLogFile}"

    # Append prelogfile (any messages before this point) to the main log.
    if [ -f "$gTmpPreLogFile" ]; then
        echo "Initialisation info" >> "${gLogFile}"
        echo "--------------------------------------------------------" >> "${gLogFile}"
        cat "$gTmpPreLogFile" >> "${gLogFile}"
        echo "--------------------------------------------------------" >> "${gLogFile}"
    fi

    echo "Initiating dumps..."

    # Run the dumps in stages otherwise the system could grind to a complete halt!
    newProcessCount=0
    if [ $gCheckBox_kerneldmesg -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesKernelLogs & pidFilesKernelLogs=$! ; flagKL=0
        WriteTimeToLog "+Started process DumpFilesKernelLogs: pid $pidFilesKernelLogs"
    fi
    if [ $gCheckBox_asl -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesAppleSystemLog & pidFilesAsl=$! ; flagAL=0
        WriteTimeToLog "+Started process DumpFilesAppleSystemLog: pid $pidFilesAsl"
    fi
    if [ $gCheckBox_sysprof -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesSystemProfilerInfo & pidFilesSytemProfilerInfo=$! ; flagSP=0
        WriteTimeToLog "+Started process DumpFilesSystemProfilerInfo: pid $pidFilesSytemProfilerInfo"
    fi
    if [ $gCheckBox_diskLoaderConfigs -eq 1 ] || [ $gCheckBox_bootLoaderBootSectors -eq 1 ] || [ $gCheckBox_diskPartitionInfo -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesDiskUtilConfigsAndLoaders "$gCheckBox_diskLoaderConfigs" "$gCheckBox_bootLoaderBootSectors" "$gCheckBox_diskPartitionInfo" & pidFilesDiskUtilAndLoader=$! ; flagDU=0
        WriteTimeToLog "+Started process DumpFilesDiskUtilConfigsAndLoaders: pid $pidFilesDiskUtilAndLoader"
    fi
    if [ $gCheckBox_biosSystem -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesBiosROM & pidFilesBiosROM=$! ; flagFB=0
        WriteTimeToLog "+Started process DumpFilesBiosROM: pid $pidFilesBiosROM"
    fi
    if [ $gCheckBox_biosVideo -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesBiosVideoROM & pidFilesBiosVideoROM=$! ; flagFV=0
        WriteTimeToLog "+Started process DumpFilesBiosVideoROM: pid $pidFilesBiosVideoROM"
    fi
    if [ $newProcessCount -gt 0 ]; then
        c=0
        while sleep 0.5; do
            if [ $gCheckBox_kerneldmesg -eq 1 ]; then
                kill -0 $pidFilesKernelLogs &> /dev/null || if [ $flagKL -eq 0 ]; then ((c++)); flagKL=1; fi
            fi
            if [ $gCheckBox_asl -eq 1 ]; then
                kill -0 $pidFilesAsl &> /dev/null || if [ $flagAL -eq 0 ]; then ((c++)); flagAL=1; fi
            fi
            if [ $gCheckBox_sysprof -eq 1 ]; then
                kill -0 $pidFilesSytemProfilerInfo &> /dev/null || if [ $flagSP -eq 0 ]; then ((c++)); flagSP=1; fi
            fi
            if [ $gCheckBox_diskLoaderConfigs -eq 1 ] || [ $gCheckBox_bootLoaderBootSectors -eq 1 ] || [ $gCheckBox_diskPartitionInfo -eq 1 ]; then
                kill -0 $pidFilesDiskUtilAndLoader &> /dev/null || if [ $flagDU -eq 0 ]; then ((c++)); flagDU=1; fi
            fi
            if [ $gCheckBox_biosSystem -eq 1 ]; then
                kill -0 $pidFilesBiosROM &> /dev/null|| if [ $flagFB -eq 0 ]; then ((c++)); flagFB=1; fi
            fi
            if [ $gCheckBox_biosVideo -eq 1 ]; then
                kill -0 $pidFilesBiosVideoROM &> /dev/null|| if [ $flagFV -eq 0 ]; then ((c++)); flagFV=1; fi
            fi
            if [ $c -eq $newProcessCount ]; then
                break
            fi
        done
        #wait
    fi

    newProcessCount=0
    if [ $gCheckBox_acpi -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesAcpiTables & pidFilesAcpiTables=$! ; flagAT=0
        WriteTimeToLog "+Started process DumpFilesAcpiTables: pid $pidFilesAcpiTables"
    fi
    if [ $gCheckBox_audioCodec -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesAudioCodec & pidFilesAudioCodec=$! ; flagAC=0
        WriteTimeToLog "+Started process DumpFilesAudioCodec: pid $pidFilesAudioCodec"
    fi
    if [ $gCheckBox_firmmemmap -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesFirmwareMemoryMap & pidFirmwareMemoryMap=$! ; flagFM=0
        WriteTimeToLog "+Started process DumpFilesFirmwareMemoryMap: pid $pidFirmwareMemoryMap"
    fi
    if [ $gCheckBox_acpiFromMem -eq 1 ]; then
        ((newProcessCount++))
        DumpACPIfromMem & pidAcpiFromMem=$! ; flagAM=0
        WriteTimeToLog "+Started process DumpAcpiFromMem: pid $pidAcpiFromMem"
    fi
    if [ $gCheckBox_memIntelGraphics -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesIntelGraphicsMemoryRegions & pidMemIntelG=$! ; flagMI=0
        WriteTimeToLog "+Started process DumpFilesIntelGraphicsMemoryRegions: pid $pidMemIntelG"
    fi
    if [ $gCheckBox_kexts -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesKextLists & pidFilesKextLists=$! ; flagKL=0
        WriteTimeToLog "+Started process DumpFilesKextLists: pid $pidFilesKextLists"
    fi
    if [ $gCheckBox_bootlog -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesBootLog & pidFilesBootLog=$! ; flagFL=0
        WriteTimeToLog "+Started process DumpFilesBootLog: pid $pidFilesBootLog"
    fi
    if [ $gCheckBox_devprop -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesDeviceProperties & pidFilesDeviceProperties=$! ; flagDP=0
        WriteTimeToLog "+Started process DumpFilesDeviceProperties: pid $pidFilesDeviceProperties"
    fi
    if [ $gCheckBox_opencl -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesOpenCLInfo & pidFilesOpenCLInfo=$! ; flagOC=0
        WriteTimeToLog "+Started process DumpFilesOpenCLInfo: pid $pidFilesOpenCLInfo"
    fi
    if [ $gCheckBox_kernelinfo -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesKernelInfo & pidFilesKernelInfo=$! ; flagKI=0
        WriteTimeToLog "+Started process DumpFilesKernelInfo: pid $pidFilesKernelInfo"
    fi
    if [ $gCheckBox_sip -eq 1 ]; then
        ((newProcessCount++))
        DumpSip & pidSip=$! ; flagSiP=0
        WriteTimeToLog "+Started process DumpSip: pid $pidSip"
    fi
    if [ $gCheckBox_smc -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesSmcKeys & pidFilesSmcKeys=$! ; flagSK=0
        WriteTimeToLog "+Started process DumpFilesSmcKeys: pid $pidFilesSmcKeys"
    fi
    if [ $gCheckBox_rtc -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesRtc & pidFilesRtc=$! ; flagRT=0
        WriteTimeToLog "+Started process DumpFilesRtc: pid $pidFilesRtc"
    fi
    if [ $gCheckBox_rcscripts -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesRcScripts & pidFilesRcScripts=$! ; flagMS=0
        WriteTimeToLog "+Started process DumpFilesRcScripts: pid $pidFilesRcScripts"
    fi
    if [ $newProcessCount -gt 0 ]; then
        c=0
        while sleep 0.5; do
            if [ $gCheckBox_acpi -eq 1 ]; then
                kill -0 $pidFilesAcpiTables &> /dev/null || if [ $flagAT -eq 0 ]; then ((c++)); flagAT=1; fi
            fi
            if [ $gCheckBox_audioCodec -eq 1 ]; then
                kill -0 $pidFilesAudioCodec &> /dev/null || if [ $flagAC -eq 0 ]; then ((c++)); flagAC=1; fi
            fi
            if [ $gCheckBox_firmmemmap -eq 1 ]; then
                kill -0 $pidFirmwareMemoryMap &> /dev/null || if [ $flagFM -eq 0 ]; then ((c++)); flagFM=1; fi
            fi
            if [ $gCheckBox_acpiFromMem -eq 1 ]; then
                kill -0 $pidAcpiFromMem &> /dev/null || if [ $flagAM -eq 0 ]; then ((c++)); flagAM=1; fi
            fi
            if [ $gCheckBox_memIntelGraphics -eq 1 ]; then
                kill -0 $pidMemIntelG &> /dev/null || if [ $flagMI -eq 0 ]; then ((c++)); flagMI=1; fi
            fi
            if [ $gCheckBox_kexts -eq  1 ]; then
                kill -0 $pidFilesKextLists &> /dev/null || if [ $flagKL -eq 0 ]; then ((c++)); flagKL=1; fi
            fi
            if [ $gCheckBox_bootlog -eq 1 ]; then
                kill -0 $pidFilesBootLog &> /dev/null || if [ $flagFL -eq 0 ]; then ((c++)); flagFL=1; fi
            fi
            if [ $gCheckBox_devprop -eq 1 ]; then
                kill -0 $pidFilesDeviceProperties &> /dev/null || if [ $flagDP -eq 0 ]; then ((c++)); flagDP=1; fi
            fi
            if [ $gCheckBox_opencl -eq 1 ]; then
                kill -0 $pidFilesOpenCLInfo &> /dev/null || if [ $flagOC -eq 0 ]; then ((c++)); flagOC=1; fi
            fi
            if [ $gCheckBox_kernelinfo -eq 1 ]; then
                kill -0 $pidFilesKernelInfo &> /dev/null || if [ $flagKI -eq 0 ]; then ((c++)); flagKI=1; fi
            fi
            if [ $gCheckBox_sip -eq 1 ]; then
                kill -0 $pidSip &> /dev/null || if [ $flagSiP -eq 0 ]; then ((c++)); flagSiP=1; fi
            fi
            if [ $gCheckBox_smc -eq 1 ]; then
                kill -0 $pidFilesSmcKeys &> /dev/null || if [ $flagSK -eq 0 ]; then ((c++)); flagSK=1; fi
            fi
            if [ $gCheckBox_rtc -eq 1 ]; then
                kill -0 $pidFilesRtc &> /dev/null || if [ $flagRT -eq 0 ]; then ((c++)); flagRT=1; fi
            fi
            if [ $gCheckBox_rcscripts -eq 1 ]; then
                kill -0 $pidFilesRcScripts &> /dev/null || if [ $flagMS -eq 0 ]; then ((c++)); flagMS=1; fi
            fi
            if [ $c -eq $newProcessCount ]; then
                break
            fi
        done
        #wait
    fi

    newProcessCount=0
    if [ $gCheckBox_lspci -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesLspci & pidFilesLspci=$! ; flagLS=0
        WriteTimeToLog "+Started process DumpFilesLspci: pid $pidFilesLspci"
    fi
    if [ $gCheckBox_dmi -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesDmiTables & pidFilesDmiTable=$! ; flagDT=0
        WriteTimeToLog "+Started process DumpFilesDmiTables: pid $pidFilesDmiTable"
    fi
    if [ $gCheckBox_nvram -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesNvram & pidFilesNvram=$! ; flagNP=0
        WriteTimeToLog "+Started process DumpFilesNvram: pid $pidFilesNvram"
    fi
    if [ $gCheckBox_edid -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesEdid & pidFilesEdid=$! ; flagED=0
        WriteTimeToLog "+Started process DumpFilesEdid: pid $pidFilesEdid"
    fi
    if [ $gCheckBox_cpuInfo -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesCpuInfo & pidFilesCpuInfo=$! ; flagCI=0
        WriteTimeToLog "+Started process DumpFilesCpuInfo: pid $pidFilesCpuInfo"
    fi
    if [ $newProcessCount -gt 0 ]; then
        c=0
        while sleep 0.5; do
            if [ $gCheckBox_lspci -eq 1 ]; then
                kill -0 $pidFilesLspci &> /dev/null || if [ $flagLS -eq 0 ]; then ((c++)); flagLS=1; fi
            fi
            if [ $gCheckBox_dmi -eq 1 ]; then
                kill -0 $pidFilesDmiTable &> /dev/null || if [ $flagDT -eq 0 ]; then ((c++)); flagDT=1; fi
            fi
            if [ $gCheckBox_nvram -eq 1 ]; then
                kill -0 $pidFilesNvram &> /dev/null || if [ $flagNP -eq 0 ]; then ((c++)); flagNP=1; fi
            fi
            if [ $gCheckBox_edid -eq 1 ]; then
                kill -0 $pidFilesEdid &> /dev/null || if [ $flagED -eq 0 ]; then ((c++)); flagED=1; fi
            fi
            if [ $gCheckBox_cpuInfo -eq 1 ]; then
                kill -0 $pidFilesCpuInfo &> /dev/null || if [ $flagCI -eq 0 ]; then ((c++)); flagCI=1; fi
            fi
            if [ $c -eq $newProcessCount ]; then
                break
            fi
        done
        #wait
    fi

    newProcessCount=0
    if [ $gCheckBox_ioreg -eq 1 ]; then
        ((newProcessCount++))
        DumpFilesIoreg & pidFilesIoreg=$! ; flagIO=0
        WriteTimeToLog "+Started process DumpFilesIoreg: pid $pidFilesIoreg"
    fi
    if [ $newProcessCount -gt 0 ]; then
        c=0
        while sleep 0.5; do
            if [ $gCheckBox_ioreg -eq 1 ]; then
                kill -0 $pidFilesIoreg &> /dev/null || if [ $flagIO -eq 0 ]; then ((c++)); flagIO=1; fi
            fi
            if [ $c -eq $newProcessCount ]; then
                break
            fi
        done
    fi

    if [ "$gRadio_privacy" == "Private" ]; then
        Privatise
    fi

    dumpTime="$(($(date +%s)-gScriptRunTime))"
    echo "========================================================
Dumps complete after: ${dumpTime} seconds
--------------------------------------------------------" >> "${gLogFile}"

    # Did the user request the HTML report?
    if [ $gCheckBox_enablehtml -eq 1 ]; then

        # We pass the audio codec to the generateHTMLreport script
        # for adding to the header of the HTML report.
        # If the user chose to dump the audio codec and it was successful
        # then we can read it from the dumped file.

        oIFS="$IFS"; IFS=$'\r\n'
        tmp=()

        # Did the user request the audio dump?
        if [ $gCheckBox_audioCodec -eq 1 ]; then
            if [ -f "$gDumpFolderAudio"/AudioCodecID.txt ]; then
                tmp=($( cat "$gDumpFolderAudio"/AudioCodecID.txt | grep Codec: ))
            fi
        else
            # Try finding the info now.
            # This should get the codec ID's in most instances except
            # OS X 10.6 where getcodecidSL fails for VoodooHDA. - does this still happen???
            hdaCheck=$( kextstat | grep HDA )
            if [[ "$hdaCheck" == *AppleHDA* ]] || [[ "$hdaCheck" == *VoodooHDA* ]]; then
                checkSystemVersion=$(CheckOsVersion)
                if [ "$checkSystemVersion" == "Tiger" ] || [ "$checkSystemVersion" == "LEO" ]; then
                    tmp+=("Not Available")
                elif [ "$checkSystemVersion" == "SL" ] && [[ "$hdaCheck" == *VoodooHDA* ]]; then
                    # getcodecidSl fails with VoodooHDA driver on OS X 10.6
                    tmp+=("Please choose the Audio dump.")
                else
                    oIFS="$IFS"; IFS=$'\n'
                    gCodecID=( $("$getcodecid") )
                    IFS="$oIFS"
                    for ((c=0; c<${#gCodecID[@]}; c++));
                    do
                       if [[ "${gCodecID[$c]}" != *Controller* ]]; then
                           codec="${gCodecID[$c]##*\*}"
                           tmp+=( $( echo "${codec}" | sed 's/(/[/g;s/)/]/g') )
                       fi
                    done

                fi
            fi
            # Do we really need to go down the route of loading VoodooHDA and runnning
            # the getdump tool just to determine the codec ID's?
            # Problem with that is user may not have chosen to run with root privileges.
            # In which case it will fail!
            if [ "$tmp" == "" ]; then
                tmp+=("Not Available")
            fi
        fi

        # Read tmp array for audio codecs and convert in to an html string for the report overview.
        if [ ${#tmp[@]} -gt 0 ]; then
            gCodecID=""
            for (( c=0; c<${#tmp[@]}; c++ ))
            do
                tmpStr="${tmp[$c]##*Codec: }" # Strip added 'Codec: ' string is read from post-processed AudioCodecID.txt file
                tmpCodec="${tmpStr%%[*}";
                tmpIds="[${tmpStr#* [}"
                [[ c -gt 0 ]] && gCodecID="${gCodecID}<br />"
                gCodecID="${gCodecID}"$( printf '%s\n\r' "Audio: ${tmpCodec} <span class=\"text_overview_device\">${tmpIds}</span>" )
            done
        else
            gCodecID="${tmp[@]}"
        fi
        IFS="$oIFS"

        tableState="none"
        echo "S:Report" >> "$gDDTmpFolder"/dd_completed
        # Build the html files.
        "$generateHTMLreport" "$gMasterDumpFolder" "$gtheprog" "$gtheVersion" "$tableState" "$gCodecID" "$gRadio_privacy" "$gDataDir" "$gSic"
        echo "F:Report" >> "$gDDTmpFolder"/dd_completed
    fi

    # Finish up
    if [ $gButton_cancel -eq 0 ]; then
        CloseLog
        ArchiveDumpFolder
        Finish

        # To terminate the UI we write the string "Done" to "$gDDTmpFolder"/dd_completed
        echo "Done" >> "$gDDTmpFolder"/dd_completed
        if [ -f "$gDDTmpFolder"/dd_completed ]; then
            chmod 755 "$gDDTmpFolder"/dd_completed
            chown "${theBoss}":"$theBossGroup" "$gDDTmpFolder"/dd_completed
        fi
        exit 0
    fi
fi
