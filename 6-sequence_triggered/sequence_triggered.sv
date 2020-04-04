module sequence_triggered(input bit clk);

  default clocking @(posedge clk);
  endclocking
  

  bit request;
  bit accept;
  bit cancel;


  sequence accepted_request;
    @(posedge clk)
    request ##1 (!cancel throughout accept [->1]);
  endsequence


  bit busy;
  
  become_busy_only_due_to_accepted_request: assert property (
      $rose(busy) |-> accepted_request.triggered);


  become_busy_only_due_to_accepted_request_trace: cover property (
      $rose(busy) && accepted_request.triggered);

  
  // Makes the traces more interesting
  some_delay_between_request_and_accept: assume property (
      request |-> !accept [*4]);
  
endmodule
