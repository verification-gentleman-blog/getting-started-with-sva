module throughout_in_asserts(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit req;
  bit grant;

  no_new_req_while_waiting_for_grant: assert property (
      req |=> !req throughout grant [->1]);


  // Add some delay between signals to make the traces more interesting
  assume property (req |=> !grant [*5]);
  assume property (req |=> !req [*2]);

endmodule
