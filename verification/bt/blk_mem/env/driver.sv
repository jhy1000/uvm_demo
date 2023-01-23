
`define DRV_IF mem_vif.DRIVER.driver_cb

class driver extends uvm_driver #(packet);
    `uvm_component_param_utils(driver)

    typedef packet tr_type;

    typedef virtual mem_if vif;
    vif mem_vif;
    event reset_driver;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vif)::get(this,"","mem_if",mem_vif)) begin
            `uvm_fatal("NOVIF","failed to get virtual interface")
        end
    endfunction

    task pre_reset_phase(uvm_phase phase);
        `DRV_IF.wr_en   <= 0;
        `DRV_IF.rd_en   <= 0;
    endtask

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        wait(mem_vif.reset == 1'b1);
        `uvm_info(get_type_name(),$sformatf("after waiting for rstn to be asserted"),UVM_LOW)
        phase.drop_objection(this);
    endtask

    task post_reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        wait(mem_vif.reset == 1'b0);
        `uvm_info(get_type_name(),$sformatf("after waiting for rstn to be deasserted"),UVM_LOW)
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("enter in main_phase"),UVM_LOW)
        forever begin
            fork
                begin
                    get_and_drive();
                end
                begin
                    wait(reset_driver.triggered)
                    `uvm_info(get_name(),$sformatf("after wait for reset_driver event to be triggered"), UVM_LOW)
                end
            join_any
        end
    endtask

    task get_and_drive();
        tr_type trans;
        seq_item_port.get_next_item(trans);
        `DRV_IF.wr_en   <= 0;
        `DRV_IF.rd_en   <= 0;
        $display("----------------------[DRIVER-TRANSFER]-----------------------");
        @(posedge mem_vif.DRIVER.clk);
        `DRV_IF.addr <= trans.addr;
        if(trans.wr_en) begin
            `DRV_IF.wr_en   <= trans.wr_en;
            `DRV_IF.wdata   <= trans.wdata;
            $display("\tADDR = %0h \tWDATA = %0h", trans.addr, trans.wdata);
            @(posedge mem_vif.DRIVER.clk);
        end
        if(trans.rd_en) begin
            `DRV_IF.rd_en   <= trans.rd_en;
            @(posedge mem_vif.DRIVER.clk);
            `DRV_IF.rd_en   <= 0;
            @(posedge mem_vif.DRIVER.clk);
            trans.rdata = `DRV_IF.rdata;
            $display("\tADDR = %0h \tRDATA = %0h", trans.addr, `DRV_IF.rdata);
        end
        $display("-----------------------------------------");
        seq_item_port.item_done();
    endtask

endclass

