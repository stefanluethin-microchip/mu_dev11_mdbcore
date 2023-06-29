@ECHO off
@REM Description: this script sets up the environment to use 'mdbcs' with 'groovy'  
@REM              Basically it uses some environment-variables you must adjust to your 
@REM               (->see below section 'user-Variables:') and then extends the
@REM               OS-searchpath.
@REM              As the global searchpath %Path% is extended without checking if
@REM               one of the items is already defined with an older version maybe,
@REM               the Path would be extended over and over again, if you call this
@REM               script multiple times (w/ changes). 
@REM               ->to prevent this problem, the script copies the orig %Path% first
@REM                 into a new variable %BASEPATH% and to check if it ran before
@REM                 it first checks if %BASEPATH% exists and if not then asks the user
@REM                 once to manually set it - could be automatize, but this is the simple 
@REM                 way. So basically if %BASEPATH% is not yet set, then you must manually
@REM                 set it, to continue and setup your env and finally extend the 
@REM                 global %Path% only once
@REM History:
@REM   v1.1: adapt to v6.00 and improved comment (SL, 5.5.2022)
@REM   v1.0: first version (SL, 12.5.21)
@
@REM user-Variables: to be adjusted for user-environment
@REM   Important notice: DOS-shell does NOT allow spaces/tab
@REM        around the '=' when defining env-variables !!!
@SET MPLABX_V=v6.05
@SET JAVA_VERS=zulu8.64.0.19-ca-fx-jre8.0.345-win_x64
@SET MPLABX_HOME=C:\Program Files\Microchip\MPLABX\%MPLABX_V%
@SET JAVA_HOME=%MPLABX_HOME%\sys\java\%JAVA_VERS%
@SET GNU_HOME=%MPLABX_HOME%\gnuBins\GnuWin32
REM old 32bit groovy 
REM @SET GROOVY_HOME=C:\Program Files (x86)\Groovy\Groovy-2.5.8
REM  !! need to have JAVA_HOME point to MPLABX-java BEFORE you install Groovy 
REM		otherwise you'll get the following stupid error when trying to run groovy:
REM   groovy --version
REM   error: dynamic library C:\Program Files\Microchip\MPLABX\v6.05\sys\java\zulu8.64.0.19-ca-fx-jre8.0.345-win_x64\bin\server\jvm.dll exists but could not be loaded!
REM   This may be caused e.g. by trying to use a 32-bit executable to load a 64-bit jvm (or vice versa)
REM   error (win code 193): (null)
REM   error: could not find client or server jvm under C:\Program Files\Microchip\MPLABX\v6.05\sys\java\zulu8.64.0.19-ca-fx-jre8.0.345-win_x64
REM       please check that it is a valid jdk / jre containing the desired type of jvm
REM  -> better to use the new 64bit-version of Groovy below
@SET GROOVY_HOME=C:\Program Files\Groovy\groovy-4.0.12
@SET PYTHON2_HOME=C:\Program Files\Python\v2.7.18

 REM fix Variable
@SET scrN=dev11mod4Lab_mdbcs-1Setup_env.bat


@ECHO %scrN% Starting ...

@REM check if environment-variable BASEPATH path is set 
@REM  -> break if not and continue if set
@REM Reason: below the searchpath PATH is extended and
@REM          without this trick the PATH would grow every time
@REM          you run this script. So force user just to keep
@REM          the basic PATH with this check
@IF "%BASEPATH%"=="" (
    @ECHO    ###: for simplicity you must copy the current OS-searchpath into BASEPATH with:
    @ECHO    ###:        set BASEPATH=^%%PATH%%
    @ECHO    ###: and run this script again
    GOTO SCR_ERROR
) ELSE (
    @ECHO    ##: BASEPATH set -^> continue
)

REM BASEPATH set manually - see check above
REM GROOVY_PATH must be before JAVA_PATH, so put first in 
REM     search-path to prevent various issues
@ECHO    ##: extending OS-searchpath
@SET PATH=%GROOVY_HOME%\bin;%JAVA_HOME%\bin;%GNU_HOME%\bin;%PYTHON2_HOME%;%BASEPATH%
@SET ERRORLEVEL=0
@GOTO END

:SCR_ERROR
  @ECHO .
  @ECHO XXXXXXXXXXXX(%scrN%):   error BASEPATH not set
  @SET ERRORLEVEL=1
  
:END
  @ECHO %scrN%: END (errorlevel: %ERRORLEVEL%)
