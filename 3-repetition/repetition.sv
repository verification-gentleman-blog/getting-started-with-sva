module repetition(input bit clk);

  bit a;

  default clocking @(posedge clk);
  endclocking


  parameter enum { CONCURRENT, IMMEDIATE } assert_kind = `ASSERT_KIND;

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

endmodule
