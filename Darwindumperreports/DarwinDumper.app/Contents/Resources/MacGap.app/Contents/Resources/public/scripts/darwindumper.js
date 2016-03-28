// A script to control DarwinDumper's UI and respond to user input.
// Copyright (C) 2013-2015 Blackosx
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ====================================================================
//
// This file controls the communication between the
// DarwinDumper shell script and the user interface.
//
// Built on the macgap project by Alex MacCaw
// https://github.com/maccman/macgap
//
// I've modified the macgap source to print a debug
// message to stdout when the macgap.app.launch
// command is issued. This message is then directed
// to a temporary file which the shell script looks
// for and acts upon.
//
// In return, the shell script prints any messages
// to file that this script looks for and acts upon.
//
// Blackosx - Feb 2013 -> Oct 2015
//
//


// set some initial javascript vars.
var optionsFedBackFromScriptArray="";
var prevSettings="";
var dumpFolder="";
var userRunChoice=0;
var fileToLoad="";
var timerFeedBack = null;
var ownPerm=0;
var userOkay=0;
var saveDirTimerRunning=0;
var invalidPath=" ";
var gDDTmpFolder = "/tmp/DarwinDumper";

//-------------------------------------------------------------------------------------
// On initial load
$(document).ready(function() {
    // set Focus
    SetFocus();

	// Hide info div by id on launch.
	// The help and info pages get loaded in to this.
    $( "#infoWindow" ).hide();

    // Read version number to populate the interface
    getVersion();

    // Start time to check for update file, 5 seconds after launch
    // This will give time for the 'init' script to check.
    timerCheckUpdate = setTimeout(checkForUpdate, 5000);

    // Restore previous state.
    readLastSettings();

    // Set the colour of the archive menu depending on the
    // selected value.
    setColourArchive();

    // Check for any ownership/permission issues with the
    // DarwinDumperReports folder and notify user.
    setUpDialogBoxes();
    timerCheckDumpFolder = setTimeout(checkDumpFolder, 100);
    timerCheckError = setTimeout(checkError, 100);

    // Check whether a symlink is valid.
    // If yes, then a check mark is drawn beside menu item.
    CheckAndSetSymlinkMenuTick();

    // Check whether a custom path has been set.
    // If yes, then a check mark is drawn beside menu item.
    CheckAndSetCustomPathMenuTick();
    
    // Check for csr settings and loaded kexts
    CheckCsrAndLoadedKexts();
});

//-------------------------------------------------------------------------------------
function SetFocus() {
    macgap.app.activate();
}

//-------------------------------------------------------------------------------------
// Called when the process is to close.
function terminate() {
    clearTimeout(timerFeedBack);
    clearTimeout(timerCheckUpdate);
    clearTimeout(timerCheckDumpFolder);
    clearTimeout(timerCheckError);
    macgap.app.launch("death"); // write string to file which should terminate shell script.
    macgap.app.terminate();
}

//-------------------------------------------------------------------------------------
// looks for a file and if found, returns the contents
function GetFileContents(filename)
{
    xmlhttp = new XMLHttpRequest();
    xmlhttp.open("GET",gDDTmpFolder+"/"+filename,false);
    xmlhttp.send(null);
    fileContent = xmlhttp.responseText;

    if (fileContent != "" ) {
        return fileContent;
    } else {
        return 0;
    }
}

//-------------------------------------------------------------------------------------
// Enable all dump option checkboxes.
function EnableAllCheckboxes()
{
    $("#MiddleOptions .dump_option").prop('checked', true);
    $("#topMiddleOptions .dump_option").prop('checked', true);
}

//-------------------------------------------------------------------------------------
$(function()
{
    // Respond to the 'Deselect All' button press.
    $("#DeselectAll").click(function() {
        // UnCheck all dump option checkboxes.
        $("#MiddleOptions .dump_option").prop('checked', false);
        $("#topMiddleOptions .dump_option").prop('checked', false);
        $("#topHeaderBox .groupSelectButtonTop").prop('checked', false);
        $("#middleHeaderBox .groupSelectButtonMiddle").prop('checked', false);
        // Disable the Run button
        disableButton("button3","Run");
    });

    // Respond to the 'Select All' button press.
    $("#SelectAll").click(function() {
        EnableAllCheckboxes();
        $("#topHeaderBox .groupSelectButtonTop").prop('checked', true);
        $("#middleHeaderBox .groupSelectButtonMiddle").prop('checked', true);
        // Enable the Run button
        enableButton("Run","button3");
    });

    // On changing the 'archive' dropdown menu.
    $("#archive").change(function() {
        setColourArchive();
    });

    // On clicking the 'selectTopOptions' checkbox.
    $("#selectTopOptions").click(function() {
        if ($(selectTopOptions).prop('checked')) {
            $("#topMiddleOptions .dump_option").prop('checked', true);
            // Enable the Run button.
            enableButton("Run","button3");
        } else {
            $("#topMiddleOptions .dump_option").prop('checked', false);
            CheckboxRunButtonCheck();
        }
    });

    // On clicking the 'selectMiddleOptions' checkbox.
    $("#selectMiddleOptions").click(function() {
        if ($(selectMiddleOptions).prop('checked')) {
            $("#MiddleOptions .dump_option").prop('checked', true);
            // Enable the Run button.
            enableButton("Run","button3");
        } else {
            $("#MiddleOptions .dump_option").prop('checked', false);
            CheckboxRunButtonCheck();
        }
    });
});

//-------------------------------------------------------------------------------------
// Change colour of the archive drop down menu text
// depending on the selected value.
// Note: these colours match the values used in .css
function setColourArchive()
{
    var temp=$("#archive").val();
    if ( temp=="ArchiveNone" ) {
        $("#archive").css("color","#666");
    } else {
        $("#archive").css("color","#FFF"); // 68CF44
    }
}

//-------------------------------------------------------------------------------------
// Check for file /gDDTmpFolder/dd_user_last_options and read
// contents to set the users' previous settings.
function readLastSettings()
{
    prevSettings=GetFileContents("dd_user_last_options");
    if (prevSettings != 0) {

        prevSettings = prevSettings.split('\n');

        // if array is not blank
        if (prevSettings != "") {

            // step through each element
            for (var i = 0; i < prevSettings.length; i++) {

                if (prevSettings[i] != "ArchiveZip" && prevSettings[i] != "ArchiveLzma" && prevSettings[i] != "ArchiveNone" && prevSettings[i] != "ReportNone" && prevSettings[i] != "ReportNew" && prevSettings[i] != "ReportClassicCollapsed" && prevSettings[i] != "ReportClassic") {
                    // Set each checkbox
                    $("#"+prevSettings[i]).prop('checked', true);
                } else {
                    if (prevSettings[i] == "ArchiveZip" || prevSettings[i] == "ArchiveLzma" || prevSettings[i] == "ArchiveNone") {
                        // Set the archive drop down menu.
                        $('[name=archiveOptions]').val(prevSettings[i]);
                    }
                    // html report - separate the 'none' option
                    if (prevSettings[i] == "ReportNone") {
                        // Set the htmlReport drop down menu.
                        //$('[name=htmlReportOptions]').val("ReportNone");
                        // Set checkbox to unset
                        $("#Report").prop('checked',false);
                    }
                    // html report - process the other options.
                    // There's now just a single html report option, but a user may have
                    // one of the older strings in their preferences file.
                    if (prevSettings[i] == "Report" || prevSettings[i] == "ReportNew" || prevSettings[i] == "ReportClassicCollapsed" || prevSettings[i] == "ReportClassic") {
                        // Set the htmlReport drop down menu.
                        //$('[name=htmlReportOptions]').val("Report");
                        // Set checkbox to set
                        $("#Report").prop('checked',true);
                    }
                }
            }
        }
    }
    else
    { // There is no prefs file.

        // Check all the dump checkboxes.
        EnableAllCheckboxes();

        // Check each group select checkbox
        $("#topHeaderBox .groupSelectButtonTop").prop('checked', true);
        $("#middleHeaderBox .groupSelectButtonMiddle").prop('checked', true);

        // Check the HTML Report
        $("#Report").prop('checked', true);

        // Set the htmlReport drop down menu to Report
        //$('[name=htmlReportOptions]').val("Report");

        // Set the archive drop down menu to .zip
        $('[name=archiveOptions]').val("ArchiveZip");
    }
}

//-------------------------------------------------------------------------------------
function setUpDialogBoxes()
{
    $(function() {
        $( "#dialog-OwnPerm" ).dialog({
            modal: true, width: 370, height: 190, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window },
            buttons: {
                Fix: function() {
                    macgap.app.launch("Fix"); // write string to file to say user chose to fix.
                    //$( this ).dialog( "close" );
                },
                Quit: function() {
                    $( this ).dialog( "close" );
                    macgap.app.launch("user_quit"); // write string to file to say user pressed quit.
                    terminate();
                }
            }
        });
    });

    $(function() {
        $( "#dialogFixing" ).dialog({
            modal: true, width: 370, height: 190, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window }
        });
    });

    $(function() {
        $( "#dialogFixed" ).dialog({
            modal: true, width: 370, height: 190, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window },
            buttons: {
                Okay: function() {
                    $( this ).dialog( "close" );
                    ownPerm=1;
                }
            }
        });
    });

    $(function() {
        $( "#dialogWaitingAuth" ).dialog({
            modal: true, width: 370, height: 190, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window }
        });
    });

    $(function() {
        $( "#dialogWaitingAction" ).dialog({
            modal: true, width: 370, height: 150, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window }
        });
    });

    $(function() {
        $( "#dialogPathNotExist" ).dialog({
            modal: true, width: 370, height: 190, resizable: false, draggable: false, dialogClass: 'no-close', autoOpen: false,
            position: { my: "bottom", at: "center", of: window },
            buttons: {
                Okay: function() {
                    $( this ).dialog( "close" );
                    userOkay=1;
                }
            }
        });
    });
}

//-------------------------------------------------------------------------------------
// Check for file /gDDTmpFolder/dd_dumpfolder which indicates
// the DarwinDumperReports folder is not writeable.
function checkDumpFolder()
{
    fileContent=GetFileContents("dd_dumpfolder");

    if (ownPerm==0) {
        // Is the string 'NoWrite' found in fileContent?
        if (/NoWrite/i.test(fileContent)) {
            // Show dialog box for the user to choose what to do.
            $( "#dialog-OwnPerm" ).dialog( "open" );
        }

        // Is the string 'Fixing' found in fileContent?
        if (/Fixing/i.test(fileContent)) {
            // Show dialog box showing waiting for fix.
            $( "#dialog-OwnPerm" ).dialog( "close" );
            $( "#dialogFixing" ).dialog( "open" );
        }

        // Is the string 'Success' found in fileContent?
        if (/Success/i.test(fileContent)) {
            $( "#dialog-OwnPerm" ).dialog( "close" );
            $( "#dialogFixing" ).dialog( "close" );
            $( "#dialogFixed" ).dialog( "open" );
        }

        timerCheckDumpFolder = setTimeout(checkDumpFolder, 500);
    }
    if(ownPerm==1) {
        $( "#dialog-OwnPerm" ).dialog( "close" );
        $( "#dialogFixing" ).dialog( "close" );
        $( "#dialogFixed" ).dialog( "close" );
        //clearTimeout(timerCheckDumpFolder);
    }
}

//-------------------------------------------------------------------------------------
// Check for file /gDDTmpFolder/dd_error which indicates
// the current save path does not exist.
function checkError()
{
    fileContent=GetFileContents("dd_error");
    //if (fileContent != 0) {

        if (userOkay==0) {
            // Is the string 'path_error' found in fileContent?
            if (/path_error/i.test(fileContent)) {

              // open dialog
              $( "#dialogPathNotExist" ).dialog( "open" );

              // Get and current set path
              var filepath=GetFileContents("dd_reports_filepath");
              filepath=filepath.split('\n');
              filepath=filepath[0];

              // Add current path text inside dialog
              $("#dialogPathNotExist span").html(filepath);
            }
            timerCheckError = setTimeout(checkError, 50);
        }

        if (userOkay==1) {
            $( "#dialogPathNotExist" ).dialog( "close" );

            // reset status bars to idle
            $('*[id^="status"]').attr('class', 'statusBarIdle');

            // enable the select, run and quit buttons
            enableControlButtons();

            // Remember current invalid path
            invalidPath=GetFileContents("dd_reports_filepath");
            invalidPath=invalidPath.split('\n');
            invalidPath=invalidPath[0];

            // set cross beside Custom Path menu option
            SetCustomPathMenuCross();

            // reset flag to 0 incase this error happens again.
            userOkay=0;

            // keep timer running to watch out for this error again.
            timerCheckError = setTimeout(checkError, 200);

            // Display the Save Directory help page
            disableControlButtons();
            loadInfoPageIntoDiv("info_saveDirectory");
        }
   // }
   // else
   // {
        // recursively call function providing we haven't completed.
    //    if(userOkay==0)
    //        timerCheckError = setTimeout(checkError, 100);
    //}
}

//-------------------------------------------------------------------------------------
// Check for file /gDDTmpFolder/dd_auth which indicates
// the script is waiting for user authentication.
function checkUserAuth()
{
    var authCheck=0;
    fileContent=GetFileContents("dd_auth");
    if (fileContent != 0) {

        // Is the string 'Waiting' found in fileContent?
        if (/Waiting/i.test(fileContent)) {
            $( "#dialogWaitingAuth" ).dialog( "open" );
            //alert(fileContent);
        }

        // Is the string 'Done' found in fileContent?
        if (/Done/i.test(fileContent)) {
            $( "#dialogWaitingAuth" ).dialog( "close" );
            //alert(fileContent);

            // stop this timer and set to not re-iterate this function
            clearTimeout(timerCheckAuth);
            authCheck=1;
        }
        // recursively call function providing we haven't completed.
        if(authCheck==0)
            timerCheckAuth = setTimeout(checkUserAuth, 50);
    }
    else
    {
        // recursively call function providing we haven't completed.
        if(authCheck==0)
            timerCheckAuth = setTimeout(checkUserAuth, 50);
    }
}

//-------------------------------------------------------------------------------------
// Check for file /gDDTmpFolder/dd_waiting which indicates
// the script is waiting for user action.
function showWaiting()
{
    var actionCheck=0;
    fileContent=GetFileContents("dd_waiting");
    if (fileContent != 0) {

        // Is the string 'Waiting' found in fileContent?
        if (/Waiting/i.test(fileContent)) {
            $( "#dialogWaitingAction" ).dialog( "open" );
            //alert(fileContent);
        }

        // Is the string 'Done' found in fileContent?
        if (/Done/i.test(fileContent)) {
            $( "#dialogWaitingAction" ).dialog( "close" );
            //alert(fileContent);

            // stop this timer and set to not re-iterate this function
            clearTimeout(timerCheckAction);
            actionCheck=1;
        }
        // recursively call function providing we haven't completed.
        if(actionCheck==0)
            timerCheckAction = setTimeout(showWaiting, 50);
    }
    else
    {
        // recursively call function providing we haven't completed.
        if(actionCheck==0)
            timerCheckAction = setTimeout(showWaiting, 50);
    }
}

//-------------------------------------------------------------------------------------
// The index.html form uses more than one button.
// Work out which one was pressed and respond accordingly.
function formButtonPressed(f,whichButton)
{
    if(whichButton=="run")
    {
        // check to see if an option requiring root privileges was ticked
        if ($(codecid).prop('checked') || $(biosSystem).prop('checked') || $(biosVideo).prop('checked') || $(diskLoaderConfigs).prop('checked') || $(bootLoaderBootSectors).prop('checked') || $(diskPartitionInfo).prop('checked') || $(firmmemmap).prop('checked') || $(kerneldmesg).prop('checked') || $(kexts).prop('checked') || $(lspci).prop('checked')) {
            userRunChoice=1;  // remember choice for later
        } else {
            userRunChoice=0;  // remember choice for later
        }
        processSelections();
    }
    else
    { // the Quit button was pressed.
        macgap.app.launch("user_quit"); // write string to file to say user pressed quit.
        terminate();
    }
}

//-------------------------------------------------------------------------------------
// React to the form submission.
// Find each item that was selected and build
// a string with each title. Then send the final
// string back to the Terminal.
function processSelections()
{
    var string="";
    var tmp="";

    // begin string with user choice of root privileges.
    string=(string+"Root="+userRunChoice);

    // add to string user choice of archive
    string=(string+","+$("#archive").val())
    
    for(i=0; i<document.User_Options.elements.length; i++)
    {
        tmp=document.User_Options.elements[i];
        if(tmp.checked){
            // write a comma to separate the contents.
            string=(string+",")

            // build output string.
            string=(string+tmp.id);

            // Not used - but kept for reference.
            //macgap.growl.notify({title: 'MacGap', content: "Checkbox:"+document.User_Options.elements[i].id});

            // update status bars to show process is waiting to process.
            // skip any non dump options
            if (tmp.id != "collapsetables" && tmp.id != "Public" && tmp.id != "ArchiveNone" && tmp.id != "ReportNone")
                $("#status_"+tmp.id).attr('class', 'statusBarWaiting');
        }
    }
    
    if($("#archive").val()=="ArchiveZip" || $("#archive").val()=="ArchiveLzma")
        $("#status_archive").attr('class', 'statusBarWaiting');

    // Return string back to stdout.
    macgap.app.launch(string);

    if(userRunChoice==1) {
        // Show dialog stating waiting for user authentication
        checkUserAuth();

        // enable the select, run and quit buttons
        //enableControlButtons();
    }

    // Disable all buttons
        disableOptionButtons();
        disableControlButtons();

        // Disable all dump option checkboxes
        $(".dump_option").prop("disabled", true);

        // Disable both top and middle section checkboxes
        $('*[class^="groupSelectButton"]').prop("disabled", true);

        // Disable private checkbox
        $("#privacy").prop("disabled", true);
        
        // Disable html report checkbox
        $("#Report").prop('disabled', true);

        // Disable all 'info' buttons
        $(".button_info").attr("disabled", "disabled");

    // Initiate timer to run every second.
    // for monitoring script feedback.
    timerFeedBack = setTimeout(checkFeedback, 500);
}

//-------------------------------------------------------------------------------------
// Disable user buttons.
// This can be called, for example when checking for Authentication
// as there is a delay between clicking a button and sending message(s)
// back and forth to the script. During this delay it's possible for the
// user to still click another option.
function disableControlButtons()
{
    disableButton("button2","DeselectAll");
    disableButton("button4","SelectAll");
    disableButton("button3","Run");
    disableButton("button1","Quit");
}

//-------------------------------------------------------------------------------------
// Enable user buttons.
function enableControlButtons()
{
    enableButton("DeselectAll","button2");
    enableButton("SelectAll","button4");
    enableButton("Run","button3");
    enableButton("Quit","button1");
}

//-------------------------------------------------------------------------------------
function disableOptionButtons()
{
    disableButton("button_showpage","info_credits");
    disableButton("button_showpage","info_help");
    disableButton("button_showpage","info_symlink");
    disableButton("button_showpage","info_saveDirectory");
}

//-------------------------------------------------------------------------------------
function enableOptionButtons()
{
    enableButton("info_credits","button_showpage");
    enableButton("info_help","button_showpage");
    enableButton("info_symlink","button_showpage");
    enableButton("info_saveDirectory","button_showpage");
}

//-------------------------------------------------------------------------------------
function disableButton(buttonClass,buttonId)
{
    $("."+buttonClass).attr("disabled", "disabled");
    $("#"+buttonId).attr('class', 'ghosted');
}

//-------------------------------------------------------------------------------------
function enableButton(buttonId,buttonClass)
{
    $("#"+buttonId).attr('class',buttonClass);
    $("."+buttonClass).removeAttr("disabled");
}

//-------------------------------------------------------------------------------------
// Check for file gDDTmpFolder/dd_completed and read
// contents to indicate completed processes.
// If the string "Done" is read then we can terminate.
function checkFeedback()
{
    dumpFolder=GetFileContents("dd_completed");
    if (dumpFolder != 0) {

        optionsFedBackFromScriptArray = dumpFolder.split('\n');
        var completed=0;

        // if array is not blank
        if (optionsFedBackFromScriptArray != "") {

            // step through each element
            for (var i = 0; i < optionsFedBackFromScriptArray.length; i++) {

                // Check for progress bar updates.
                if (optionsFedBackFromScriptArray[i] != "done") {

                   if (optionsFedBackFromScriptArray[i].substring(0, 2) == "S:")
                       $("#status_"+optionsFedBackFromScriptArray[i].substring(2)).attr('class', 'statusBarRunning');

                   if (optionsFedBackFromScriptArray[i].substring(0, 2) == "F:")
                       $("#status_"+optionsFedBackFromScriptArray[i].substring(2)).attr('class', 'statusBarComplete');

                   if (optionsFedBackFromScriptArray[i] == "X") {
                       // User cancelled entering admin password for running dumps as root.

                       // reset status bars to idle
                       $('*[id^="status"]').attr('class', 'statusBarIdle');

                       // Re-Instate buttons (as we disabled them when the user clicked the Run button)
                       // Enable all buttons
                       enableOptionButtons();
                       enableControlButtons();

                       // Enable all dump option checkboxes
                       $(".dump_option").prop("disabled", false);

                       // Enable both top and middle section checkboxes
                       $('*[class^="groupSelectButton"]').prop("disabled", false);

                       // Enable private checkbox
                       $("#privacy").prop("disabled", false);
                       
                       // Enable html report checkbox
                       $("#Report").prop("disabled", false);

                       // Enable drop-down menus
                       $("#archive").prop("disabled", false);

                       // Enable all 'info' buttons
                       $(".button_info").removeAttr("disabled");

                       // stop this timer and set to not re-iterate this function
                       clearTimeout(checkFeedback);
                       completed=1

                       // notify init script that status bars have been reset to idle
                       macgap.app.launch("idle");

                       // break from this loop.
                       break;
                   }
                }

                // break if we read "Done"
                if (optionsFedBackFromScriptArray[i] == "Done") {
                    completed=1;
                    terminate();
                }
            }
            // recursively call function providing we haven't completed.
            if(completed==0)
                timerFeedBack = setTimeout(checkFeedback, 500);
        }
        // recursively call function providing we haven't completed.
        if(completed==0)
            timerFeedBack = setTimeout(checkFeedback, 500);
    }
    else
    {
        // recursively call function providing we haven't completed.
        timerFeedBack = setTimeout(checkFeedback, 500);
    }
}

//-------------------------------------------------------------------------------------
// Read DarwinDumper version to print in the window.
function getVersion()
{
    fileContent=GetFileContents("dd_version");
    if (fileContent != 0) {

        if ( fileContent != "" )
	        $("#leftSideVersionBox").append("v"+fileContent);
	}
}

//-------------------------------------------------------------------------------------
// Read DarwinDumper update to print in the window.
function checkForUpdate()
{
    fileContent=GetFileContents("dd_update");
    if (fileContent != 0) {

        if ( fileContent != "" )
	        $("#leftSideUpdateBox").append('<a href="https://bitbucket.org/blackosx/darwindumper/downloads/DarwinDumper_v'+fileContent+'.zip" target="_blank">v'+fileContent+' available</a>');
    }
}

//-------------------------------------------------------------------------------------
$(function()
{    
    // Respond to the main window info buttons when clicked.
    $(".button_info").click(function() {

        // disable the select, run and quit buttons
        disableControlButtons();

        // load respective page in to jquery window.
        loadInfoPageIntoDiv(this.id);
    });

    // Respond to the credits, info, symlink and custom path menu buttons when clicked.
    $(".button_showpage").click(function() {

        // disable the select, run and quit buttons
        disableControlButtons();

        // load respective page in to jquery window.
        loadInfoPageIntoDiv(this.id);

        if(this.id=="info_symlink"){
            // Run a timer to check for feedback from init script.
            timerSymLink = setTimeout(getSymlinkStatus, 250);
        }

        if(this.id=="info_saveDirectory"){
            // Run a timer to check for feedback from init script.
            timerSaveDir = setTimeout(getSaveDirStatus, 250);
            saveDirTimerRunning=1;
        }
    });

    // Hide the div by id on click of button.
    $( "#infoWindowCloseButton" ).click(function() {
        $( "#infoWindow" ).hide( "slide", { direction: "up" }, 200);

        if (saveDirTimerRunning==1) {
            // Stop the save dir refresh timer
            clearTimeout(timerSaveDir);
            saveDirTimerRunning=0;
        }

        // enable the select, run and quit buttons
        enableControlButtons();

        // If the user chose to run but the path was missing then the
        // options buttons will also be disabled. May as well enable
        // those too, even if they are not disabled.
        enableOptionButtons();

        CheckboxRunButtonCheck();
        return false;
    });

    // Respond to a .dump_option checkbox being clicked
    $(".dump_option").click(function() {
        CheckboxRunButtonCheck();
    });
    
    // Respond to a main window warning triangle being clicked.
    $(".warning_triangle_info").click(function() {

        // disable the select, run and quit buttons
        disableControlButtons();

        // load respective page in to jquery window.
        loadInfoPageIntoDiv(this.id);
    });
});

//-------------------------------------------------------------------------------------
function CheckboxRunButtonCheck()
{
    // Check if at least one dump option is selected, otherwise disable the Run button.
    if ($(codecid).prop('checked') || $(biosSystem).prop('checked') || $(biosVideo).prop('checked') || $(diskLoaderConfigs).prop('checked') || $(bootLoaderBootSectors).prop('checked') || $(diskPartitionInfo).prop('checked') || $(firmmemmap).prop('checked') || $(kerneldmesg).prop('checked') || $(kexts).prop('checked') || $(lspci).prop('checked') || $(acpi).prop('checked') || $(asl).prop('checked') || $(cpuinfo).prop('checked') || $(devprop).prop('checked') || $(dmi).prop('checked') || $(edid).prop('checked') || $(bootlog).prop('checked') || $(ioreg).prop('checked') || $(kernelinfo).prop('checked') || $(nvram).prop('checked') || $(opencl).prop('checked') || $(rcscripts).prop('checked') || $(rtc).prop('checked') || $(sip).prop('checked') || $(smc).prop('checked') || $(sysprof).prop('checked')) {
       enableButton("Run","button3");
    } else {
        disableButton("button3","Run");
    }
}

//-------------------------------------------------------------------------------------
function loadInfoPageIntoDiv(idToLoad)
{
    // load respective page in to jquery window.
    fileToLoad=("info_pages/"+idToLoad+'.htm');
    $('#infoFileContents').load(fileToLoad,function(responseTxt,statusTxt,xhr){
        if(statusTxt=="success")
            $( "#infoWindow" ).show( "slide", { direction: "up" }, 200);
        if(statusTxt=="error")
            alert("Error: "+xhr.status+": "+xhr.statusText);
    });
}

//-------------------------------------------------------------------------------------
function updateSymlinkStatus(statusMessage,buttonText)
{
    // Set text of table cell contents to feedback status
    $("#table_symlink_status td").eq(1).html(statusMessage);
    // Set button text
    $("#table_symlink_status #symlink_page_button").val(buttonText);
    // Stop the timer
    clearTimeout(timerSymLink);
    SetFocus();
}

//-------------------------------------------------------------------------------------
// Read DarwinDumper symlink status from gDDTmpFolder/dd_symlink
// Then set the table cell and button text accordingly.
// This function is repeated using a timer, until stopped.
function getSymlinkStatus()
{
    fileContent=GetFileContents("dd_symlink");
    if (fileContent != 0) {

        // Remove new line at the end of the string.
        fileContentNoNewline = fileContent.split('\n');

        // Parse string
        if ( fileContentNoNewline[0] == "Create") {
	        updateSymlinkStatus("Not Installed","Create Symlink")
    	} else if ( fileContentNoNewline[0] == "Update") {
    	    updateSymlinkStatus("Exists but needs updating","Update Symlink")
	    } else if ( fileContentNoNewline[0] == "Okay") {
	        updateSymlinkStatus("Correctly Installed","Delete Symlink")
	    }
	    CheckAndSetSymlinkMenuTick();
	}
	else
	{
	    $("#table_symlink_status td").eq(1).html("Unable to determine.");
	    // call this again
        timerSymLink = setTimeout(getSymlinkStatus, 1000);
	}
}

//-------------------------------------------------------------------------------------
function updateSaveDirStatus(saveFilePath)
{
    // Set text of text field to path
    $("input[name='saveDirectory']").val(saveFilePath);
    SetFocus();
}

//-------------------------------------------------------------------------------------
// Read DarwinDumper save directory status from gDDTmpFolder/dd_reports_filepath
// then populate the table text field.
// This function is repeated using a timer, until stopped.
function getSaveDirStatus()
{
    fileContent=GetFileContents("dd_reports_filepath");
    if (fileContent != 0) {

        // Remove new line at the end of the string.
        fileContentNoNewline = fileContent.split('\n');

        // Read current path
        currentPath=$("input[name='saveDirectory']").val();

        // if path read is different from current printed path then update
        if (fileContentNoNewline[0] != currentPath) {

            // Print the string
	        updateSaveDirStatus(fileContentNoNewline[0]);

	        // Does a tick mark need drawing beside the Custom Path menu option?
	        CheckAndSetCustomPathMenuTick();
	    }

        if (saveDirTimerRunning==1) {
            // Recursively call this again every second to update text field.
            timerSaveDir = setTimeout(getSaveDirStatus, 1000);
        }

	}
}

//-------------------------------------------------------------------------------------
// Called from info_symlink.htm (the symlink slider info page).
function symlinkPageButtonPressed(text)
{
    // Send message back to 'init' script.
    macgap.app.launch("Symlink:"+text);

    // Show dialog stating waiting for user authentication
    checkUserAuth();

    // init script should now respond. Initiate timer to read response.
	timerSymLink = setTimeout(getSymlinkStatus, 1000);
}

//-------------------------------------------------------------------------------------
// Called from info_saveDirectory.htm (the save Directory slider info page).
// This corresponds to the 'Browse' button being clicked.
function saveDirectoryPageBrowseButtonPressed()
{
    // Send message back to 'init' script.
    macgap.app.launch("saveDirectory");

    // Show dialog stating waiting for user action.
    showWaiting();

    // init script should now respond. Initiate timer to read response.
	timerSaveDir = setTimeout(getSaveDirStatus, 1000);
	saveDirTimerRunning=1;
}

//-------------------------------------------------------------------------------------
// Called from info_saveDirectory.htm (the save Directory slider info page).
// This corresponds to the 'Reset' button being clicked.
function saveDirectoryPageClearButtonPressed()
{
    // Send message back to 'init' script.
    macgap.app.launch("clearSaveDirectory");

    // Clear path in the info_saveDirectory.htm (the save Directory slider info page).
    updateSaveDirStatus("");

    // init script should now respond. Initiate timer to read response.
	timerSaveDir = setTimeout(getSaveDirStatus, 1000);

    // Does a check mark need drawing beside the Custom Path menu option?
    // Wait 1 second for file system to update then check.
	setTimeout(function() {CheckAndSetCustomPathMenuTick();} , 1000);
}

//-------------------------------------------------------------------------------------
// Called from info_saveDirectory.htm (the save Directory slider info page).
// This corresponds to the 'Open' button being clicked.
function saveDirectoryPageOpenButtonPressed()
{
    // Send message back to 'init' script.
    macgap.app.launch("openSaveDirectory");
}

//-------------------------------------------------------------------------------------
// Read two files, each containing a file path.
// Compare them and if different, set a tick mark beside
// the 'Custom Path' menu option.
function CheckAndSetCustomPathMenuTick()
{
    userPath=GetFileContents("dd_reports_filepath");
    appPath=GetFileContents("dd_app_root_path");
    if (userPath != 0 && appPath != 0) {

        // Remove new line at the end of the strings.
        userPath = userPath.split('\n');
        appPath = appPath.split('\n');

        // Check path is not currently marked as invalid
        if (userPath[0] != invalidPath) {

            // Compare paths and set menu text with check mark if appropriate.
            // If the colour is currently red, then change to white
            if (userPath[0] != appPath[0] && userPath[0] != appPath[0]+"/DarwinDumperReports") {
                $("input#info_saveDirectory").val("Save Path (Custom) \u2713");

                // Flash to alert attention to user
                $("input#info_saveDirectory").addClass("blink_me");
            }
            else
            {
                $("input#info_saveDirectory").val("Save Path (Default)");
            }
            invalidPath="";
        }
	}
}

//-------------------------------------------------------------------------------------
// Set a red cross mark beside the 'Custom Path' menu option.
function SetCustomPathMenuCross()
{
    $("input#info_saveDirectory").val("Custom Path \u2715");
    //var colb = $("#info_saveDirectory").css("color");
    //if ( colb == "rgb(255, 255, 255)" ) {
    //    //alert("B: read WHITE");
    //    $("#info_saveDirectory").css("color","#FF0000");
    //}
}

//-------------------------------------------------------------------------------------
// Set checkmark against symlink menu item if valid symlink exists.
function CheckAndSetSymlinkMenuTick()
{
    fileContent=GetFileContents("dd_symlink");
    if (fileContent != 0) {

      // Remove new line at the end of the string.
      fileContentNoNewline = fileContent.split('\n');

      // Parse string
      if ( fileContentNoNewline[0] == "Create") {
        // Set symlink menu text without check mark.
          $(".menu #info_symlink").val("Symlink");
          $(".menu #info_symlink").css('color', '#FF0033'); // red
    } else if ( fileContentNoNewline[0] == "Update") {
        // Set symlink menu text without check mark.
          $(".menu #info_symlink").val("Symlink");
          $(".menu #info_symlink").css('color', '#FFCC33');  // orange
    } else if ( fileContentNoNewline[0] == "Okay") {
        // Set symlink menu text with check mark.
          $(".menu #info_symlink").val("Symlink \u2713");
          $(".menu #info_symlink").css('color', '#33CC33'); // green
    }
	}
}

//-------------------------------------------------------------------------------------
// Read two files, each containing state of system
function CheckCsrAndLoadedKexts()
{
    csrSettings=GetFileContents("dd_csr");
    loadedKexts=GetFileContents("dd_loadedKexts");
    if (csrSettings != 0 && loadedKexts != 0) {

        // Remove new line at the end of the strings.
        csrSettings = csrSettings.split(',');
        loadedKexts = loadedKexts.split(',');

        // Check csr settings
        // File will contain something like: 0,1,1,1,1,1,1,1
        // These values refer to each gCSR_ALLOW_DEVICE_CONFIGURATION,CSR_ALLOW_UNRESTRICTED_NVRAM,CSR_ALLOW_UNRESTRICTED_DTRACE,CSR_ALLOW_APPLE_INTERNAL,CSR_ALLOW_KERNEL_DEBUGGER,CSR_ALLOW_TASK_FOR_PID,CSR_ALLOW_UNRESTRICTED_FS,CSR_ALLOW_UNTRUSTED_KEXTS
        // 0 means item is disabled. 1 means enabled.
        CSR_ALLOW_UNTRUSTED_KEXTS=csrSettings[7];
        CSR_ALLOW_UNRESTRICTED_FS=csrSettings[6];
        CSR_ALLOW_TASK_FOR_PID=csrSettings[5];
        CSR_ALLOW_KERNEL_DEBUGGER=csrSettings[4];
        CSR_ALLOW_APPLE_INTERNAL=csrSettings[3];
        CSR_ALLOW_UNRESTRICTED_DTRACE=csrSettings[2];
        CSR_ALLOW_UNRESTRICTED_NVRAM=csrSettings[1];
        CSR_ALLOW_DEVICE_CONFIGURATION=csrSettings[0];

        // Check Kext loaded settings
        // File will contain something like: 1,1,1,1
        // These values refer to each DirectHW.kext,pmem.kext,RadeonPCI.kext,VoodooHDA.kext
        // 0 means kext is not loaded in current system
        loadedKextD=loadedKexts[0];
        loadedKextP=loadedKexts[1];
        loadedKextR=loadedKexts[2];
        loadedKextV=loadedKexts[3];

        // Show relevant warning triangles
        if (CSR_ALLOW_UNTRUSTED_KEXTS == 0 && loadedKextD == 0) {
            $("#warn_biosSystem").attr('class', 'warning_triangle_info');
            $("#warn_lspci").attr('class', 'warning_triangle_info');
        }
        if (CSR_ALLOW_UNTRUSTED_KEXTS == 0 && loadedKextR == 0) {
            $("#warn_biosVideo").attr('class', 'warning_triangle_info');
        }
        if (CSR_ALLOW_UNTRUSTED_KEXTS == 0 && loadedKextV == 0) {
            $("#warn_codecid").attr('class', 'warning_triangle_info');
        }
        if (CSR_ALLOW_UNRESTRICTED_DTRACE == 0) {
            $("#warn_firmmemmap").attr('class', 'warning_triangle_info');
        }
	}
}
