
VAR

  long  cog                           ' This is in hub ram

PUB start(pin) : okay

pinmask := |<pin                     ' This can be done because pinmask(cog ram) is filled before the data is loaded into
                                     ' the cog, notice pinmask is declared a long not a res.  After the cog is loaded
                                     ' the value cannot be modified in this way.

' Now to start the cog, notice the @entry, look at the assembly, you can see where it will begin

okay := cog := cognew(@entry, 0) + 1


PUB stop

'' Stop flashing - frees a cog

  if cog
    cogstop(cog~ -  1)


DAT
                      org                           ' Sets the origin at zero for this point
entry
                      or      DIRA,pinmask          ' Sets relevant pin to an output
                      or      OUTA,pinmask          ' Make pin high
                      mov     time,CNT              ' Current clock loaded into time
                      add     time,on_time          ' on_time added to time

:loop                 waitcnt time,off_time         ' waits for time to pass, off_time added to time automatically
                      xor     OUTA,pinmask          ' toggles pin
                      waitcnt time,on_time          ' waits for time to pass, on_time added to time automatically
                      xor     OUTA,pinmask          ' toggles pin
                      jmp     #:loop                ' loop, the # means that :loop is a literal (something typed into program
                                                    ' rather than a register).

                       ' These variables are in cog ram!

' Initialized data

on_time              long    80_000*500             ' on time in clock cycles, 500 * 80000 (cycles per millisecond)
off_time             long    80_000*500             ' off time, also 500 milliseconds
pinmask              long    0                      ' pinmask can be changed when the program is in HUB RAM

'**** ATTENTION, all res variables MUST come after other variables ************

' Uninitialized data

time                 res     1                      ' res is used only to create the label, so no code or other variables
                                                    ' except more res can be placed here, because no real space is used
