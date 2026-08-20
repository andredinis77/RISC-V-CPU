`timescale 1ns/1ns
`include "cpu.sv"

module test_cpu;

    logic clk, reset;
    logic[31:0] res;

    initial begin
        reset = 1'b1;
        #20;
        reset = 1'b0;
    end

    cpu cpu(
        .clk( clk ),
        .reset( reset ),
        .res( res )
    );

    logic[31:0] test_vector[0:10];
    logic[31:0] expected_result;
    int i;

    initial begin
        $readmemh("test.txt", test_vector);
        i = 0;
    end

    always @(posedge clk) begin
        {expected_result} = test_vector[i];

        #20;

        if(res === expected_result) begin
            $display("Test %0d passed: res = %0d -----> expected = %0d", i, res, expected_result);
        end else begin
            $display("Test %0d failed: res = %0d -----> expected = %0d", i, res, expected_result);
        end
        i = i + 1;

        if(i === 11) begin
            $finish;
        end
    end

    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end

endmodule 
