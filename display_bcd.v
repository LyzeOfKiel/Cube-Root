module display_bcd (
	input clk,
	input [31:0] value,
	output [7:0] control,
	output [7:0] leds
);


bcd_convert #(32, 8) bcd_convert( 
	.i_Clock(clk),
	.i_Binary(value_temp),
	.i_Start(1'b1),
	.o_BCD(bcd_number),
	.o_DV(bcd_ready)
);
	
integer delay = 0;
integer final_bcd;

reg [2:0] ctrl = 0;
reg [4:0] digit;

wire bcd_ready;
wire [31:0] bcd_number;

wire [31:0] digits;
assign digits = final_bcd;

wire [31:0] value_temp;
assign value_temp = value;


assign control = ~(1 << ctrl);

assign leds = ~
(digit == 0 ? 8'b00111111 :
(digit == 1 ? 8'b00000110 :
(digit == 2 ? 8'b01011011 :
(digit == 3 ? 8'b01001111 :
(digit == 4 ? 8'b01100110 :
(digit == 5 ? 8'b01101101 :
(digit == 6 ? 8'b01111101 :
(digit == 7 ? 8'b00000111 :
(digit == 8 ? 8'b01111111 :
(digit == 9 ? 8'b01101111 :
8'b00000000))))))))));


always @(posedge clk)
begin
	
	if (bcd_ready)
		final_bcd = bcd_number;
	
	case(ctrl)
		0: digit = digits[3:0];
		1: digit = digits[31:4] ? digits[7:4] : 10;
		2: digit = digits[31:8] ? digits[11:8] : 10;
		3: digit = digits[31:12] ? digits[15:12] : 10;
		4: digit = digits[31:16] ? digits[19:16] : 10;
		5: digit = digits[31:20] ? digits[23:20] : 10;
		6: digit = digits[31:24] ? digits[27:24] : 10;
		7: digit = digits[31:28] ? digits[31:28] : 10;
	endcase

	delay = delay + 1;
	
	if (delay == 10000)
		ctrl = ctrl + 1;
	
end

endmodule 