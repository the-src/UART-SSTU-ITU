module uart_rx #(
    parameter IDLE = 2'b00,
    parameter START = 2'b01,
    parameter DATA = 2'b10,
    parameter STOP = 2'b11
) (
    input wire clk,          // 8x baud rate clock
    input wire reset,        // Active high reset
    input wire rx_en,        // Receiver enable
    input wire rx_data_in,   // Serial input data
    output reg [7:0] rx_data_out,  // Parallel output data
    output reg start,        // Start detected
    output reg busy,         // Receiver busy
    output reg done          // Reception complete
);

    reg [1:0] state;
    reg [2:0] sample_count;  // Counts 0-7 samples
    reg [2:0] bit_count;     // Counts 0-7 bits
    reg [7:0] shift_reg;     // Shift register for received data
    reg [3:0] ones_count;    // Count of '1's sampled

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sample_count <= 0;
            bit_count <= 0;
            shift_reg <= 0;
            ones_count <= 0;
            start <= 0;
            busy <= 0;
            done <= 0;
            rx_data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    start <= 0;
                    busy <= 0;
                    done <= 0;
                    bit_count <= 0;
                    ones_count <= 0;
                    shift_reg <= 0;
                    if (rx_en && !rx_data_in) begin
                        state <= START;
                        sample_count <= 0;
                    end
                end

                START: begin
                    start <= 1;
                    busy <= 1;
                    done <= 0;
                    if (sample_count == 3'd3) begin
                        state <= DATA;
                        sample_count <= 0;
                        bit_count <= 0;
                        ones_count <= 0;
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end

                DATA: begin
                    start <= 0;
                    busy <= 1;
                    done <= 0;
                    if (sample_count == 3'd7) begin
                        if (ones_count >= 4)
                            shift_reg[bit_count] <= 1'b1;
                        else
                            shift_reg[bit_count] <= 1'b0;
                            
                        ones_count <= 0;
                        sample_count <= 0;
                        
                        if (bit_count == 3'd7) begin
                            state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        if (rx_data_in)
                            ones_count <= ones_count + 1;
                            sample_count <= sample_count + 1;
                    end
                end

                STOP: begin
                    start <= 0;
                    busy <= 1;
                    done <= 1;
                    if (sample_count == 3'd7) begin
                        state <= IDLE;
                        rx_data_out <= shift_reg;
                        done <= 1;
                        busy <= 1;
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule