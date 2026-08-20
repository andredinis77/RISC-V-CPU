`include "program_counter.sv"
`include "instruction_memory.sv"
`include "imm_gen.sv"
`include "control_unit.sv"
`include "bank_register.sv"
`include "data_memory.sv"
`include "ALU.sv"


module cpu(
        input logic clk, reset,
        output logic[31:0] res
);

    logic[31:0] PC_current;
    logic[31:0] PC_next;
    assign PC_next = (PCsrc) ? PC_current + imm : PC_current + 32'd4;

    program_counter program_counter(
            .clk( clk ),
            .reset( reset ),
            .PC( PC_next ),
            .O( PC_current )
    );

    logic[31:0] inst;

    instruction_memory instruction_memory(
            .pc( PC_current ),
            .instru( inst )
    );

    logic[6:0] opcode;
    logic[2:0] funct3;
    logic bit_7;
    logic[4:0] Rs1;
    logic[4:0] Rs2;
    logic[4:0] Wr;
    logic[31:0] Rd1;
    logic[31:0] Rd2;
    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign bit_7  = inst[30];
    assign Rs1    = inst[19:15];
    assign Rs2    = inst[24:20];
    assign Wr     = inst[11:7];

    logic[31:0] out_alu;
    logic[31:0] imm;

    logic regWrite, ALUsrc, memWrite, memRead, memtoReg, PCsrc;
    logic N, Z, V, C;
    logic[3:0] ALUctrl;

        control_unit control_unit(
                .opcode( opcode ),
                .funct3( funct3 ),
                .bit_7( bit_7 ),
                .N( N ),
                .Z( Z ),
                .regWrite( regWrite ),
                .ALUsrc( ALUsrc ),
                .memWrite( memWrite ),
                .memRead( memRead ),
                .memtoReg( memtoReg ),
                .PCsrc( PCsrc ),
                .ALUctrl( ALUctrl )
    );

        bank_register bank_register(
                .clk( clk ),
                .reset( reset ),
                .regWrite( regWrite ),
                .Rs1( Rs1 ),
                .Rs2( Rs2 ),
                .wR( Wr ),
                .write_data( data_to_write ), 
                .Rd1( Rd1 ),
                .Rd2( Rd2 )
    );

        imm_gen imm_gen(
                .instru( inst ),
                .imm( imm )
        );

        logic[31:0] B_operator;
        assign B_operator = (ALUsrc) ? imm : Rd2;

        ALU ALU(
                .A( Rd1 ),
                .B( B_operator ),
                .ALUctrl( ALUctrl ),
                .ALUout( out_alu ),
                .N( N ),
                .Z( Z ),
                .V( V ),
                .C( C )
        );

        logic[31:0] data; 
        
        data_memory data_memory(
                .clk( clk ),
                .memWrite( memWrite ),
                .memRead( memRead ),
                .address( out_alu ),
                .writeData( Rd2 ),
                .data( data )
        );


        logic[31:0] data_to_write;
        assign data_to_write = (memtoReg) ? data : out_alu;

        assign res = data_to_write;
endmodule

