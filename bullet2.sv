//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module bullet2 (
	input Reset, frame_clk,
	input [7:0] keycode,
	input [9:0] BallX, BallY, BallS,
    output [9:0]  BulletX, BulletY, BulletS,
	output bullet_on
);
    
    logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size;
	 
    parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet_X_Step=1;      // Step size on the X axis
    parameter [9:0] Bullet_Y_Step=1;      // Step size on the Y axis

    assign Bullet_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Bullet_Y_Motion <= 10'd0; //Ball_Y_Step;
			Bullet_X_Motion <= 10'd0; //Ball_X_Step;
			Bullet_Y_Pos <= BallY + BallS;
			Bullet_X_Pos <= BallX + BallS;
        end
           
        else 
        begin 
				if ( (Bullet_Y_Pos + Bullet_Size) >= Bullet_Y_Max )  // Ball is at the bottom edge
					Bullet_Y_Motion <= 0;
					  
				else if ( (Bullet_Y_Pos - Bullet_Size) <= Bullet_Y_Min )  // Ball is at the top edge
					Bullet_Y_Motion <= 0;
					  
				else if ( (Bullet_X_Pos + Bullet_Size) >= Bullet_X_Max )  // Ball is at the Right edge
					Bullet_X_Motion <= 0;
					  
				else if ( (Bullet_X_Pos - Bullet_Size) <= Bullet_X_Min )  // Ball is at the Left edge
					Bullet_X_Motion <= 0;
					  
				else 
					Bullet_Y_Motion <= 0;  // Ball is somewhere in the middle, don't bounce, just keep moving

				case (keycode)
					8'd88:
						Bullet_X_Motion <= -2;
					default: 
						Bullet_X_Motion <= 0;
				endcase
				 
				if (bullet_on == 1'b0)
				begin
					Bullet_X_Pos <= (BallX + BallS);
					Bullet_Y_Pos <= (BallY + BallS);
				end

				else
				begin
					Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);
					Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion); 
				end
		end  
    end

	always_comb
	begin
		if (Bullet_X_Motion == 0 && Bullet_Y_Motion == 0)
			bullet_on = 1'b0;
		else
			bullet_on = 1'b1;
	end

    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   
    assign BulletS = Bullet_Size;
    

endmodule
