

call \$fsdbDumpvars 0 harness

if {[info exists env(ASSERT_SWITCH)] && $env(ASSERT_SWITCH) == "on"} {
    call \$fsdbDumpSVA 0 harness
}

if {[info exists env(MEM_SWITCH)] && $env(MEM_SWITCH)== "on"} {
    call \$fsdbDumpMDA 0 harness
}

if {[info exists env(gui)] && ($env(gui) == "dve" || $env(gui) == "on")} {
} else {
    run
}

