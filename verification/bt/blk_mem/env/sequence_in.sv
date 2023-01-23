
class sequence_in extends uvm_sequence #(packet);
    `uvm_object_utils(sequence_in)

    function new(string name="sequence_in");
        super.new(name);
    endfunction
    
    task body;
        packet req;
        forever begin
            `uvm_do(req)
        end
    endtask
endclass

