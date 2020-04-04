module delay_operator(input bit clk);

  default clocking @(posedge clk);
  endclocking


  bit a;
  bit b;
  

  a_followed_by_b_trace: cover property (
      a ##1 b);

  a_followed_by_b_after_3_cycles_trace: cover property (
      a ##3 b);



  typedef enum {
    IDLE,
    A_SEEN,
    END
  } a_followed_by_b_state_e;

  a_followed_by_b_state_e a_followed_by_b_state;
  a_followed_by_b_state_e a_followed_by_b_next_state;
  bit a_followed_by_b_match;
  
  always_ff @(posedge clk)
    a_followed_by_b_state <= a_followed_by_b_next_state;

  always_comb begin
    a_followed_by_b_next_state = a_followed_by_b_state;

    case (a_followed_by_b_state)
      IDLE:
        if (a)
          a_followed_by_b_next_state = A_SEEN;
      A_SEEN:
        a_followed_by_b_next_state = END;
    endcase
  end

  assign a_followed_by_b_match = (a_followed_by_b_state == A_SEEN) && b;


  always @(posedge clk)
    cover (a_followed_by_b_match);


  // Needed to initialize counter
   bit init = 1;

   always @(posedge clk) begin
     if (init)
       assume (a_followed_by_b_state == IDLE);
     init <= 0;
   end
    
endmodule
