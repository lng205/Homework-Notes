module testbench;
localparam W=10;
reg clk, start, rst;
reg [W-1:0] A, B;
wire [W-1:0] result;
wire result_valid;

gcd #(.W(W)) gcd_inst(
.clk(clk),
.start(start),
.rst(rst),
.A_in(A),
.B_in(B),
.result(result),
.result_valid(result_valid)
);


initial begin
clk=0; start=0; rst=1; A=752; B=168;
#40 rst=0;
#20 start=1;
#60 start=0;
#1000 A=33; B=777; start=1;
#60 start=0;
end
always #10 clk=~clk;
endmodule
