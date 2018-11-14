module calculate(
	input clk,
	input ready_to_calc,
	input [31:0] num,
	output reg ready,
	output [31:0] res
);

integer mid;
integer start;
integer final;
integer counter;

assign res = mid;

always @(posedge clk)
begin
if (ready_to_calc == 1) begin
	if (ready == 0) begin
		mid = (start + final )/2;
	
		if ((mid*mid*mid) > num) begin
        	    final = mid; 
  		end else begin
        	    start = mid;
		end
		
		if (counter == 27) begin
			ready = 1;
			counter = 0;
		end else begin
			counter = counter + 1;
		end
	end
end else begin
	final = 465;
	start = 0;
	ready = 0;
	counter = 0;	
end
end
	
endmodule 