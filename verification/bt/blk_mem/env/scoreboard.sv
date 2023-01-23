
class scoreboard extends uvm_scoreboard;
    typedef packet T;
    typedef uvm_in_order_class_comparator #(T) comp_type;
    uvm_tlm_analysis_fifo #(packet) to_refmod;

    refmod rfm;
    comp_type comp;

    uvm_analysis_port #(T) ap_comp;
    uvm_analysis_port #(T) ap_rfm;

    `uvm_component_utils(scoreboard)

    function new(string name="translator",uvm_component parent=null);
        super.new(name,parent);
        ap_comp = new("ap_comp",this);
        ap_rfm = new("ap_rfm",this);
        to_refmod = new("to_refmod",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rfm = refmod::type_id::create("rfm",this);
        comp = comp_type::type_id::create("comp",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ap_comp.connect(comp.before_export);
        rfm.out.connect(comp.after_export);
        ap_rfm.connect(rfm.in);
    endfunction
endclass

