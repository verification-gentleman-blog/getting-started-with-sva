module repeat_five_times(
    input bit clk,
    input bit a,
    output bit match
    );

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
   
endmodule
