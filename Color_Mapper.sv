//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, Ball2X, Ball2Y, DrawX, DrawY, Ball_size,
                       input        [9:0] BulletX, BulletY, Bullet2X, Bullet2Y, Bullet_Size, bullet_on, bullet2_on,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, ball2_on, draw_bullet, draw_bullet2;
	 
	  
    int DistX, DistY, Dist2X, Dist2Y, Size;
	assign DistX = DrawX - BulletX;
    assign DistY = DrawY - BulletY;
    assign Dist2X = DrawX - Bullet2X;
    assign Dist2Y = DrawY - Bullet2Y;
    assign Size = Ball_size;
	  
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= BallX - Ball_size) && (DrawX <= BallX + Ball_size) &&
            (DrawY >= BallY - Ball_size) && (DrawY <= BallY + Ball_size)) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
        if ((DrawX >= Ball2X - Ball_size) && (DrawX <= Ball2X + Ball_size) &&
            (DrawY >= Ball2Y - Ball_size) && (DrawY <= Ball2Y + Ball_size)) 
            ball2_on = 1'b1;
        else 
            ball2_on = 1'b0;
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            draw_bullet = 1'b1;
        else 
            draw_bullet = 1'b0;
        if ( ( Dist2X*Dist2X + Dist2Y*Dist2Y) <= (Size * Size) )
            draw_bullet2 = 1'b1;
        else 
            draw_bullet2 = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1) || (draw_bullet == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else if ((ball2_on == 1'b1) || (draw_bullet2 == 1'b1))
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
        end
        else 
        begin 
            Red = 8'h00; 
            Green = 8'hAA;
            Blue = 8'h00;
        end      
    end 
    
endmodule
