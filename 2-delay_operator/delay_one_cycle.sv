module delay_one_cycle(input bit clk);

  bit a;
  bit b;

  
  typedef enum {
    IDLE,
    A_SEEN,
    END
  } state_e;

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
    
endmodule
