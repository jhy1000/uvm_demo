
`uvm_analysis_imp_decl(_req)
`uvm_analysis_imp_decl(_resp)

class cover_mem extends uvm_component;
    
    `uvm_component_utils(cover_mem)

    packet req;
    packet resp;

    uvm_analysis_imp_req#(packet, cover_mem) req_port;
    uvm_analysis_imp_resp#(packet, cover_mem) resp_port;

    int min_cover;
    int min_transa = 5000;
    int transa = 0;
    logic result_available = 0;
    
    function new(string name="cover_mem",uvm_component parent=null);
        super.new(name,parent);
        req_port = new("req_port",this);
        resp_port = new("resp_port",this);
        resp = new;
        req = new;
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(int)::get(this,"","min_cover",min_cover);
        uvm_config_db#(int)::get(this,"","min_transa",min_transa);
    endfunction

    protected uvm_phase running_phase;
    task run_phase(uvm_phase phase);
        running_phase = phase;
        running_phase.raise_objection(this);
        running_phase.raise_objection(this);
    endtask

    function void write_req(packet t);
        req.copy(t);
        transa = transa + 1;
        $display("min_transa:%0d",min_transa);
        if(transa >= min_transa) begin
            $display("dropou");
            running_phase.drop_objection(this);
        end
    endfunction

    function void write_resp(packet t);
        resp.copy(t);
        transa = transa + 1;
        $display("transa:%0d",transa);
        $display("min_transa:%0d",min_transa);
        if(transa >= min_transa) begin
            $display("dropou");
            running_phase.drop_objection(this);
        end
    endfunction

endclass


