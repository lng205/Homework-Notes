module gcd#(parameter W=16)(
input clk,start,rst,
input [W-1:0] A_in, B_in,
output reg [W-1:0] result,
output reg result_valid
    );

localparam Init=2'b00, Sub=2'b01, Mult=2'b10, Done=2'b11;

reg [2:0] state, nextstate;
reg [W-1:0] A, B, d;//d is the number of factor 2 in result

always@(posedge clk) begin
    if(rst) state <= Init;
    else state <= nextstate;
end

always@(*) begin
    case(state)
        Init: begin
            if(start) nextstate = Sub;
            else nextstate = Init;
        end
        Sub: begin
            if(A==B) nextstate = Mult;
            else nextstate = Sub;
        end
        Mult: nextstate = Done;
        Done: nextstate = Init;
    endcase
end

always@(posedge clk) begin
    case(state)
        Init: begin
            A<=A_in;
            B<=B_in;
            result_valid<=0;
            d<=0;
        end
        Sub: begin
            if(A[0]==0) begin
                A<=A[W-1:1];
                if(B[0]==0) begin
                    B<=B[W-1:1];
                    d<=d+1;
                end
            end
            else if(B[0]==0) B<=B[W-1:1];
            else if(A>B) A<=A-B;
            else B<=B-A;
        end
        Mult: result<=A<<d;
        Done: result_valid<=1;
    endcase
end
endmodule
