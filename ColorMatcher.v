
module ColorMatcher
	(
		CLOCK_50,						//	On Board 50 MHz
        KEY,
        SW,
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
		  PS2_DAT, PS2_CLK,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output [6:0] HEX0; output [6:0] HEX1; output [6:0] HEX2; output [6:0] HEX3; output [6:0] HEX4; output [6:0] HEX5;
	
	input PS2_DAT;
	input PS2_CLK;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] c;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
/*	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(c),
			.x(x),
			.y(y),
			.plot(writeEn),*/
			/* Signals for the DAC to drive the monitor. */
/*			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
*/		
	wire [11:0] Wire; wire checkMatch; wire checkFinish; wire timerEn; wire timerResetn; wire [1:0]isCorrect; wire [1:0]isFinished;
	wire [7:0] scan_code; wire read, scan_ready;	wire [3:0] state;
	control control(.clk(CLOCK_50), .resetn(resetn), .level(SW[2:0]), .go(!KEY[3]), .keyboard(scan_code[7:0]), .isCorrect(isCorrect), .isFinished(isFinished),
						 .reveal_q(Wire[0]), .reveal_w(Wire[1]), .reveal_e(Wire[2]), .reveal_r(Wire[3]), 
						 .reveal_a(Wire[4]), .reveal_s(Wire[5]), .reveal_d(Wire[6]), .reveal_f(Wire[7]), 
						 .reveal_z(Wire[8]), .reveal_x(Wire[9]), .reveal_c(Wire[10]), .reveal_v(Wire[11]), 
						 .checkMatch(checkMatch), .checkFinish(checkFinish),
						 .timerEn(timerEn), .timerResetn(timerResetn), .state(state));

	CardDisplay card(.clk(CLOCK_50), .resetn(resetn), .level(SW[2:0]), .x_out(x), .y_out(y), .c_out(c), .plot(writeEn),
						  .reveal_q(Wire[0]), .reveal_w(Wire[1]), .reveal_e(Wire[2]), .reveal_r(Wire[3]), 
						  .reveal_a(Wire[4]), .reveal_s(Wire[5]), .reveal_d(Wire[6]), .reveal_f(Wire[7]), 
						  .reveal_z(Wire[8]), .reveal_x(Wire[9]), .reveal_c(Wire[10]), .reveal_v(Wire[11]), 
						  .checkMatch(checkMatch), .checkFinish(checkFinish),
						  .isCorrect(isCorrect), .isFinished(isFinished));
	
	
	// Timer output
	wire [3:0] counter_out0; wire [3:0] counter_out1;
	timer t(.clk(CLOCK_50), .resetn(timerResetn), .enable(timerEn), .counter_out0(counter_out0), .counter_out1(counter_out1));
	hex_decoder h0(.hex_digit(counter_out0[3:0]), .segments(HEX0[6:0]));
	hex_decoder h1(.hex_digit(counter_out1[3:0]), .segments(HEX1[6:0]));
	
	
	
	
/*	timer t(.clk(CLOCK_50), .ones_out(counter_out0[3:0]), .tens_out(counter_out1[3:0]), .enable(timerEn));
	hex_decoder h0(.hex_digit(counter_out0[3:0]), .segments(HEX0[6:0]));
	hex_decoder h1(.hex_digit(counter_out1[3:0]), .segments(HEX1[6:0]));*/
	
	// Keyboard stuff
/*	oneshot pulser(
		.pulse_out(read),
		.trigger_in(scan_ready),
		.clk(CLOCK_50)
	);
	keyboard kbd(
	  .keyboard_clk(PS2_CLK),
	  .keyboard_data(PS2_DAT),
	  .clock50(CLOCK_50),
	  .reset(!resetn),
	  .read(read),
	  .scan_ready(scan_ready),
	  .scan_code(scan_code)
	);*/
	hex_decoder h2(.hex_digit(scan_code[3:0]), .segments(HEX2[6:0]));
	hex_decoder h3(.hex_digit(scan_code[7:4]), .segments(HEX3[6:0]));
	
	hex_decoder h4(.hex_digit(state), .segments(HEX4[6:0]));
	
endmodule



// HEX Output
module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
