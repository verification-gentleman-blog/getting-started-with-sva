module repetition(input bit clk);

   default clocking @(posedge clk);
   endclocking


   bit a;
   

   sequence five_times_a;
      a [*5];
   endsequence

   cover_five_times_a: cover property (five_times_a);


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
