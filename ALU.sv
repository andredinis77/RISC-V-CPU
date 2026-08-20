module ALU(
    input logic[31:0] A, B,
    input logic[3:0] ALUctrl,
    output logic[31:0] ALUout,
    output logic N, Z, V, C
);

    typedef enum logic[3:0] {
        ADD = 4'b0000,
        SUB = 4'b1000,
        AND = 4'b0111,
        OR  = 4'b0110,
        XOR = 4'b0100,
        SLL = 4'b0001,
        SRL = 4'b0101,
        SRA = 4'b1101,
        SLT = 4'b0010,
        SLTU= 4'b1010
    } ALUop_t;

    logic[32:0] temp;

    always @(*) begin
        temp = 33'd0;
        N = 1'b0;
        Z = 1'b0;
        V = 1'b0;
        C = 1'b0;

        case(ALUctrl)
            ADD: begin
                temp = A + B;
                ALUout = temp[31:0];
                C = temp[32];
                V = (A[31] == B[31]) && (ALUout[31] != A[31]);
            end
            SUB: begin
                temp = A - B;
                ALUout = temp[31:0];
                C = temp[32];
                V = (A[31] != B[31]) && (ALUout[31] != A[31]);
            end
            AND: ALUout = A & B;
            OR : ALUout = A | B;
            XOR: ALUout = A ^ B;
            SLL: ALUout = A << B[4:0];
            SRL: ALUout = A >> B[4:0];
            SRA: ALUout = $signed(A) >>> B[4:0];
            SLT: ALUout = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            SLTU:ALUout = (A < B) ? 32'd1 : 32'd0;
            default: ALUout = 32'd0;
        endcase

        Z = (ALUout == 32'd0) ? 1'b1 : 1'b0;
        N = ALUout[31];
    end


endmodule 
