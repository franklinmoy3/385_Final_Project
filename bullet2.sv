/*
	Player 2 bullet object
*/

module bullet2 (
	input Reset, frame_clk,
	input [1:0] direction,
	input [7:0] keycode,
	input [9:0] BallX, BallY, BallS,
	input barrier_collision, player_hit,
    output [9:0]  BulletX, BulletY, BulletS,
	output bullet_on
);
    
    logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size;
	logic [1:0] direction_latched, fire_direction;
	logic bullet_toggle, fire_button_released, ready_to_fire;
	 
    parameter [9:0] Bullet_X_Min=1;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=1;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet_X_Step=12;      // Step size on the X axis
    parameter [9:0] Bullet_Y_Step=12;      // Step size on the Y axis

    assign Bullet_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Bullet_Y_Motion <= 10'd0; //Ball_Y_Step;
			Bullet_X_Motion <= 10'd0; //Ball_X_Step;
			Bullet_Y_Pos <= BallY + BallS;
			Bullet_X_Pos <= BallX + BallS;
			bullet_toggle <= 1'b0;
			fire_button_released <= 1'b1;
        end
           
        else 
        begin 
				if ( (Bullet_Y_Pos + Bullet_Size) >= Bullet_Y_Max )  // Ball is at the bottom edge
					bullet_toggle <= 1'b0;
					  
				else if ( (Bullet_Y_Pos - Bullet_Size) <= Bullet_Y_Min )  // Ball is at the top edge
					bullet_toggle <= 1'b0;
					  
				else if ( (Bullet_X_Pos + Bullet_Size) >= Bullet_X_Max )  // Ball is at the Right edge
					bullet_toggle <= 1'b0;
					  
				else if ( (Bullet_X_Pos - Bullet_Size) <= Bullet_X_Min )  // Ball is at the Left edge
					bullet_toggle <= 1'b0;
				
				else if (barrier_collision || player_hit)
					bullet_toggle <= 1'b0;
					  
				else
				begin
					case (keycode)
						8'd88:
						begin
							if (ready_to_fire)
							begin
								bullet_toggle <= 1'b1;
								direction_latched <= direction;
							end
							fire_button_released <= 1'b0;
						end
						default: 
							fire_button_released <= 1'b1;
					endcase
				end

				if (bullet_on == 1'b0)
				begin
					Bullet_X_Pos <= BallX;
					Bullet_Y_Pos <= BallY;
				end

				else
				begin
					case (fire_direction)
						2'b00:
							begin
								Bullet_X_Pos <= (Bullet_X_Pos - Bullet_X_Step);
								Bullet_Y_Pos <= Bullet_Y_Pos;
							end
						2'b01:
							begin
								Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Step);
								Bullet_Y_Pos <= Bullet_Y_Pos;
							end
						2'b10:
							begin
								Bullet_X_Pos <= Bullet_X_Pos;
								Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Step);
							end
						2'b11:
							begin
								Bullet_X_Pos <= Bullet_X_Pos;
								Bullet_Y_Pos <= (Bullet_Y_Pos - Bullet_Y_Step);
							end
					endcase 
				end
		end  
    end

	always_comb
	begin
		if (bullet_toggle)
			bullet_on = 1'b1;
		else
			bullet_on = 1'b0;
		ready_to_fire = fire_button_released & ~bullet_on;
		fire_direction = direction_latched;
	end

    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   
    assign BulletS = Bullet_Size;
    

endmodule
