/*
	Player 2 tank object
*/

module tank2 (
	input Reset, frame_clk,
	input [7:0] keycode,
	input speed_upgrade,
	input [3:0] barrier_collision,
	output logic [9:0] BallX, BallY, BallS,
	output logic [1:0] direction 
);
    
    logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size;
	logic [1:0] direction_delayed; // 00 = Facing Left, 01 = Right, 10 = Down, 11 = Up
	 
    parameter [9:0] Ball_X_Center=480;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=1;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=1;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
			direction_delayed <= 2'b00;
        end
           
        else 
        begin 
			case (keycode)
				8'd80 : begin
							// Ball is at the Left edge or hitting the right wall of a barrier
							if ( ((Ball_X_Pos - Ball_Size) <= Ball_X_Min) ||
								 barrier_collision[1] ) 
								begin
				  					Ball_X_Pos <= Ball_X_Pos;
								  	Ball_Y_Pos <= Ball_Y_Pos;
								end
							else 
								begin
									if(speed_upgrade)
										Ball_X_Pos <= Ball_X_Pos - 3;//A
									else
										Ball_X_Pos <= Ball_X_Pos - 1;//A
									Ball_Y_Pos <= Ball_Y_Pos;
								end
							direction_delayed <= 2'b00;
						end
					        
				8'd79 : begin	
							// Ball is at the Right edge or is hitting the left wall of a barrier
				        	if ( ((Ball_X_Pos + Ball_Size) >= Ball_X_Max) ||
							     barrier_collision[0] )  
					  			begin
									Ball_X_Pos <= Ball_X_Pos;  
									Ball_Y_Pos <= Ball_Y_Pos;
								end
							else
								begin
									if (speed_upgrade)
										Ball_X_Pos <= Ball_X_Pos + 3;
									else
										Ball_X_Pos <= Ball_X_Pos + 1; //D
						  			Ball_Y_Pos <= Ball_Y_Pos;
								end
							direction_delayed <= 2'b01;
						end 
				8'd81 : begin
							// Ball is at the bottom edge or is hitting the top wall of a barrier
							if ( ((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max) ||
							     barrier_collision[2] )  
					  			begin
									Ball_Y_Pos <= Ball_Y_Pos; 
									Ball_X_Pos <= Ball_X_Pos;
								end
							else
								begin
					        		if(speed_upgrade)
										Ball_Y_Pos <= Ball_Y_Pos + 3;//S
							  		else
									  	Ball_Y_Pos <= Ball_Y_Pos + 1;
									Ball_X_Pos <= Ball_X_Pos;
								end
							direction_delayed <= 2'b10;
						end  
				8'd82 : begin
							// Ball is at the top edge or is hitting the bottom wall of a barrier
							if ( ((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min) || 
							     barrier_collision[3])  
					  			begin
									Ball_Y_Pos <= Ball_Y_Pos;
									Ball_X_Pos <= Ball_X_Pos;
								end
							else
								begin
									if (speed_upgrade)
										Ball_Y_Pos <= Ball_Y_Pos - 3;
									else
										Ball_Y_Pos <= Ball_Y_Pos - 1;//W
							  		Ball_X_Pos <= Ball_X_Pos;
								end
							direction_delayed <= 2'b11;
						end	  
				default: begin
							Ball_X_Pos <= Ball_X_Pos;
							Ball_Y_Pos <= Ball_Y_Pos;
						 end
			   endcase
				 	
		end  
    end
       
    assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;
    assign direction = direction_delayed;

endmodule
