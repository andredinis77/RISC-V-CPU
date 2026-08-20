module imm_gen(
            input logic[31:0] instru,
            output logic[31:0] imm
);
    logic[6:0] opcode;
    assign opcode = instru[6:0];

    typedef enum logic[6:0] {
        I_type = 7'b0010011,
        LW_code = 7'b0000011,
        S_type = 7'b0100011,
        B_type = 7'b1100011
    } opcode_type;

    always @(*) begin
        imm = 32'b0;

            case(opcode)
                I_type, LW_code: begin
                        imm = { {20{instru[31]} }, instru[31:20] };
                end
                S_type: begin
                        imm = { {20{instru[31]}}, instru[31:25], instru[11:7] };
                end
                B_type: begin
                        imm = { {19{instru[31]}} , instru[31], instru[7], instru[30:25], instru[11:8], 1'b0};
                end   
                default: begin imm = 32'b0;
                end     
            endcase
    end

endmodule
