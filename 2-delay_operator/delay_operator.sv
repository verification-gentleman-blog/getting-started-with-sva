module delay_operator(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;


  parameter enum { SINGLE, MULTI } delay_kind = `DELAY_KIND;
  parameter enum { CONCURRENT, IMMEDIATE } assert_kind = `ASSERT_KIND;

  if (delay_kind == SINGLE) begin: single
    if (assert_kind == CONCURRENT) begin: concurrent

      a_followed_by_b: cover property (
          a ##1 b);

    end
    if (assert_kind == IMMEDIATE) begin: immediate

      typedef enum { IDLE, A_SEEN, END } state_e;

      state_e state;
      state_e next_state;
      bit match;

      always_ff @(posedge clk)
        state <= next_state;

      always_comb begin
        next_state = state;

        case (state)
          IDLE:
            if (a)
              next_state = A_SEEN;
          A_SEEN:
            next_state = END;
        endcase
      end

      assign match = (state == A_SEEN) && b;


      always @(posedge clk)
        cover (match);


      bit init = 1;

      always @(posedge clk) begin
        if (init)
          assume (state == IDLE);
        init <= 0;
      end

    end
  end
  if (delay_kind == MULTI) begin: multi
    if (assert_kind == CONCURRENT) begin: concurrent

      a_followed_by_b_after_3_cycles: cover property (
          a ##3 b);

    end
    if (assert_kind == IMMEDIATE) begin: immediate

      typedef enum { IDLE, A_SEEN, WAIT1, WAIT2, END } state_e;

      state_e state;
      state_e next_state;
      bit match;

      always_ff @(posedge clk)
        state <= next_state;

      always_comb begin
        next_state = state;

        case (state)
          IDLE:
            if (a)
              next_state = A_SEEN;
          A_SEEN:
            next_state = WAIT1;
          WAIT1:
            next_state = WAIT2;
          WAIT2:
            next_state = END;
        endcase
      end

      assign match = (state == WAIT2) && b;


      always @(posedge clk)
        cover (match);


      bit init = 1;

      always @(posedge clk) begin
        if (init)
          assume (state == IDLE);
        init <= 0;
      end

    end
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
