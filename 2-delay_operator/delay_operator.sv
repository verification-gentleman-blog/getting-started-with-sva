module delay_operator(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;


  parameter enum { SINGLE, MULTI } delay_kind = `DELAY_KIND;

  if (delay_kind == SINGLE) begin: single

    a_followed_by_b: cover property (
        a ##1 b);

  end
  if (delay_kind == MULTI) begin: multi

    a_followed_by_b_after_3_cycles: cover property (
        a ##3 b);

  end

endmodule
