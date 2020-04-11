module delay_in_asserts(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;
  bit c;


  parameter enum { ANTECEDENT, CONSEQUENT } delay_location = `DELAY_LOCATION;

  if (delay_location == ANTECEDENT) begin: antecedent

    with_delay: assert property (
        a ##1 b |=> c);

  end
  if (delay_location == CONSEQUENT) begin: consequent

    with_delay: assert property (
        c |=> a ##1 b);

  end


  parameter bit a_after_c = 0;

`ifdef A_AFTER_C
  defparam a_after_c = 1;
`endif

  if (a_after_c) begin

    assume property (c |=> a);

  end

endmodule
