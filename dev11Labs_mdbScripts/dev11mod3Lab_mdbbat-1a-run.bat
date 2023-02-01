@REM
@REM description: dos-script to run a full mdb test with commandFile
@REM
@REM version:
@REM  MPLABX-v6.05, XC32-v4.21
@REM
@REM usage:
@REM  -) clone dev11gh repo into any path - eg:
@REM      <my_path>\dev11gh
@REM
@REM  -) make sure the following two paths are in your OS-search path:
@REM      <mplabx_install_path>\mplab_platform\bin
@REM      <mplabx_install_path>\gnuBins\GnuWin32\bin
@REM
@REM 
@REM    ->call-syntax: call from '<your_path>\dev11gh'
@REM    (DOS: dev11gh\)> .\dev11Labs_mdbScripts\dev11mod3Lab_mdbbat-1a-run.bat
@REM
@REM History:
@REM   v1.0: first working version (SL, 03.1.23)
@REM

@REM   VARIABLES
@SET scrN=dev11mod3Lab_mdbbat-1a-run.bat
@REM    #-relativ path cloned repository
@SET REPO_P=.
@SET MDBBAT_CMD=mdb.bat
@REM    #-relativ path to mdb-script
@SET MDBBAT_CMDF_P=%REPO_P%\dev11Labs_mdbScripts
@SET MDBBAT_CMDF_N=dev11mod3Lab_mdbbat-1b-cmd.txt
@SET MDBBAT_CMD_F=%MDBBAT_CMDF_P%\%MDBBAT_CMDF_N%


@REM   ######- MAIN -######
@ECHO ######: =======================================================
@ECHO ######(%scrN%): Starting ...

@REM capture starting dir-path, so we can go back
@SET ORIG_P=%cd%
@CD %REPO_P%
@ECHO ######: Starting %scrN% from %cd%
@ECHO _

@REM now start mdb.bat call
@REM cmdLine: <repo>\CICDgh_samd21xplp\> mdb.bat %MDBBAT_CMD_F%
@ECHO _
@ECHO ######: Starting mdb.bat call: -%MDBBAT_CMD% "%MDBBAT_CMD_F%"-
@CALL %MDBBAT_CMD% "%MDBBAT_CMD_F%"


@REM go back to where script started
@ECHO _
@ECHO ####-mdb quit -> stop FW by 'pressing SW0'
@ECHO ======(%scrN%): SUCCESS
@ECHO _
@ECHO ###############################################################
@ECHO ####-PRESS button SW0 to stop execution and jump to endOfTest()
@ECHO _

