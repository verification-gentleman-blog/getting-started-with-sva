module delay_operator(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;


  a_followed_by_b_trace: cover property (
      a ##1 b);

  a_followed_by_b_after_3_cycles_trace: cover property (
      a ##3 b);

endmodule
