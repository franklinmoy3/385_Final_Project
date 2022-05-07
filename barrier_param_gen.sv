module barrier_param_gen (
    input Reset, Clk,
    input [23:0] Base,
    output [9:0] Random_BarrierX, Random_BarrierY, Random_Barrier_Height, Random_Barrier_Length
);

    // Mapped pairs of base Barrier coords
    parameter int BarrierX_List[16] = '{100, 150, 200, 250, 350, 400, 450, 500, 100, 150, 200, 250, 350, 400, 450, 500};
    parameter int BarrierY_List[16] = '{45, 45, 45, 80, 75, 60, 50, 100, 360, 405, 325, 400, 290, 345, 380, 400};
    
    logic [9:0] Random_BarrierX_Latched, Random_BarrierY_Latched, Random_Barrier_Height_Latched, Random_Barrier_Length_Latched;
    logic [9:0] Prelatch_X, Prelatch_Y, Prelatch_Height, Prelatch_Length;
    logic [23:0] Counter_One, Counter_Two;

    always_ff @ (posedge Reset or posedge Clk) 
    begin
        if (Reset)
        begin
            Random_BarrierX_Latched <= Prelatch_X;
            Random_BarrierY_Latched <= Prelatch_Y;
            Random_Barrier_Height_Latched <= (Prelatch_Height % 30) + 5;
            Random_Barrier_Length_Latched <= (Prelatch_Length % 50) + 5;
            Counter_One <= 24'hAAAAAA ^ Counter_Two ^ Base;
            Counter_Two <= 24'h888888 ^ Counter_One ^ (~Base);
        end

        else
        begin
            Prelatch_X <= BarrierX_List[Counter_One[8:5]];
            Prelatch_Y <= BarrierY_List[Counter_One[8:5]];
            Prelatch_Height <= Counter_Two[11:2];
            Prelatch_Length <= Counter_Two[14:5];
        end    
    end

    assign Random_BarrierX = Random_BarrierX_Latched;
    assign Random_BarrierY = Random_BarrierY_Latched;
    assign Random_Barrier_Height = Random_Barrier_Height_Latched;
    assign Random_Barrier_Length = Random_Barrier_Length_Latched;

endmodule