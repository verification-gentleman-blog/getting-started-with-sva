module delay_in_asserts(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;
  bit c;


  delay_in_antecedent: assert property (
      a ##1 b |-> c);

  delay_in_consequent: assert property (
      c |-> a ##1 b);

endmodule
