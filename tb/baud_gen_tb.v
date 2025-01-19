module baud_gen_tb();

    // Testbench signals
    reg clk;
    reg reset;
    wire txClock_9600;
    wire rxClock_9600;
    wire txClock_115200;
    wire rxClock_115200;

    baud_gen #(
        .BAUD_RATE(9600)
    ) dut (
        .clk(clk),
        .reset(reset),
        .txClock(txClock_9600),
        .rxClock(rxClock_9600)
    );

    baud_gen #(
        .BAUD_RATE(115200)
    ) dut2 (
        .clk(clk),
        .reset(reset),
        .txClock(txClock_115200),
        .rxClock(rxClock_115200)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;

        #20;
        reset = 0;
        #20;

        #1000;
        $finish;       
    end

endmodule
