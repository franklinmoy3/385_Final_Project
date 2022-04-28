/*
	Barrier object class for collision detection
*/

module barrier (
	input Reset, frame_clk,
	input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
	input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size,
	input [9:0] BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved,
	output [3:0] player_1_collision, player_2_collision,
	output bullet_1_collision, bullet_2_collision
);

	// Tank Collisions (one-hot): 0000 = none, 0001 = left wall, 0010 = right wall, 0100 = top wall, 1000 = bottom wall
	logic [3:0] p1_collision_latched, p2_collision_latched;
	
	logic b1_collision_latched, b2_collision_latched; 
    
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Collision_Detector
        if (Reset)  // Asynchronous Reset
        begin 
            p1_collision_latched <= 4'b0; 
			p2_collision_latched <= 4'b0; 
			b1_collision_latched <= 1'b0;
			b2_collision_latched <= 1'b0; 
        end
           
        else 
        begin 
			
			// P1's right side hits barrier
            if ( (BallX + Ball_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (BallX + Ball_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (BallY <= BarrierY + Barrier_Height_Halved) &&
                 (BallY >= BarrierY - Barrier_Height_Halved) )
                    p1_collision_latched <= 4'b0001;

            // P1's left side hits barrier
            else if ( (BallX - Ball_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (BallX - Ball_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (BallY <= BarrierY + Barrier_Height_Halved) &&
                 (BallY >= BarrierY - Barrier_Height_Halved) )
                    p1_collision_latched <= 4'b0010;
            
            // P1's bottom side hits barrier
            else if ( (BallY + Ball_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (BallY + Ball_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (BallX <= BarrierX + Barrier_Length_Halved) &&
                 (BallX >= BarrierX - Barrier_Length_Halved) )
                    p1_collision_latched <= 4'b0100;
            
            // P1's top side hits barrier
            else if ( (BallY - Ball_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (BallY - Ball_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (BallX <= BarrierX + Barrier_Length_Halved) &&
                 (BallX >= BarrierX - Barrier_Length_Halved) )
                    p1_collision_latched <= 4'b1000;

            else
                p1_collision_latched <= 4'b0;

			// P2's right side hits barrier
            if ( (Ball2X + Ball_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (Ball2X + Ball_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (Ball2Y <= BarrierY + Barrier_Height_Halved) &&
                 (Ball2Y >= BarrierY - Barrier_Height_Halved) )
                    p2_collision_latched <= 4'b0001;

            // P2's left side hits barrier
            else if ( (Ball2X - Ball_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (Ball2X - Ball_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (Ball2Y <= BarrierY + Barrier_Height_Halved) &&
                 (Ball2Y >= BarrierY - Barrier_Height_Halved) )
                    p2_collision_latched <= 4'b0010;
            
            // P2's bottom side hits barrier
            else if ( (Ball2Y + Ball_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (Ball2Y + Ball_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (Ball2X <= BarrierX + Barrier_Length_Halved) &&
                 (Ball2X >= BarrierX - Barrier_Length_Halved) )
                    p2_collision_latched <= 4'b0100;
            
            // P2's top side hits barrier
            else if ( (Ball2Y - Ball_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (Ball2Y - Ball_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (Ball2X <= BarrierX + Barrier_Length_Halved) &&
                 (Ball2X >= BarrierX - Barrier_Length_Halved) )
                    p2_collision_latched <= 4'b1000;

            else
                p2_collision_latched <= 4'b0;

			// P1 bullet's right side hits barrier
            if ( (BulletX + Bullet_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (BulletX + Bullet_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (BulletY <= BarrierY + Barrier_Height_Halved) &&
                 (BulletY >= BarrierY - Barrier_Height_Halved) )
                    b1_collision_latched <= 1'b1;

            // P1 bullet's left side hits barrier
            else if ( (BulletX - Bullet_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (BulletX - Bullet_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (BulletY <= BarrierY + Barrier_Height_Halved) &&
                 (BulletY >= BarrierY - Barrier_Height_Halved) )
                    b1_collision_latched <= 1'b1;
            
            // P1 bullet's bottom side hits barrier
            else if ( (BulletY + Bullet_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (BulletY + Bullet_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (BulletX <= BarrierX + Barrier_Length_Halved) &&
                 (BulletX >= BarrierX - Barrier_Length_Halved) )
                    b1_collision_latched <= 1'b1;
            
            // P1 bullet's top side hits barrier
            else if ( (BulletY - Bullet_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (BulletY - Bullet_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (BulletX <= BarrierX + Barrier_Length_Halved) &&
                 (BulletX >= BarrierX - Barrier_Length_Halved) )
                    b1_collision_latched <= 1'b1;

            else
                b1_collision_latched <= 1'b0;

            // P2 bullet's right side hits barrier
            if ( (Bullet2X + Bullet_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (Bullet2X + Bullet_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (Bullet2Y <= BarrierY + Barrier_Height_Halved) &&
                 (Bullet2Y >= BarrierY - Barrier_Height_Halved) )
                    b2_collision_latched <= 1'b1;

            // P2 bullet's left side hits barrier
            else if ( (Bullet2X - Bullet_Size) >= (BarrierX - Barrier_Length_Halved) &&
                 (Bullet2X - Bullet_Size) <= (BarrierX + Barrier_Length_Halved) &&
                 (Bullet2Y <= BarrierY + Barrier_Height_Halved) &&
                 (Bullet2Y >= BarrierY - Barrier_Height_Halved) )
                    b2_collision_latched <= 1'b1;
            
            // P2 bullet's bottom side hits barrier
            else if ( (Bullet2Y + Bullet_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (Bullet2Y + Bullet_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (Bullet2X <= BarrierX + Barrier_Length_Halved) &&
                 (Bullet2X >= BarrierX - Barrier_Length_Halved) )
                    b2_collision_latched <= 1'b1;
            
            // P2 bullet's top side hits barrier
            else if ( (Bullet2Y - Bullet_Size) >= (BarrierY - Barrier_Height_Halved) &&
                 (Bullet2Y - Bullet_Size) <= (BarrierY + Barrier_Height_Halved) &&
                 (Bullet2X <= BarrierX + Barrier_Length_Halved) &&
                 (Bullet2X >= BarrierX - Barrier_Length_Halved) )
                    b2_collision_latched <= 1'b1;

            else
                b2_collision_latched <= 1'b0;

		end  
    end
       
    assign player_1_collision = p1_collision_latched;
    assign player_2_collision = p2_collision_latched;
	assign bullet_1_collision = b1_collision_latched;
    assign bullet_2_collision = b2_collision_latched;
    
endmodule
