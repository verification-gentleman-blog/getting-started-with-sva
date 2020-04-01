module repetition(input bit clk);

   default clocking @(posedge clk);
   endclocking


   bit a;
   

   sequence five_times_a;
      a [*5];
   endsequence

   cover_five_times_a: cover property (five_times_a);
   
endmodule
