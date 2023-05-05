@REM SET x+
@ECHO off
@REM Description: ...
@REM
@REM Call-syntax:
@REM    (DOS: mu_dev11_mdbcore)> .\dev11Labs_mdbScripts\dev11mod4Lab_mdbcs-run.bat
@REM 
@REM History:
@REM   v1.0: first working version (SL, 07.02.23)
@REM

@REM relativ path from 'mu_dev11_mdbcore\' directory
@SET REPO_REL_P=.
@SET PRJ_DIR_N=dev11Labs_fw
@SET PRJ_DIR_P=%REPO_REL_P%\%PRJ_DIR_N%\firmware\CICDgit_samd21xplp.X
@SET SCR_DIR_N=dev11Labs_mdbScripts
@SET SCR_DIR_P=.\%SCR_DIR_N%
@REM relativ path from %PRJ_DIR_P% directory
@SET SCR_DIR_REL_P=..\..\..\%SCR_DIR_N%

@REM environment setup
@SET SETUP_ENV_SCR_P=%SCR_DIR_REL_P%
@SET SETUP_ENV_SCR_N=dev11mod4Lab_mdbcs-1Setup_env.bat
@SET SETUP_ENV_SCR=%SETUP_ENV_SCR_P%\%SETUP_ENV_SCR_N%
@REM java setup
@SET SETUP_JAVA_SCR_P=%SCR_DIR_REL_P%
@SET SETUP_JAVA_SCR_N=dev11mod4Lab_mdbcs-2Classpath.bat
@SET SETUP_JAVA_SCR=%SETUP_JAVA_SCR_P%\%SETUP_JAVA_SCR_N%
@REM expect that 'groovysh' is in your OS-searchpath
@SET GROOVY_C=groovy
@SET SCR_N=dev11mod4Lab_mdbcs-run.bat
@REM  relativ path from %REPO_REL_P% directory
@SET GROOVY_SCR_P=%SCR_DIR_REL_P%
@SET GROOVY_SCR_N=dev11mod4Lab_mdbcs-scr.groovy
@SET GROOVY_SCR=%GROOVY_SCR_P%\\%GROOVY_SCR_N%
@REM relative path from prj.X + name of elf-to-use -> this script does not compile BUT just checks elf available
@SET ELF_2_USE_P=dist\samd21xplp\production
@SET ELF_2_USE_N=CICDgit_samd21xplp.X.production.elf
@SET ELF_2_USE_F=%ELF_2_USE_P%\%ELF_2_USE_N%


@REM   ######- MAIN -######
@ECHO _
@ECHO ######: ==================================================================
@REM capture starting dir-path, so we can go back
@SET ORIG_P=%cd%
@CD %PRJ_DIR_P%
@ECHO ######(%SCR_N%): Starting from %cd% 
@ECHO ######                              %GROOVY_C% %GROOVY_SCR% 
@ECHO _

@REM setup env, OS-path
@ECHO _
@ECHO ######: ==================================================================
@ECHO ######: setting up OS-path...
@CALL %SETUP_ENV_SCR%
@IF %ERRORLEVEL% EQU 1 (
    @ECHO    %SETUP_ENV_SCR% caused errors
    @CD %ORIG_P%
    @GOTO SCR_ERROR
) ELSE (
    @ECHO    %SETUP_ENV_SCR% run ok
)

@REM setup java-env, CLASSPATH
@ECHO _
@ECHO ######: ==================================================================
@ECHO ######: setting up Java-path...
CALL %SETUP_JAVA_SCR%
@IF %ERRORLEVEL% EQU 1 (
    @ECHO    %SETUP_JAVA_SCR% caused errors
    @CD %ORIG_P%
    @GOTO SCR_ERROR
) ELSE (
    @ECHO    %SETUP_JAVA_SCR% run ok
)

@REM check if elf-2-use is available -> otherwise must compile first
@ECHO _
@ECHO ######: ==================================================================
@ECHO ######: checking if elf-2-use is available...
@IF NOT EXIST "%ELF_2_USE_F%" (
    @ECHO ############- from %cd% elf2use %ELF_2_USE_F% does NOT exist -^> compile first -^> exit
    @CD %ORIG_P%
    @GOTO SCR_ERROR
) ELSE (
    @ECHO ############- from %cd% elf2use %ELF_2_USE_F% does exist -^> continue
)

@REM @ECHO ###############SL1
@REM @GOTO END


@REM now start groovy-script with mdbcs
@REM cmdLine: (<path>\mu_dev11_mdbcore\)> groovy ".\\dev11Labs_mdbScripts\\dev11mod4Lab_mdbcs-scr.groovy"
@ECHO _
@ECHO ######: Starting mdbcs.groovy from %cd%: 
@ECHO ######:                               %GROOVY_C% "%GROOVY_SCR%"
@CALL %GROOVY_C% "%GROOVY_SCR%"

@REM go back to where script started
@ECHO _
@ECHO ======(%SCR_N%): SUCCESS
@GOTO END

:SCR_ERROR
  @CD %ORIG_P%
  @ECHO ######(%SCR_N%): FAILURE

:END
  @CD %ORIG_P%
  @ECHO ######(%SCR_N%): DONE
  @ECHO on