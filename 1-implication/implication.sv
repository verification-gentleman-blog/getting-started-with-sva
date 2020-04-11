module implication(input bit clk);

  bit antecedent;
  bit consequent;


  // XXX WORKAROUND Can't select parameter using '-chparam' in SBY file
  parameter enum { OVERLAPPING, NON_OVERLAPPING } implication_kind = `IMPLICATION_KIND;

  // XXX WORKAROUND Can't select 'assert_kind' using '-chparam'. The tool complains that it
  // can't parse an enum literal value. I tried using all sorts of quotes, but couldn't get
  // it to work.
  parameter enum { CONCURRENT, IMMEDIATE } assert_kind = `ASSERT_KIND;


  default clocking @(posedge clk);
  endclocking


  if (implication_kind == OVERLAPPING) begin: overlapping
    if (assert_kind == CONCURRENT) begin: concurrent

      implication: assert property (antecedent |-> consequent);

    end

    if (assert_kind == IMMEDIATE) begin: immediate

      always @(posedge clk)
        if (antecedent)
          assert (consequent);

    end
  end


  if (implication_kind == NON_OVERLAPPING) begin: non_overlapping
    if (assert_kind == CONCURRENT) begin: concurrent

      implication: assert property (antecedent |=> consequent);

    end

    if (assert_kind == IMMEDIATE) begin: immediate

      typedef enum {
        BUGGY,
        CORRECT
      } modeling_kind_e;

      // XXX WORKAROUND Can't select parameter using '-chparam' in SBY file
      parameter modeling_kind = `MODELING_KIND;

      if (modeling_kind == BUGGY) begin: buggy

        always @(posedge clk)
          if ($past(antecedent))
            assert (consequent);

      end
      if (modeling_kind == CORRECT) begin: correct

        bit past_valid = 0;

        always @(posedge clk)
          past_valid <= 1;

        always @(posedge clk)
          if (past_valid && $past(antecedent))
            assert (consequent);

      end
    end
  end

endmodule
