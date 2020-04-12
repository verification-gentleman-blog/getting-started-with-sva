module repetition(input bit clk);

  bit a;

  default clocking @(posedge clk);
  endclocking


  parameter enum { CONSECUTIVE, GOTO } repetition_kind = `REPETITION_KIND;

  // Can't declare inside 'consecutive' block, as it will be treated as a
  // localparam, which can't be set via 'defparam'
  parameter enum { CONCURRENT, IMMEDIATE } assert_kind = CONCURRENT;
`ifdef ASSERT_KIND
    defparam assert_kind = `ASSERT_KIND;
`endif


  if (repetition_kind == CONSECUTIVE) begin: consecutive
    if (assert_kind == CONCURRENT) begin: concurrent

      five_times_a: cover property (a [*5]);

    end
    if (assert_kind == IMMEDIATE) begin: immediate

      int unsigned counter;

      always_ff @(posedge clk)
        if (a && counter < 5-1)
          counter++;
        else
          counter = 0;

      assign match = (counter == 5-1 && a);

      always @(posedge clk)
        cover (match);

      // Needed to initialize counter
      bit init = 1;

      always @(posedge clk) begin
        if (init)
          assume (counter == 0);
        init <= 0;
      end

    end
  end
  if (repetition_kind == GOTO) begin: goto

`ifdef MULTIPLE_REPETITIONS
`define MULTIPLE_REPETITIONS_VAL 1
`else
`define MULTIPLE_REPETITIONS_VAL 0
`endif

    parameter bit multiple_repetitions = `MULTIPLE_REPETITIONS_VAL;

    bit b;

    if (!multiple_repetitions) begin: single_rep

      a_then_b: cover property (a ##1 b [->1]);

    end
    else begin: multiple_reps

      a_then_two_times_b: cover property (a ##1 b [->2]);

    end

    // Add some delay between signals to make the traces more interesting
    delay_between_a_and_b: assume property (a |-> !b [*4]);
    delay_between_b_and_b: assume property (b |=> !b);

  end

endmodule
