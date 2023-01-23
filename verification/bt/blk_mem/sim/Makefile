
.PHONY:cmp batch_run ncrun run ${UVM_TEST_SIMV} 

ifneq ($(wildcard ../cfg/cfg.mk),)
    include ../cfg/cfg.mk
endif

export mode := base_fun
export udl := -f ../cfg/tb.f
export udc := 
export udr :=
export wave :=
export gui := off
export seed := 10000
export pl := UVM_NONE

export MEM_SWITCH := off
export ASSERT_SWITCH := off
export BT_NAME := blk_a 

export TIME_SCALE := -timescale=1ns/1ps
export USER_CMP_OPTS := -sverilog -full64 +vc +v2k -kdb +lint=TFIPC-L
export USER_RUN_OPTS := +notimingcheck +ntb_random_seed=${seed}
export VERIFICATION_METHOD = UVM

ifeq (${VERIFICATION_METHOD},UVM) 
    export UVM_CMP_OPTS := -ntb_opts uvm-1.2
    export UVM_RUN_OPTS := +UVM_TESTNAME=${tc} +UVM_VERBOSITY=${pl}
endif

ifeq (${wave},fsdb)
    export DEBUG_CMP_OPTS := -debug_access+all
    export DEBUG_RUN_OPTS := +fsdbfile+${mode}/wave/${tc}.fsdb \
							 -ucli -do ../tc/wave_fsdb.do \
							 
endif

ifeq (${gui},dve)
    export GUI_RUN_OPTS := -gui=dve +UVM_VERDI_TRACE=HIER
endif
ifeq (${gui},verdi)
    export GUI_RUN_OPTS := -gui=verdi +UVM_VERDI_TRACE=HIER
endif

export COM_CMP_OPTS := ${TIME_SCALE} ${USER_CMP_OPTS} ${DEBUG_CMP_OPTS}
export COM_RUN_OPTS := ${USER_RUN_OPTS} ${DEBUG_RUN_OPTS} ${GUI_RUN_OPTS}
export UVM_TEST_SIMV := ${mode}/exec/uvm_test_simv

create_env_dir:
	@mkdir -p rtl 
	@mkdir -p verification
	@mkdir -p verification/common
	@mkdir -p verification/bt/${BT_NAME} 
	@mkdir -p verification/bt/${BT_NAME}/cfg
	@mkdir -p verification/bt/${BT_NAME}/sim 
	@mkdir -p verification/bt/${BT_NAME}/env 
	@mkdir -p verification/bt/${BT_NAME}/tc 
	@mkdir -p verification/bt/${BT_NAME}/th
	@cp -rf ./scripts/wave_fsdb.do verification/bt/${BT_NAME}/tc
	@cp -rf ./scripts/Makefile verification/bt/${BT_NAME}/sim

make_dir:
	@mkdir -p ${mode}/exec 
	@mkdir -p ${mode}/log
	@mkdir -p ${mode}/wave
	@mkdir -p ${mode}/cov
	@mkdir -p ${mode}/verdi

cmp: make_dir
	@vcs ${COM_CMP_OPTS} ${UVM_CMP_OPTS} ${udl} \
	 -o ${mode}/exec/uvm_test_simv -Mdir=${mode}/exec/uvm_test_csrc -l ${mode}/log/uvm_test.cmp_log
batch_run: make_dir ${UVM_TEST_SIMV}
	@${mode}/exec/uvm_test_simv ${COM_RUN_OPTS} ${UVM_RUN_OPTS} -l ${mode}/log/${tc}.log 

ncrun: batch_run

${UVM_TEST_SIMV}:
	@vcs ${COM_CMP_OPTS} ${UVM_CMP_OPTS} ${udl} \
	 -o ${mode}/exec/uvm_test_simv -Mdir=${mode}/exec/uvm_test_csrc -l ${mode}/log/uvm_test.cmp_log
	

verdi:
	@verdi -nologo -simflow -simBin ${mode}/exec/uvm_test_simv -logdir ${mode}/verdi

run:cmp batch_run

clean:
	@rm -rf ${mode}
	@rm -rf ucli.key tr_db.log novas.conf novas_dump.log
