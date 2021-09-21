module systolic_array
#(
   parameter BITS_AB=8,
   parameter BITS_C=16,
   parameter DIM=8
   )
  (
   input                      clk,rst_n,WrEn,en,
   input signed [BITS_AB-1:0] A [DIM-1:0],
   input signed [BITS_AB-1:0] B [DIM-1:0],
   input signed [BITS_C-1:0]  Cin [DIM-1:0],
   input [$clog2(DIM)-1:0]    Crow,
   output signed [BITS_C-1:0] Cout [DIM-1:0]
   );

  genvar i, j;

  wire [BITS_AB-1:0] A_int [DIM:0][DIM-1:0];  
  wire [BITS_AB-1:0] B_int [DIM-1:0][DIM:0];
  wire [BITS_C-1:0] C_int [DIM-1:0][DIM-1:0];

  assign A_int[0] = A;
  assign B_int[0] = B;

  generate
    for (i = 0; i < DIM; i++) begin
      for (j = 0; j < DIM; j++) begin
        tpumac my_tpumac(.clk(clk), .rst_n(rst_n), .en(en), 
                          .WrEn(WrEn & (Crow == i)),
                          .Ain(A_int[i][j]), 
                          .Bin(B_int[i][j]), 
                          .Cin(Cin[j]), 
                          .Aout(A_int[i+1][j]), 
                          .Bout(B_int[i][j+1]), 
                          .Cout(C_int[i][j]);
      end
    end
  endgenerate

  for (int k = 0; k < DIM; k++) begin
    assign Cout[k] = (Crow == k) ? C_int[k] : Cout[k];
  end

endmodule
