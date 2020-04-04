module repeat_five_times(input bit clk);

  bit a;
   

  int unsigned counter;


  always @(posedge clk)
    if (a && counter < 5-1)
      counter++;
    else
      counter = 0;

  always @(posedge clk)
    cover (counter == 5-1 && a);


  // Needed to initialize counter
  bit init = 1;

  always @(posedge clk) begin
    if (init)
      assume (counter == 0);
    init <= 0;
  end
   
endmodule
