module goto_repetition;

  bit clk;
  
  default clocking @(posedge clk);
  endclocking

  
  bit a;
  bit b;

  a_then_b: cover property (a ##1 b [->1]);
  a_then_two_times_b: cover property (a ##1 b [->2]);


  // Add some delay between signals to make the traces more interesting
  delay_between_a_and_b: assume property (a |-> !b [*4]);
  delay_between_b_and_b: assume property (b |=> !b);
  
endmodule
