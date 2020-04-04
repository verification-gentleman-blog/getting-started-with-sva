module throughout_operator(input bit clk);
   
  default clocking @(posedge clk);
  endclocking


  bit start;
  bit cancel;
  bit accept;
  

  no_cancel_between_start_and_accept_long: cover property (
      start && !cancel ##1 !accept && !cancel [*] ##1 accept && !cancel);

  no_cancel_between_start_and_accept: cover property (
      !cancel throughout (start ##1 accept [->1]));


  // Add some delay between signals to make the traces more interesting
  delay_between_start_and_accept: assume property (start |-> !accept [*5]);
  
endmodule
