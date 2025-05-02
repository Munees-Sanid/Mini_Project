module traffic_light_controller(
	input wire clk,
	output reg red,
	output reg yellow,
	output reg green
);

	reg [2:0] state = 3'b000;
	
	always @(posedge clk) begin
		case(state)
			3'b000: begin //Red
				red <= 1;
				yellow <= 0;
				green <= 0;
				state <=3'b001;
			end
			
			3'b001: begin //Red-Yellow Transition
				red <= 1;
				yellow <= 1;
				green <= 0;
				state <= 3'b010;
			end
			
			3'b010 : begin //Green
				red <= 0;
				yellow <= 0;
				green <= 1;
				state <= 3'b011;
			end
			
			3'b011 :  begin //Yellow
				red <= 0;
				yellow <= 1;
				green <= 0;
				state <= 3'b000;
			end
		endcase
	end
	
endmodule
