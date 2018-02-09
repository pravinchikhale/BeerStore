:: Copyright 2001, 2016, Oracle and/or its affiliates. All rights reserved.
:: Oracle and Java are registered trademarks of Oracle and/or its
:: affiliates. Other names may be trademarks of their respective owners.
:: UNIX is a registered trademark of The Open Group.
::
:: This software and related documentation are provided under a license
:: agreement containing restrictions on use and disclosure and are
:: protected by intellectual property laws. Except as expressly permitted
:: in your license agreement or allowed by law, you may not use, copy,
:: reproduce, translate, broadcast, modify, license, transmit, distribute,
:: exhibit, perform, publish, or display any part, in any form, or by any
:: means. Reverse engineering, disassembly, or decompilation of this
:: software, unless required by law for interoperability, is prohibited.
:: The information contained herein is subject to change without notice
:: and is not warranted to be error-free. If you find any errors, please
:: report them to us in writing.
:: U.S. GOVERNMENT END USERS: Oracle programs, including any operating
:: system, integrated software, any programs installed on the hardware,
:: and/or documentation, delivered to U.S. Government end users are
:: "commercial computer software" pursuant to the applicable Federal
:: Acquisition Regulation and agency-specific supplemental regulations.
:: As such, use, duplication, disclosure, modification, and adaptation
:: of the programs, including any operating system, integrated software,
:: any programs installed on the hardware, and/or documentation, shall be
:: subject to license terms and license restrictions applicable to the
:: programs. No other rights are granted to the U.S. Government.
:: This software or hardware is developed for general use in a variety
:: of information management applications. It is not developed or
:: intended for use in any inherently dangerous applications, including
:: applications that may create a risk of personal injury. If you use
:: this software or hardware in dangerous applications, then you shall
:: be responsible to take all appropriate fail-safe, backup, redundancy,
:: and other measures to ensure its safe use. Oracle Corporation and its
:: affiliates disclaim any liability for any damages caused by use of this
:: software or hardware in dangerous applications.
:: This software or hardware and documentation may provide access to or
:: information on content, products, and services from third parties.
:: Oracle Corporation and its affiliates are not responsible for and
:: expressly disclaim all warranties of any kind with respect to
:: third-party content, products, and services. Oracle Corporation and
:: its affiliates will not be responsible for any loss, costs, or damages
:: incurred due to your access to or use of third-party content, products,
:: or services.

@ECHO OFF
SETLOCAL

REM A wrapper for generating usage reports.

SET EAC_APP_DIR=%~dp0..

REM *******************************************************
REM Locating commons-io jar file
for %%f in (%EAC_APP_DIR%\config\lib\java\commons-io-*.jar) do (
    SET COMMONS_IO_JAR="%%~f"
)

REM Checking if commons-io jar was found
IF "%COMMONS_IO_JAR%"=="" (
    ECHO ERROR: Could not find commons-io jar file under %EAC_APP_DIR%\config\lib\java\
    GOTO :FAILURE
)

REM *******************************************************
REM Locating usageCollection jar file
for %%f in (%EAC_APP_DIR%\config\lib\java\usageCollection-*.jar) do (
    SET USAGE_COLLECTION_JAR="%%~f"
)

REM Checking if usageCollection jar was found
IF "%USAGE_COLLECTION_JAR%"=="" (
    ECHO ERROR: Could not find usageCollection jar file under %EAC_APP_DIR%\config\lib\java\
    GOTO :FAILURE
)

REM *******************************************************
REM Determine location of java.exe

REM Checking if ENDECA_ROOT is specified
IF DEFINED ENDECA_ROOT (
    IF EXIST %ENDECA_ROOT%\j2sdk\bin\java.exe (
        SET JAVA=%ENDECA_ROOT%\j2sdk\bin\java.exe
    ) ELSE (
        ECHO WARNING: %ENDECA_ROOT%\j2sdk\bin\java.exe does not exist
    )
) ELSE (
    ECHO WARNING: ENDECA_ROOT is not set.
)

IF "%JAVA%"=="" (
    IF NOT "%JAVA_HOME%"=="" (
        ECHO WARNING: Using java in "%JAVA_HOME%\bin\java.exe"
        SET JAVA="%JAVA_HOME%\bin\java.exe"
    ) ELSE (
        ECHO WARNING: Using java in your PATH
        SET JAVA=java
    )
)

SET JAVA_ARGS="-Djava.util.logging.config.file=%EAC_APP_DIR%\config\script\logging.properties"

REM *******************************************************
REM Generate usage reports
SET CLASSPATH=%COMMONS_IO_JAR%;%USAGE_COLLECTION_JAR%;%EAC_TOOLKIT_JAR%

SET REPORT_ARGS=--app-dir %EAC_APP_DIR%

%JAVA% -cp %CLASSPATH% com.endeca.usage.reporting.UsageReporter %REPORT_ARGS% %*

IF NOT %ERRORLEVEL%==0 GOTO :FAILURE
ENDLOCAL
exit /b 0

:FAILURE
ENDLOCAL
exit /b 1