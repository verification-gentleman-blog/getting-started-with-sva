module repetition(input bit clk);

   default clocking @(posedge clk);
   endclocking


   bit a;
   
   cover_five_times_a: cover property (a [*5]);
   
endmodule
