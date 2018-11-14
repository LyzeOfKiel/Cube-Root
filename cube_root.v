module cube_root(
	input inc,
	input sub,
	input next,
	input prev,
	input enter,
	input clk,
	output wire [7:0] leds,
	output wire [7:0] control
);

	reg signed [31:0] exit;
	wire ready;
	wire [31:0] res;
	reg zero = 0;

	// input //

	reg inc1 = 0;
	reg next1 = 0;
	reg prev1 = 0;
	reg sub1 = 0;
	reg enter1 = 0;
	reg [31:0] decimal = 1;

	//////////
	
	reg [31:0] to_display;
	
	display_bcd display(
		.clk(clk),
		.value(ready == 0 ? exit : res),
		.control(control),
		.leds(leds)
	);

	calculate calc(
		.clk(clk),
		.ready_to_calc(~enter),
		.num(exit),
		.ready(ready),
		.res(res)
	);

always @(posedge clk)
begin
	if (enter == 1) begin
		if ((inc1 == 1'b0) && (~inc == 1'b1)) begin
			exit = exit + decimal;
		end
		inc1 = ~inc;
		
		if ((sub1 == 1'b0) && (~sub == 1'b1)) begin
			if (exit > 0) begin
				exit = exit - decimal;
			end
		end
		sub1 = ~sub;
		
		if ((next1 == 1'b0) && (~next == 1'b1)) begin
			decimal = decimal * 10;
		end
		next1 = ~next;
		
		if ((prev1 == 1'b0) && (~prev == 1'b1)) begin
			if (decimal >= 1 && decimal <= 9) begin
				decimal = 1;
			end else begin
				decimal = decimal / 10;
			end
		end
		prev1 = ~prev;
	end else begin
		if (ready == 1'b1) begin
			exit = 0;
			decimal = 1;
		end
	end
end



endmodule 