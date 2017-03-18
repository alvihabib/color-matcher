/*module timer(clk, reset, enable, counter_out);
	input clk;
	input reset;
	input enable;
	output [7:0] counter_out;
	
	wire delay_out;
	
	delay_1s d0(.delay(delay_out), .clk(clk));
	up_counter u0(.out(counter_out), .enable(enable), .clock(delay_out), .reset(reset));

	
endmodule

// Rate Divider

module delay_1s(delay,clk);
	output reg delay;
	input clk;
	reg [25:0] count;
	
	always @(posedge clk)
	begin
		if(count==26'd49_999_999)
		begin
			count<=26'd0;
			delay<=1;
		end
		else
		begin
			count<=count+1;
			delay<=0;
		end
	end
endmodule

// 8-bit up counter
module up_counter(out, enable, clock, reset);
	input enable, clock, reset;
	output [7:0] out;
	reg [7:0] out;
	
	always @(posedge clock)
	if (!reset)
	begin
		out <= 8'b0;
	end
	else if (!enable)
	begin
		out <= out + 1;
	end
endmodule

*/



module timer(clk, resetn, enable, counter_out0, counter_out1);
	input clk;
	input resetn;
	input enable;
	
	wire [25:0] delay_out1;
	wire [28:0] delay_out10;
	wire delayEn1, delayEn10;
	output [3:0] counter_out0;
	output [3:0] counter_out1;

	
	
	delay_1s d0(.clk(clk), .resetn(resetn), .enable(enable), .count(delay_out1));
	delay_10s d1(.clk(clk), .resetn(resetn), .enable(enable), .count(delay_out10));
	
	assign delayEn1 = (delay_out1 == 0) ? 1 : 0;
	assign delayEn10 = (delay_out10 == 0) ? 1 : 0;
	
	up_counter u0(.clk(clk), .resetn(resetn), .enable(delayEn1), .out(counter_out0[3:0]));
	up_counter u1(.clk(clk), .resetn(resetn), .enable(delayEn10), .out(counter_out1[3:0]));
	
endmodule

// Rate Divider

module delay_1s(clk, resetn, enable, count);
	input clk;
	input resetn;
	input enable;
	output reg [25:0] count;
	
	always @(posedge clk)
	begin
		if (!resetn) begin
			count <= 26'd49/*_999_999*/;
		end
		else if (enable && count == 0) begin
			count <= 26'd49/*_999_999*/;
		end
		else if (enable) begin
			count <= count - 1;
		end
	end
endmodule

module delay_10s(clk, resetn, enable, count);
	input clk;
	input resetn;
	input enable;
	output reg [28:0] count;
	
	always @(posedge clk)
	begin
		if (!resetn) begin
			count <= 29'd499/*_999_999*/;
		end
		else if(enable && count == 0) begin
			count <= 29'd499/*_999_999*/;
		end
		else if (enable) begin
			count <= count - 1;
		end
	end
endmodule

// 4-bit up counter
module up_counter(clk, resetn, enable, out);
	input clk, resetn, enable;
	output reg [3:0] out;
	
	always @(posedge clk) begin
		if (!resetn)
			out <= 4'b0;
		else if (out == 4'd10)
			out <= 4'b0;
		else if (enable)
			out <= out + 1;
	end
endmodule

/*
module timer(clk, ones_out, tens_out, enable);
	input enable;
	input clk;
	
	wire delay_out;
	wire [7:0] counter_out;
	output [3:0] tens_out;
	output [3:0] ones_out;
	
	delay_1s d0(.delay(delay_out), .CLOCK_50(clk));
	up_counter u0(.out(counter_out), .enable(enable), .clock(delay_out));
	bin_to_bcd b0(.binary(counter_out), .tens(tens_out), .ones(ones_out));
	//hex_decoder h0(.hex_digit(ones_out[3:0]), .segments(HEX0[6:0]));
	//hex_decoder h1(.hex_digit(tens_out[3:0]), .segments(HEX1[6:0]));
	
	
	
endmodule

// Rate Divider

module delay_1s(delay,CLOCK_50);
	output reg delay;
	input CLOCK_50;
	reg [25:0] count;
	
	always @(posedge CLOCK_50)
	begin
		if(count==26'd49_999_999)
		begin
			count<=26'd0;
			delay<=1;
		end
		else
		begin
			count<=count+1;
			delay<=0;
		end
	end
endmodule

// 8-bit up counter
module up_counter(out, enable, clock, reset);
	input enable, clock, reset;
	output [7:0] out;
	reg [7:0] out;
	
	always @(posedge clock)
	if (!reset)
	begin
		out <= 8'b0;
	end
	else if (!enable)
	begin
		out <= out + 1;
	end
endmodule

// Binary to BCD
module bin_to_bcd(binary, tens, ones);
	input [7:0] binary;
	output reg [3:0] tens;
	output reg [3:0] ones;
	
	integer shifter;
	always @(binary)
	begin
		tens = 4'd0;
		ones = 4'd0;
		
		for (shifter=7; shifter>=0; shifter=shifter-1)
		begin
			if (tens >= 5)
				tens = tens + 3;
			if (ones >= 5)
				ones = ones +3;
			
			tens = tens << 1;
			tens[0] = ones [3];
			ones = ones << 1;
			ones[0] = binary[shifter];
		end
	end
endmodule
*/