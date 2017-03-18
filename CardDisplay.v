module CardDisplay(
    input clk, input resetn,
	 input [2:0] level,
    output reg [7:0] x_out, output reg [6:0] y_out, output reg [2:0] c_out, output reg plot,

	 output reg [1:0] isCorrect, output reg [1:0] isFinished,
	 
	 input reveal_q, input reveal_w, input reveal_e, input reveal_r, // all enable signals
	 input reveal_a, input reveal_s, input reveal_d, input reveal_f, 
	 input reveal_z, input reveal_x, input reveal_c, input reveal_v,
	 input checkMatch, input checkFinish
    );
	 
	wire [2:0] blue, green, cyan, red, magenta, yellow;
	assign blue = 3'b001; assign green = 3'b010; assign cyan = 3'b011; assign red = 3'b100; assign magenta = 3'b101; assign yellow = 3'b110;
	
	reg [7:0] x1; reg [6:0] y1; reg [2:0] c1;
	reg [7:0] x2; reg [6:0] y2; reg [2:0] c2;
	reg [7:0] x3; reg [6:0] y3; reg [2:0] c3;
	reg [7:0] x4; 					 reg [2:0] c4;
										 reg [2:0] c5;
										 reg [2:0] c6;
										 reg [2:0] c7;
										 reg [2:0] c8;
										 reg [2:0] c9;
										 reg [2:0] c10;
										 reg [2:0] c11;
										 reg [2:0] c12;
	reg wipeEn;
	
	// Level chooser ALU
	always @(*) begin
		/*case(level)
			3'b001: begin //Level 1: 2x2
			
			x1 <= 8'd40; x2 <= 8'd80; x3 <= 0; x4 <= 0;
			y1 <= 7'd27; y2 <= 7'd64; y3 <= 0;
			c1 <= 3'b111; c2 <= 3'b111; c3 <= 3'b111; c4 <= 3'b111; c5 <= 0; c6 <= 0; c7 <= 0; c8 <= 0; c9 <= 0; c10 <= 0; c11 <= 0; c12 <= 0;
			end
			3'b010: begin //Level 2: 3x2
			x1 <= 8'd25; x2 <= 8'd60; x3 <= 8'd95; x4 <= 0;
			y1 <= 7'd27; y2 <= 7'd64; y3 <= 0;
			c1 <= 3'b111; c2 <= 3'b111; c3 <= 3'b111; c4 <= 3'b111; c5 <= 3'b111; c6 <= 3'b111; c7 <= 0; c8 <= 0; c9 <= 0; c10 <= 0; c11 <= 0; c12 <= 0;
			end
			3'b100: begin //Level 3: 4x3
			x1 <= 8'd16; x2 <= 8'd52; x3 <= 8'd88; x4 <= 8'd124;
			y1 <= 7'd15; y2 <= 7'd50; y3 <= 7'd85;
			c1 <= 3'b111; c2 <= 3'b111; c3 <= 3'b111; c4 <= 3'b111; c5 <= 3'b111; c6 <= 3'b111; c7 <= 3'b111; c8 <= 3'b111; c9 <= 3'b111; c10 <= 3'b111; c11 <= 3'b111; c12 <= 3'b111;
			end
			default: begin //Nothing selected or invalid level.
			x1 <= 0; x2 <= 0; x3 <= 0; x4 <= 0;
			y1 <= 0; y2 <= 0; y3 <= 0;
			c1 <= 0; c2 <= 0; c3 <= 0; c4 <= 0; c5 <= 0; c6 <= 0; c7 <= 0; c8 <= 0; c9 <= 0; c10 <= 0; c11 <= 0; c12 <= 0;
			end
		endcase */
		case(level)
			3'b001: begin //Level 1: 2x2
			
			x1 = 8'd40; x2 = 8'd100; x3 = 0; x4 = 0;
			y1 = 7'd27; y2 = 7'd74; y3 = 0;
			c1 = 3'b111; c2 = 3'b111; c3 = 3'b111; c4 = 3'b111; c5 = 0; c6 = 0; c7 = 0; c8 = 0; c9 = 0; c10 = 0; c11 = 0; c12 = 0;
			end
			3'b010: begin //Level 2: 3x2
			x1 = 8'd25; x2 = 8'd70; x3 = 8'd115; x4 = 0;
			y1 = 7'd27; y2 = 7'd74; y3 = 0;
			c1 = 3'b111; c2 = 3'b111; c3 = 3'b111; c4 = 3'b111; c5 = 3'b111; c6 = 3'b111; c7 = 0; c8 = 0; c9 = 0; c10 = 0; c11 = 0; c12 = 0;
			end
			3'b100: begin //Level 3: 4x3
			x1 = 8'd16; x2 = 8'd52; x3 = 8'd88; x4 = 8'd124;
			y1 = 7'd15; y2 = 7'd50; y3 = 7'd85;
			c1 = 3'b111; c2 = 3'b111; c3 = 3'b111; c4 = 3'b111; c5 = 3'b111; c6 = 3'b111; c7 = 3'b111; c8 = 3'b111; c9 = 3'b111; c10 = 3'b111; c11 = 3'b111; c12 = 3'b111;
			end
			default: begin //Nothing selected or invalid level.
			x1 = 0; x2 = 0; x3 = 0; x4 = 0;
			y1 = 0; y2 = 0; y3 = 0;
			c1 = 0; c2 = 0; c3 = 0; c4 = 0; c5 = 0; c6 = 0; c7 = 0; c8 = 0; c9 = 0; c10 = 0; c11 = 0; c12 = 0;
			end
		endcase 
	end
	 
	 
	 // (5 + 5) bit counter for a 20x20 card
	 reg [9:0] count;
	 always @(posedge clk) begin
			if (level == 3'b000) count <= 0;
			else count <= count + 1;
	 end
	 
	 //counter for black screen wipe
	 reg [14:0] countW;
	 always @(posedge clk) begin
			if (level != 3'b000) countW <= 0;
			else countW <= countW + 1;
	 end
	 
	 // check match
	 always @(*)begin
		isCorrect = 2'd0;
		if (checkMatch) begin
			case(level)
				3'b001: begin
					if (reveal_q == reveal_s && reveal_w == reveal_a) isCorrect = 2'd1;
					else isCorrect = 2'd2;
				end
				3'b010: begin
					if (reveal_q == reveal_s && reveal_w == reveal_e && reveal_a == reveal_d) isCorrect = 2'd1;
					else isCorrect = 2'd2;
				end
				3'b100: begin
					if (reveal_q == reveal_a && reveal_w == reveal_c && reveal_e == reveal_z && reveal_r == reveal_d && reveal_f == reveal_x && reveal_s == reveal_v) isCorrect = 2'd1;
					else isCorrect = 2'd2;
				end
			endcase
		end
	 end
	 
	 // checkfinish
	 always @(*)begin
		isFinished = 2'd0;
		if (checkFinish) begin
			case(level)
				3'b001: begin
					if (reveal_q == 1 && reveal_w == 1 && reveal_a == 1 && reveal_s == 1) isFinished = 2'd1;
					else isFinished = 2'd2;
				end
				3'b010: begin
					if (reveal_q == 1 && reveal_w == 1 && reveal_e == 1 && reveal_a == 1 && reveal_s == 1 && reveal_d == 1) isFinished = 2'd1;
					else isFinished = 2'd2;
				end
				3'b100: begin
					if (reveal_q == 1 && reveal_w == 1 && reveal_e == 1 && reveal_r == 1 && reveal_a == 1 && reveal_s == 1 && reveal_d == 1 && reveal_f == 1 && reveal_z == 1 && reveal_x == 1 && reveal_c == 1 && reveal_v == 1) isFinished = 2'd1;
					else isFinished = 2'd2;
				end
			endcase
		end
	 end	 

	 reg [4:0] n;
	 // Output result register
    always @ (posedge clk) begin
	 case (level)
		3'b001: begin
		plot <= 1;
			if (count == 0)
				n <= n + 1;
			if (n == 5'd2) begin
				if (reveal_q == 1) c_out <= 3'b001;
				else c_out <= c1;
				x_out <= x1 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd4) begin
			if (reveal_w == 1) c_out <= 3'b010;
				else c_out <= c2;
				x_out <= x2 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd6) begin
				if (reveal_a == 1) c_out <= 3'b010;
				else c_out <= c3;
				x_out <= x1 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd8) begin
				if (reveal_s == 1) c_out <= 3'b001;
				else c_out <= c4;
				x_out <= x2 + count[4:0];
				y_out <= y2 + count[9:5];
			end
		end
		
		3'b010: begin
		plot <= 1;
			if (count == 0)
				n <= n + 1;
			if (n == 5'd2) begin
				if (reveal_q == 1) c_out <= 3'b001;
				else c_out <= c1;
				x_out <= x1 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd4) begin
				if (reveal_w == 1) c_out <= 3'b010;
				else c_out <= c2;
				x_out <= x2 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd6) begin
				if (reveal_e == 1) c_out <= 3'b010;
				else c_out <= c3;
				x_out <= x3 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd8) begin
				if (reveal_a == 1) c_out <= 3'b011;
				else c_out <= c4;
				x_out <= x1 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd10) begin
				if (reveal_s == 1) c_out <= 3'b001;
				else c_out <= c5;
				x_out <= x2 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd12) begin
				if (reveal_d == 1) c_out <= 3'b011;
				else c_out <= c6;
				x_out <= x3 + count[4:0];
				y_out <= y2 + count[9:5];
			end
		end
			
		3'b100: begin
		plot <= 1;
			if (count == 0)
				n <= n + 1;
			if (n == 5'd2) begin
				if (reveal_q == 1) c_out <= 3'b001;
				else c_out <= c1;
				x_out <= x1 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd4) begin
				if (reveal_w == 1) c_out <= 3'b010;
				else c_out <= c2;
				x_out <= x2 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd6) begin
				if (reveal_e == 1) c_out <= 3'b011;
				else c_out <= c3;
				x_out <= x3 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd8) begin
				if (reveal_r == 1) c_out <= 3'b100;
				else c_out <= c4;
				x_out <= x4 + count[4:0];
				y_out <= y1 + count[9:5];
			end
			else if (n == 5'd10) begin
				if (reveal_a == 1) c_out <= 3'b001;
				else c_out <= c5;
				x_out <= x1 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd12) begin
				if (reveal_s == 1) c_out <= 3'b110;
				else c_out <= c6;
				x_out <= x2 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd14) begin
				if (reveal_d == 1) c_out <= 3'b100;
				else c_out <= c7;
				x_out <= x3 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd16) begin
				if (reveal_f == 1) c_out <= 3'b101;
				else c_out <= c8;
				x_out <= x4 + count[4:0];
				y_out <= y2 + count[9:5];
			end
			else if (n == 5'd18) begin
				if (reveal_z == 1) c_out <= 3'b011;
				else c_out <= c9;
				x_out <= x1 + count[4:0];
				y_out <= y3 + count[9:5];
			end
			else if (n == 5'd20) begin
				if (reveal_x == 1) c_out <= 3'b101;
				else c_out <= c10;
				x_out <= x2 + count[4:0];
				y_out <= y3 + count[9:5];
			end
			else if (n == 5'd22) begin
				if (reveal_c == 1) c_out <= 3'b010;
				else c_out <= c11;
				x_out <= x3 + count[4:0];
				y_out <= y3 + count[9:5];
			end
			else if (n == 5'd24) begin
				if (reveal_v == 1) c_out <= 3'b110;
				else c_out <= c12;
				x_out <= x4 + count[4:0];
				y_out <= y3 + count[9:5];
			end
		end
		
		default: begin
			plot <=  1;
			n <= 0;
			if (!resetn)begin
				c_out <= 3'b000;
				x_out <= countW[7:0];
				y_out <= countW[14:8];
			end
			else begin
				c_out <= 3'b000;
				x_out <= 0;
				y_out <= 0;
			end
		end
	  endcase
	 end
endmodule
