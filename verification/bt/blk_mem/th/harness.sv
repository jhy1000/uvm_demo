
module harness;
    import uvm_pkg::*;
    import my_pkg::*;
    logic clk;
    logic reset;
    parameter min_cover = 70;
    parameter min_transa = 2000;

    initial begin
        clk = 0;
        reset = 1;
        #22 reset = 0;
        #40000 reset = 1;
        #22 reset = 0;
    end

    always #5 clk = !clk;

    logic [1:0] state;

    mem_if mem_vif(.clk(clk),.reset(reset));

    memory DUT(
        .clk(mem_vif.clk),
        .reset(mem_vif.reset),
        .addr(mem_vif.addr),
        .wr_en(mem_vif.wr_en),
        .rd_en(mem_vif.rd_en),
        .wdata(mem_vif.wdata),
        .rdata(mem_vif.rdata)
    );

    initial begin
        uvm_config_db#(virtual mem_if)::set(uvm_root::get(),"*","mem_if",mem_vif);
        uvm_config_db#(int)::set(uvm_root::get(),"*","min_cover",min_cover);
        uvm_config_db#(int)::set(uvm_root::get(),"*","min_transa",min_transa);
        run_test();
    end

endmodule

