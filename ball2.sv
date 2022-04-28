/*
	Player 2 tank object
*/

module ball2 (
	input Reset, frame_clk, was_hit,
	input [7:0] keycode,
	output [9:0] BallX, BallY, BallS,
	output [1:0] direction 
);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	logic [1:0] direction_delayed; // 00 = Facing Left, 01 = Right, 10 = Down, 11 = Up
	 
    parameter [9:0] Ball_X_Center=480;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=1;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=1;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge was_hit or posedge frame_clk )
    begin: Move_Ball
        if (Reset || was_hit)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
			direction_delayed <= 2'b00;
        end
           
        else 
        begin 
			case (keycode)
				8'd80 : begin
							if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min ) // Ball is at the Left edge
								begin
				  					Ball_X_Motion <= 0;
								  	Ball_Y_Motion <= 0;
								end
							else 
								begin
									Ball_X_Motion <= -1;//A
									Ball_Y_Motion <= 0;
								end
							direction_delayed <= 2'b00;
						end
					        
				8'd79 : begin	
				        	if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge
					  			begin
									Ball_X_Motion <= 0;  // 2's complement.
									Ball_Y_Motion <= 0;
								end
							else
								begin
									Ball_X_Motion <= 1;//D
						  			Ball_Y_Motion <= 0;
								end
							direction_delayed <= 2'b01;
						end 
				8'd81 : begin
							if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge
					  			begin
									Ball_Y_Motion <= 0;  // 2's complement.
									Ball_X_Motion <= 0;
								end
							else
								begin
					        		Ball_Y_Motion <= 1;//S
							  		Ball_X_Motion <= 0;
								end
							direction_delayed <= 2'b10;
						end  
				8'd82 : begin
							if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge
					  			begin
									Ball_Y_Motion <= 0;
									Ball_X_Motion <= 0;
								end
							else
								begin
									Ball_Y_Motion <= -1;//W
							  		Ball_X_Motion <= 0;
								end
							direction_delayed <= 2'b11;
						end	  
				default: begin
							Ball_X_Motion <= 0;
							Ball_Y_Motion <= 0;
						 end
			   endcase
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					
		end  
    end
       
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign BallS = Ball_Size;
    assign direction = direction_delayed;

endmodule
