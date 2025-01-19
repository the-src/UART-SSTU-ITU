module baud_gen #(
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    output reg txClock,
    output reg rxClock
);

    parameter F_CLOCK = 100_000_000;
    parameter DIVISOR = F_CLOCK / (BAUD_RATE * 8);

    reg [31:0] txcounter;
    reg [31:0] rxcounter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            txcounter <= 0;
            rxcounter <= 0;
            txClock <= 0;
            rxClock <= 0;
        end else begin
            if (txcounter >= DIVISOR*8) begin
                txcounter <= 0;
                txClock <= ~txClock;
            end else begin
                txcounter <= txcounter + 1;
            end

            if (rxcounter >= (DIVISOR)) begin
                rxcounter <= 0;
                rxClock <= ~rxClock;
            end else begin
                rxcounter <= rxcounter + 1;
            end
        end
    end
endmodule