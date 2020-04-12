module throughout_operator(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;

  a_high_until_b: cover property (a throughout b [->3]);


  // Make traces more interesting
  assume property (b |=> !b [*2]);

endmodule
