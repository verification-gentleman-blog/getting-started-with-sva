module sequence_triggered(input bit clk);

  default clocking @(posedge clk);
  endclocking
  

  bit request;
  bit accept;
  bit cancel;


  // Signals used in sequence have to be arguments, otherwise the tool will
  // complain.
  sequence accepted_request(bit request, bit accept, bit cancel);
    request ##1 (!cancel throughout accept [->1]);
  endsequence


  bit busy;
  

  // Causes a segmentation fault
  become_busy_only_due_to_accepted_request: assert property (
      $rose(busy) |-> accepted_request.triggered);
  
endmodule
