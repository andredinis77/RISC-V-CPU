module program_counter(
        input logic clk, reset,
        input logic[31:0] PC,
        output logic[31:0] O
);

    always_ff @( posedge clk ) begin : pc
            if(reset) begin
                O <= 32'b0;
            end
            else begin
                O <= PC;
            end
    end

endmodule
