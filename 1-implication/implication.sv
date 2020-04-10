module implication(input bit clk);

  bit antecedent;
  bit consequent;


  typedef enum {
    OVERLAPPING,
    NON_OVERLAPPING
  } implication_kind_e;

  // XXX WORKAROUND Can't select parameter using '-chparam' in SBY file
  parameter implication_kind = `IMPLICATION_KIND;


  typedef enum {
    CONCURRENT,
    IMMEDIATE
  } assert_kind_e;

  // XXX WORKAROUND Can't select 'assert_kind' using '-chparam'. The tool complains that it
  // can't parse an enum literal value. I tried using all sorts of quotes, but couldn't get
  // it to work.
  parameter assert_kind = `ASSERT_KIND;


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

      always @(posedge clk)
        if ($past(antecedent))
    	assert (consequent);

    end
  end

endmodule
