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


  parameter bit a_repeats = 0;

`ifdef A_REPEATS
  defparam a_repeats = 1;
`endif

  if (a_repeats) begin

    assume property ($rose(a) |=> a);

    bit first_cycle = 1;

    always @(posedge clk)
      first_cycle <= 0;

    assume property (first_cycle && a |-> $rose(a));

  end

  parameter bit b_repeats = 0;

`ifdef B_REPEATS
  defparam b_repeats = 1;
`endif

  if (b_repeats) begin

    assume property ($rose(b) |=> b);

    assume property (a ##1 b |=> !b);
    assume property (a ##3 b |=> !b);

  end

endmodule
