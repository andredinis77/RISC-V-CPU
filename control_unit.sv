module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic bit_7, N, Z,
    output logic regWrite, ALUsrc, memWrite, memRead, memtoReg, PCsrc,
    output logic[3:0] ALUctrl
);  

    typedef enum logic[6:0] {
        R_type = 7'b0110011,
        I_type = 7'b0010011,
        LW_code = 7'b0000011,
        S_type = 7'b0100011,
        B_type = 7'b1100011
    } opcode_type;

    
    always_comb begin
        regWrite = 1;
        ALUsrc = 0;
        memWrite = 0; 
        memRead = 0;
        memtoReg = 0; 
        PCsrc = 0;


        regWrite = (opcode == S_type || opcode == B_type) ? 0 : 1;
        ALUsrc = (opcode == I_type || opcode == S_type || opcode == LW_code) ? 1 : 0;
        memWrite = (opcode == S_type) ? 1 : 0;
        memRead = (opcode == LW_code) ? 1 : 0;
        memtoReg = (opcode == LW_code) ? 1 : 0;


        //ALUctrl logic
        case(opcode)
            R_type: begin ALUctrl = {bit_7, funct3}; end

            I_type: begin 
                        if(funct3 == 3'b001 || funct3 == 3'b101) begin
                            ALUctrl = {bit_7, funct3};
                        end
                        else begin
                            ALUctrl = {1'b0, funct3};
                        end
                    end
            LW_code, S_type: begin ALUctrl = 4'b0000; end

            B_type: begin ALUctrl = 4'b1000; end

            default: begin ALUctrl = 4'b0000; end
        endcase

        if(opcode == B_type) begin
                case(funct3)
                    3'b000: begin //beq
                            if(Z) PCsrc = 1'b1;
                            else PCsrc = 1'b0;
                    end
                    3'b001: begin //bne
                            if(!Z) PCsrc = 1'b1;
                            else PCsrc = 1'b0;
                    end
                    3'b100, 3'b110: begin //blt
                            if(N) PCsrc = 1'b1;
                            else PCsrc = 1'b0;
                    end
                    3'b101, 3'b111: begin //bgt
                            if(!N) PCsrc = 1'b1;
                            else PCsrc = 1'b0;
                    end
                    default: begin PCsrc = 1'b0; end
                endcase
        end
        else begin
                PCsrc = 1'b0;
        end

    end

endmodule
