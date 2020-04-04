module goto_repetition;

  bit clk;
  
  default clocking @(posedge clk);
  endclocking

  
  bit a;
  bit b;

  a_then_b: cover property (a ##1 b [->1]);


  // Add some delay between a and b to make the trace more interesting
  delay_between_a_and_b: assume property (a |-> !b [*4]);
  
endmodule
