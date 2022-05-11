/*
	Barrier object class for collision detection
*/

module barrier (
	input Reset, frame_clk,
	input [9:0] BallX, BallY, Ball2X, Ball2Y, Ball_Size,
	input [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size,
	input [9:0] BarrierX, BarrierY, Barrier_Height_Halved, Barrier_Length_Halved,
	output logic [3:0] player_1_collision, player_2_collision,
	output logic bullet_1_collision, bullet_2_collision
);

	// Tank Collisions (one-hot): 0000 = none, 0001 = left wall, 0010 = right wall, 0100 = top wall, 1000 = bottom wall
	
    always_comb
    begin: Collision_Detector
        if (Reset)  // Asynchronous Reset
        begin 
            player_1_collision = 4'b0; 
			player_2_collision = 4'b0; 
			bullet_1_collision = 1'b0;
			bullet_2_collision = 1'b0; 
        end
           
        else 
        begin 
			
        // P1's right side hits barrier
            if ( (BallX + Ball_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (BallX + Ball_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (BallY <= BarrierY + Barrier_Height_Halved + 5) &&
                 (BallY >= BarrierY - Barrier_Height_Halved - 5) )
                    player_1_collision = 4'b0001;

            // P1's left side hits barrier
            else if ( (BallX - Ball_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (BallX - Ball_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (BallY <= BarrierY + Barrier_Height_Halved + 5) &&
                 (BallY >= BarrierY - Barrier_Height_Halved - 5) )
                    player_1_collision = 4'b0010;
            
            // P1's bottom side hits barrier
            else if ( (BallY + Ball_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (BallY + Ball_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (BallX <= BarrierX + Barrier_Length_Halved + 5) &&
                 (BallX >= BarrierX - Barrier_Length_Halved - 5) )
                    player_1_collision = 4'b0100;
            
            // P1's top side hits barrier
            else if ( (BallY - Ball_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (BallY - Ball_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (BallX <= BarrierX + Barrier_Length_Halved + 5) &&
                 (BallX >= BarrierX - Barrier_Length_Halved - 5) )
                    player_1_collision = 4'b1000;

            else
                player_1_collision = 4'b0;

			// P2's right side hits barrier
            if ( (Ball2X + Ball_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (Ball2X + Ball_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (Ball2Y <= BarrierY + Barrier_Height_Halved + 5) &&
                 (Ball2Y >= BarrierY - Barrier_Height_Halved - 5) )
                    player_2_collision = 4'b0001;

            // P2's left side hits barrier
            else if ( (Ball2X - Ball_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (Ball2X - Ball_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (Ball2Y <= BarrierY + Barrier_Height_Halved + 5) &&
                 (Ball2Y >= BarrierY - Barrier_Height_Halved - 5) )
                    player_2_collision = 4'b0010;
            
            // P2's bottom side hits barrier
            else if ( (Ball2Y + Ball_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (Ball2Y + Ball_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (Ball2X <= BarrierX + Barrier_Length_Halved + 5) &&
                 (Ball2X >= BarrierX - Barrier_Length_Halved - 5) )
                    player_2_collision = 4'b0100;
            
            // P2's top side hits barrier
            else if ( (Ball2Y - Ball_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (Ball2Y - Ball_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (Ball2X <= BarrierX + Barrier_Length_Halved + 5) &&
                 (Ball2X >= BarrierX - Barrier_Length_Halved - 5) )
                    player_2_collision = 4'b1000;

            else
                player_2_collision = 4'b0;

			// P1 bullet's right side hits barrier
            if ( (BulletX + Bullet_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (BulletX + Bullet_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (BulletY <= BarrierY + Barrier_Height_Halved + 5) &&
                 (BulletY >= BarrierY - Barrier_Height_Halved - 5) )
                    bullet_1_collision = 1'b1;

            // P1 bullet's left side hits barrier
            else if ( (BulletX - Bullet_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (BulletX - Bullet_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (BulletY <= BarrierY + Barrier_Height_Halved + 5) &&
                 (BulletY >= BarrierY - Barrier_Height_Halved - 5) )
                    bullet_1_collision = 1'b1;
            
            // P1 bullet's bottom side hits barrier
            else if ( (BulletY + Bullet_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (BulletY + Bullet_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (BulletX <= BarrierX + Barrier_Length_Halved + 5) &&
                 (BulletX >= BarrierX - Barrier_Length_Halved - 5) )
                    bullet_1_collision = 1'b1;
            
            // P1 bullet's top side hits barrier
            else if ( (BulletY - Bullet_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (BulletY - Bullet_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (BulletX <= BarrierX + Barrier_Length_Halved + 5) &&
                 (BulletX >= BarrierX - Barrier_Length_Halved - 5) )
                    bullet_1_collision = 1'b1;

            else
                bullet_1_collision = 1'b0;

            // P2 bullet's right side hits barrier
            if ( (Bullet2X + Bullet_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (Bullet2X + Bullet_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (Bullet2Y <= BarrierY + Barrier_Height_Halved + 5) &&
                 (Bullet2Y >= BarrierY - Barrier_Height_Halved - 5) )
                    bullet_2_collision = 1'b1;

            // P2 bullet's left side hits barrier
            else if ( (Bullet2X - Bullet_Size) >= (BarrierX - Barrier_Length_Halved - 5) &&
                 (Bullet2X - Bullet_Size) <= (BarrierX + Barrier_Length_Halved + 5) &&
                 (Bullet2Y <= BarrierY + Barrier_Height_Halved + 5) &&
                 (Bullet2Y >= BarrierY - Barrier_Height_Halved - 5) )
                    bullet_2_collision = 1'b1;
            
            // P2 bullet's bottom side hits barrier
            else if ( (Bullet2Y + Bullet_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (Bullet2Y + Bullet_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (Bullet2X <= BarrierX + Barrier_Length_Halved + 5) &&
                 (Bullet2X >= BarrierX - Barrier_Length_Halved - 5) )
                    bullet_2_collision = 1'b1;
            
            // P2 bullet's top side hits barrier
            else if ( (Bullet2Y - Bullet_Size) >= (BarrierY - Barrier_Height_Halved - 5) &&
                 (Bullet2Y - Bullet_Size) <= (BarrierY + Barrier_Height_Halved + 5) &&
                 (Bullet2X <= BarrierX + Barrier_Length_Halved - 5) &&
                 (Bullet2X >= BarrierX - Barrier_Length_Halved - 5) )
                    bullet_2_collision = 1'b1;

            else
                bullet_2_collision = 1'b0;

	end  
    end
       
    
endmodule
