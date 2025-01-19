module uart_tx #(
    parameter IDLE = 2'b00,
    parameter START = 2'b01,
    parameter DATA = 2'b10,
    parameter STOP = 2'b11
) (
    input wire clk,
    input wire reset,
    input wire tx_en,
    input wire [7:0] tx_data_in,
    output reg tx_data_out,
    output reg start,
    output reg busy,
    output reg done
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            start <= 0;
            busy <= 0;
            done <= 0;
            tx_data_out <= 1;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_en) begin
                        state <= START;
                        tx_data_out <= 1; // Drive high line
                        start <= 0;
                        busy <= 0;
                        done <= 0;
                        shift_reg <= tx_data_in;
                        bit_count <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    state <= DATA;
                    start <= 1;
                    busy <= 1;
                    done <= 0;
                    tx_data_out <= 0; // Drive high to low
                    bit_count <= 0;
                end
                DATA: begin
                    start <= 0;
                    busy <= 1;
                    done <= 0;
                    shift_reg <= {1'b0, shift_reg[7:1]}; // Shift data
                    tx_data_out <= shift_reg[0]; // Drive data
                    bit_count <= bit_count + 1;
                    if (&bit_count) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    start <= 0;
                    busy <= 1;
                    done <= 1;
                    tx_data_out <= 1; // Drive high line
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule