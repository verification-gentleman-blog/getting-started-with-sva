module repetition_in_asserts(input bit clk);

  default clocking @(posedge clk);
  endclocking


  parameter enum { CONSECUTIVE, GOTO } repetition_kind = `REPETITION_KIND;


  if (repetition_kind == CONSECUTIVE) begin: consecutive
  end
  if (repetition_kind == GOTO) begin: goto
  end

endmodule
