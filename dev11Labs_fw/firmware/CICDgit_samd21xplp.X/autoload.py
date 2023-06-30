#-SL: start here <https://confluence.microchip.com/display/DTS/MPLAB+X+debug+extensibility+using+python+scripts>
#-SL:   which refers to a sample-autoload.py here 
#-SL:	https://bitbucket.microchip.com/users/c11609/repos/autoload/browse/autoload.py
#-SL:	16.3.20

#-SL: START
#--python fct to read the hex-file and dump it's content using python-module 'intelhex'
def dump_hex():
    msg.print("\n")    
    msg.print("# START fct 'dump_hex()'...\n")    
    #-SL: MPLABX-searchpath for python-modules
    import sys
     #msg.print("mplabx-py-searchpath1: " + str(sys.path) + "\n")
    sys.path.append("C:\\Python\\v2.7.14\\lib\\site-packages")
     #msg.print("mplabx-py-searchpath2: " + str(sys.path) + "\n")
    from intelhex import IntelHex
    msg.print("  ##### successfully loaded python-module 'intelhex' with autoload.py \n")
    myHex="dist/samd21xplp/production/CICDgit_samd21xplp.X.production.hex"
    msg.print("  ##### reading hexf: " + myHex + "\n")
    ih=IntelHex()
    ih.loadhex(myHex)
    msg.print("  : " + str(hex(ih[0])) + "\n")
    for addr in xrange(16):
        msg.print("  " + str(addr) + ":" + str(hex(ih[addr])))
    msg.print("\n")
    msg.print("  ##### minA:" + str(ih.minaddr()) + " maxA:" + str(ih.maxaddr()))
    msg.print("\n")
    msg.print("# END of 'dump_hex()'...\n")
    msg.print("\n")    
    #-end fct 'dump_hex()'
#-SL: END

# log is an object that makes the MPLAB X logger available to scripts. The logger is setup
# in the IDE via Tools->Options->Embedded->Diagnostic. See documentation at the bottom of this file.

# avoid having the log information be tee'd into the output window
log.setShowOutput(False)
# this message will go to the MPLAB X log with level INFO
log.info("autoload.py example with SL-extentions")

# msg.print(String message) will send the message to the IDE output window. See documentation at the bottom of this file
msg.print("autoload.py example with SL-extentions\n")


# onload is executed when autoload.py is module loaded. 
# ide.addCommand(String nameOfActionToBeShownInProjectView, String nameOfFunctionToBeCalled)
# It provides you with a way to add action icons to the project view. The name of the icon
# will be the nameOfActionToBeShownInProjectViewi and will be placed in the project tree
# at its root. When you double click on the action or right click and select run, the 
# nameOfFunctionToBeCalled will be called. The nameOfActionToBeShownInProjectView can be a string 
# separated by the '|' character. Each sub-string before the last '|' will be used as branches
# of a tree. The example below:
def onload(ide):
  ide.addCommand("Test|msg|Print example", "print_hello")
  ide.addCommand("Test|msg|Pop up example", "pop_up_hello")
  ide.addCommand("Test|log|Log example", "log_example")
  ide.addCommand("Test|log|Log hello", "log_hello")
  ide.addCommand("Test|log|Tee to output window", "tee_to_output_window")
  ide.addCommand("Test|log|Do not Tee to output window", "do_not_tee_to_output_window")
  ide.addCommand("TestMyFcts|dump_hex (EDBG-win)", "dump_hex")
  #ide.addCommand("Test|myCmds|read_elf_file", "read_elf")
  

# will be shown in the project window as a tree: 
#
# Test +
#      + msg
#         + Print example
#         + Pop up example 
#      + log
#         + Log example
#         + Log hello
#         + Tee to output window
#         + Do not Tee to output window

def print_hello():
  msg.print("Hello\n")

def pop_up_hello():
  msg.msg("Hello","Say")

def log_example():
  log.setShowOutput(False)
  log.info("This will go into the MPLAB X logger (if enabled), but not to the output window\n")
  log.error("Logging an error will be also shown on output window regardless of setShownOutput\n")
  log.setShowOutput(True)
  log.info("This will go into the MPLAB X logger (if enabled) and also to the output window\n")

def log_hello():
  log.info("Hello\n")

def tee_to_output_window():
  log.setShowOutput(True)

def do_not_tee_to_output_window():
  log.setShowOutput(False)

# the following functions are called in the order they are shown when a debug session starts

# Before we program the device
def on_pre_program():
  log.info("on_pre_program")

# After the image is programmed
def on_program_done():
  log.info("on_program_done")

# Before resuming execution
def on_pre_run():
  log.info("on_pre-run")

# After execution just halted
def on_halted(pc):
  msg.print("Halted at " + hex(pc) + "\n")
  log.info("on_halted")
  return False
    
# About to stop session before connection to debug tool is terminated
def on_session_ending():
  log.info("on_session_ending")

# About to stop session after the connection to debug tool is terminated
def on_session_ended():
  log.info("on_session_ended")

# There are several objects that can be used by code in this file
#
#                 log
#
#    logging is set for different levels. A level is an int that maps to MPLAB X login levels:
#       int               MPLAB X loging level
#       0                  Level.ALL
#       1                  Level.CONFIG
#       2                  Level.FINE
#       3                  Level.FINER
#       4                  Level.FINEST
#       5                  Level.INFO
#       6                  Level.OFF
#       7                  Level.SEVERE
#       8                  Level.WARNING
#
# log.setShowOutput(True) will tee onto the IDE output window the information that is going to the logger
# log.getShowOutput() returns true if teeing onto the IDE output window
# log.getLogLevelThreshold() will return the current level of logging in the IDE
# log.log(int level, String message)
# log.debug(String message)   will log at level 0
# log.info(String message)    will log at level 5
# log.error(String message)   will log at level 7
# log.warning(String message) will log at level 8
#
#
#                 msg
#
# msg.print(String message) outputs to the IDE output window
# msg.printToTab(String message, String title) will write to a tab with title in the output window.
#
#
#                 mem
#
# mem is an object that gives you access to the internal representation in the IDE of memory.
# For RAM (file registers and peripheral registers [pic32]) MPLAB X contains a buffer that
# caches the values to be written to or read from the device.
# The mem.Read* and mem.Write* functions allow you to manipulate the values in those buffers.
# The mem.ReadHW* and mem.WriteHW* functions will also access the same buffers but will also 
# communicate with the device to change the device memory itself. So, a mem.WriteHW32 will send a
# 32 bit word into the IDE's buffer but will also will write it to the device under test using
# the currently selected debugger (ICD4, etc).
#
#
#    int Read32(MemType type, long address);
#    int ReadHW32(MemType type, long address);
#    void Write32(MemType type, long address, int value);
#    void WriteHW32(MemType type, long address, int value);
#    void WriteBlock(MemType type, long address, int offset, int length, dataarray data);
#    void WriteHWBlock(MemType type, long address, int offset, int length, dataarray data);
#    void ReadBlock(MemType type, long address, int offset, int length, dataarray data);
#    void ReadHWBlock(MemType type, long address, int offset, int length, dataarray data);
#
#
#                 mem.MemType
#
#    FileRegisters(FileRegisters.class),
#    PeripheralMemory(PeripheralMemory.class);
#
#
#
#                 deb
#
# deb is an object that gives you access the debugging session. It allows you to control the state of the debuggin session and to set breakpoints.
#
# MPLAB X controles the debugger state based on the GUI actions. So, you need to be careful your actions do not clash with the IDE. Some things to be careful:
#   1) There is a limited number of hardware breakpoints. If you set via the IDE a breakpoint or if you call deb.SetBP() or deb.SetTempBP() you
#   are using one of the hardware breakpoints available in the pool. This number is small (less than 8). So we highly recommend you use
#   software breakpoints. You can enable this in the IDE (dashboard) or using deb.UseSWBP()
#
#   2) Depending on the device you are using, you might need to initiate a debug session before you can call deb. You can call deb.Connect() but this will not
#   program the device.
#
#
# Let's define ready state when a debug session is in place and we are halted.
#
#    boolean Ready();
#        returns True if in ready state
#    boolean Connected() ;
#        returns True if Connect was successful. The IDE calls internally Connect when for example the user presses the refresh button in the dashboard
#        After connection, depending on the device, the rest of the deb functions will be available.
#        For some devices the ready state needs to be arrived at by starting a debug session.
#    void Connect();
#        does the equivalent of pressing the refresh button in the dashboard
#    void Disconnect();
#        terminates debug session and removes USB connection to debug tool
#    long GetPC();
#        if in the ready state, returns the current program counter
#    boolean IsHalted();
#        returns True if halted, False if running. A debug session must be in place for this function to be called
#    void Run();
#        If in the ready state, start execution of program from current program counter
#    void Halt();
#        if in a debug session and running, halt the program execution and enter the ready state
#    public void StepIn();
#        if in the ready state, step into the next line of source
#    public void StepOverSourceLine();
#        if in the ready state, step over the next line of source. This might cause the debugger to set a breakpoint on the next line behind the scene
#    public void StepOut();
#        if in the ready state, step out of the current C scope
#    public void StepInstr();
#        if in the ready state, execute the opcode at program counter
#    long GetSymbolAddress(String symbol);
#        This function requires that the image for a debug session has been loaded. This happens when you build for debug or when you press the debug-run button
#        Returns the value of the source level symbol
#    int GetSymbolSize(String symbol);
#        This function requires that the image for a debug session has been loaded. This happens when you build for debug or when you press the debug-run button
#        Returns the size the source level symbol
#    boolean UsingSWBP();
#        Returns true if using software breakpoints. 
#    boolean UsingHWBP();
#        Returns true if using hardware breakpoints. 
#    void UseSWBP();
#        Tell the IDE to use software breakpoints. All existing breakpoints will be converted to software breakpoints
#    void UseHWBP();
#        Tell the IDE to use hardware breakpoints. All existing breakpoints will be converted to hardware breakpoints. If the max number of hardware
#        breakpoints is reached, the rest of the breakpoints will be disabled
#    int SetBP(long address, String callback);
#        Returns a handle to this breakpoint. The handle can be used to remove this breakpoint via ClearBP().
#        If a breakpoint is available (if using hardware breakpoints), set a breakpoint at address. If callback is not None, then the function with the name callback will be
#        called when this breakpoint is hit. If the callback function returns False, the debugger will halt and enter the ready state. If
#        callback returns True, the debugger will continue execution as if this breakpoint had not happened.
#        Setting a breakpoint with this function will create a breakpoint that will exist even after the debug session is expired. Calling this
#        function is the equivalent of setting a breakpoint using the IDE.
#    int SetTempBP(long address, String callback);
#        Same as SetBP with this significant difference: The breakpoint will be automatically deleted with the debug session ends
#    void ClearBP(int handle);
#        Takes the handle returned by SetTempBP() or SetBP() and clears that breakpoint.
#    int GetNumMaxHWBP();    
#        Returns the maximum number of hardware breakpoints the device supports
#    PyList GetAddressesFromSourceLine(String fileName, long line);
#        Returns a python list of the addresses that contain code implementing the source line from fileName with line number line.
#        It returns None if no matches are found. The reason this function returns a list is because the compiler may map a single sourceline 
#        into several addresses. This happens when using multiple statements on C line for example:
#                   test();counter++;test2();
#        This also occurs when the compiler emits highly optimized code.
#    void LoadImageFile(String fileName);
#        Load an image (hex/elf) into the MPLAB X memory objects. Note that this does not mean the image will actually be placed into the devices memory