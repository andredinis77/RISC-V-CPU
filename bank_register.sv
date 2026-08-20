module bank_register(
        input logic clk, reset, regWrite,
        input logic[4:0] Rs1, Rs2, wR,
        input logic[31:0] write_data,
        output logic[31:0] Rd1, Rd2
);

    logic [31:0] regs [0:31];
    int i;

    always_ff @(posedge clk) begin
        if(reset) begin
            for(i = 0; i < 32; i++)
                regs[i] <= 32'b0;
        end 
        else begin
            if(regWrite && wR != 5'b0) begin
                regs[wR] <= write_data;
            end
        end
    end

    always_comb begin
        Rd1 = (Rs1 == 5'b0) ? 32'b0 : regs[Rs1];
        Rd2 = (Rs2 == 5'b0) ? 32'b0 : regs[Rs2];
    end

endmodule
