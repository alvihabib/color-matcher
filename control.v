module control(
    input clk, input resetn,
    input [2:0] level, input go,
	 input [7:0] keyboard, input [1:0] isCorrect, input [1:0] isFinished,
	 output reg reveal_q, output reg reveal_w, output reg reveal_e, output reg reveal_r,
	 output reg reveal_a, output reg reveal_s, output reg reveal_d, output reg reveal_f, 
	 output reg reveal_z, output reg reveal_x, output reg reveal_c, output reg reveal_v,
	 output reg checkMatch, output reg checkFinish,
	 output reg timerEn, output reg timerResetn, output reg [3:0] state
    );
	 
	 // Go Signals
	 reg switchGo;
	 always @(*) begin
		//go signal for level choosing
		if (level == 3'b001 || level == 3'b010 || level == 3'b100) switchGo = 1;
		else switchGo = 0;
	 end

    reg [3:0] current_state, next_state; 
    
    localparam  S_CHOOSE_LEVEL  = 4'd0,
                S_FIRST_CARD    = 4'd1,
					 S_FIRST_WAIT	  = 4'd2,
                S_SECOND_CARD   = 4'd3,
					 S_SECOND_WAIT	  = 4'd4,
					 S_CHECK			  = 4'd5,
					 // Incorrect match
                S_INCORRECT     = 4'd6,
					 S_INCORRECT_WAIT= 4'd7,
                // Correct match
					 S_CORRECT		  = 4'd8,
					 S_IS_FINISHED	  = 4'd9;
					 
    
    // Next state logic aka our state table
    always @(*)
    begin: state_table 
            case (current_state)
                S_CHOOSE_LEVEL: next_state = switchGo ? S_FIRST_CARD : S_CHOOSE_LEVEL; // Loop in current state until value is input
                S_FIRST_CARD: next_state = go ? S_FIRST_WAIT : S_FIRST_CARD;
					 S_FIRST_WAIT: next_state = go ? S_FIRST_WAIT : S_SECOND_CARD;
                S_SECOND_CARD: next_state = go ? S_SECOND_WAIT : S_SECOND_CARD;
					 S_SECOND_WAIT: next_state = go ? S_SECOND_WAIT : S_CHECK;
					 S_CHECK: begin
						if (isCorrect == 2'd2) next_state = S_INCORRECT;
						else if (isCorrect == 2'd1) next_state = S_CORRECT;
						else next_state = S_CHECK;
					 end
					 // Incorrect
					 S_INCORRECT: next_state = go ? S_INCORRECT_WAIT : S_INCORRECT;
					 S_INCORRECT_WAIT: next_state = go ? S_INCORRECT_WAIT : S_FIRST_CARD;
					 // Correct 
                S_CORRECT: begin
						if (isFinished == 2'd1) next_state = S_IS_FINISHED;
						else if (isFinished == 2'd2) next_state = S_FIRST_CARD;
						else next_state = S_CORRECT;
					 end
					 // Finished
					 S_IS_FINISHED: next_state = switchGo ? S_IS_FINISHED : S_CHOOSE_LEVEL;
            default: begin
					next_state = S_CHOOSE_LEVEL;
				end
        endcase
    end // state_table
   
		

	 reg [7:0] temp1;
	 reg [7:0] temp2;
    // Output logic aka all of our datapath control signals
    always @(posedge clk)
    begin: enable_signals
        // By default make all our signals 0
		  if (!resetn)begin
			reveal_q <= 0; reveal_w <= 0; reveal_e <= 0; reveal_r <= 0;
			reveal_a <= 0; reveal_s <= 0; reveal_d <= 0; reveal_f <= 0; 
			reveal_z <= 0; reveal_x <= 0; reveal_c <= 0; reveal_v <= 0;
			checkMatch <= 0; checkFinish <= 0;
			timerEn <= 0;
			timerResetn <= 0;
			temp1 <= 8'h00;
			temp2 <= 8'h00;
		  end

        case (current_state)
            S_CHOOSE_LEVEL: begin
					reveal_q <= 0; reveal_w <= 0; reveal_e <= 0; reveal_r <= 0;
					reveal_a <= 0; reveal_s <= 0; reveal_d <= 0; reveal_f <= 0; 
					reveal_z <= 0; reveal_x <= 0; reveal_c <= 0; reveal_v <= 0;
					checkMatch <= 0; checkFinish <= 0;
					timerEn <= 0;
					timerResetn <= 0;
					temp1 <= 8'h00;
					temp2 <= 8'h00;
state <= 4'd1;
				end
				S_FIRST_CARD: begin
state <= 4'd2;
					timerEn <= 1;
					timerResetn <= 1;
					checkFinish <= 0;
					temp1 <= keyboard;
//					case (level)
//						3'b001: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h1C || keyboard == 8'h1B)
//								temp1 <= keyboard;
//						end
//						3'b010: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h24 || keyboard == 8'h1C || keyboard == 8'h1B || keyboard == 8'h23)
//								temp1 <= keyboard;
//						end
//						3'b100: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h24 || keyboard == 8'h2D || keyboard == 8'h1C || keyboard == 8'h1B || keyboard == 8'h23 || keyboard == 8'h2B || keyboard == 8'h1A || keyboard == 8'h22 || keyboard == 8'h21 || keyboard == 8'h2A)
//								temp1 <= keyboard;
//						end
//					endcase
				end
				S_FIRST_WAIT: begin
state <= 4'd3;
					case(temp1)
						8'h15: reveal_q <= 1;
						8'h1D: reveal_w <= 1;
						8'h24: reveal_e <= 1;
						8'h2D: reveal_r <= 1;
						8'h1C: reveal_a <= 1;
						8'h1B: reveal_s <= 1;
						8'h23: reveal_d <= 1;
						8'h2B: reveal_f <= 1;
						8'h1A: reveal_z <= 1;
						8'h22: reveal_x <= 1;
						8'h21: reveal_c <= 1;
						8'h2A: reveal_v <= 1;
					endcase
				end
				S_SECOND_CARD: begin
state <= 4'd4;
					temp2 <= keyboard;
//					case (level)
//						3'b001: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h1C || keyboard == 8'h1B)
//								temp2 <= keyboard;
//						end
//						3'b010: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h24 || keyboard == 8'h1C || keyboard == 8'h1B || keyboard == 8'h23)
//								temp2 <= keyboard;
//						end
//						3'b100: begin
//							if (keyboard == 8'h15 || keyboard == 8'h1D || keyboard == 8'h24 || keyboard == 8'h2D || keyboard == 8'h1C || keyboard == 8'h1B || keyboard == 8'h23 || keyboard == 8'h2B || keyboard == 8'h1A || keyboard == 8'h22 || keyboard == 8'h21 || keyboard == 8'h2A)
//								temp2 <= keyboard;
//						end
//					endcase
				end
				S_SECOND_WAIT: begin
state <= 4'd5;
					case(temp2)
						8'h15: reveal_q <= 1;
						8'h1D: reveal_w <= 1;
						8'h24: reveal_e <= 1;
						8'h2D: reveal_r <= 1;
						8'h1C: reveal_a <= 1;
						8'h1B: reveal_s <= 1;
						8'h23: reveal_d <= 1;
						8'h2B: reveal_f <= 1;
						8'h1A: reveal_z <= 1;
						8'h22: reveal_x <= 1;
						8'h21: reveal_c <= 1;
						8'h2A: reveal_v <= 1;
					endcase
				end
				S_CHECK: begin
state <= 4'd6;
					checkMatch <= 1;
				end
				S_INCORRECT: begin
state <= 4'd7;
					checkMatch <= 0;
				end
				S_INCORRECT_WAIT: begin
state <= 4'd8;
					case(temp1)
						8'h15: reveal_q <= 0;
						8'h1D: reveal_w <= 0;
						8'h24: reveal_e <= 0;
						8'h2D: reveal_r <= 0;
						8'h1C: reveal_a <= 0;
						8'h1B: reveal_s <= 0;
						8'h23: reveal_d <= 0;
						8'h2B: reveal_f <= 0;
						8'h1A: reveal_z <= 0;
						8'h22: reveal_x <= 0;
						8'h21: reveal_c <= 0;
						8'h2A: reveal_v <= 0;
					endcase
					case(temp2)
						8'h15: reveal_q <= 0;
						8'h1D: reveal_w <= 0;
						8'h24: reveal_e <= 0;
						8'h2D: reveal_r <= 0;
						8'h1C: reveal_a <= 0;
						8'h1B: reveal_s <= 0;
						8'h23: reveal_d <= 0;
						8'h2B: reveal_f <= 0;
						8'h1A: reveal_z <= 0;
						8'h22: reveal_x <= 0;
						8'h21: reveal_c <= 0;
						8'h2A: reveal_v <= 0;
					endcase
				end
				S_CORRECT: begin
state <= 4'd9;
					checkMatch <= 0;
					checkFinish <= 1;
				end
				S_IS_FINISHED: begin
state <= 4'd10;
					checkFinish <= 0;
					timerEn <= 0;
				end
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
		if (!resetn)
			current_state <= S_CHOOSE_LEVEL;
		else
			current_state <= next_state;
    end // state_FFS
	 
endmodule

