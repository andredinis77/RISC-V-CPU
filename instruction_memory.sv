module instruction_memory(
        input logic[31:0] pc,
        output logic[31:0] instru
);
    logic[31:0] ins [0:12];

        

    initial begin
        $readmemh("machine_code.txt", ins);
    end

    always @(*) begin
        instru = ins[pc >> 2];
    end

endmodule
