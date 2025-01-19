# README.md

# UART Driver Project

This project implements a Universal Asynchronous Receiver-Transmitter (UART) driver in Verilog. The design includes modules for the transmitter, receiver, baud rate generator, and a top module, along with their respective testbenches.

## Directory Structure

- **rtl/**: Contains the RTL (Register Transfer Level) design files.
  - `uart_tx.v`: UART transmitter module.
  - `uart_rx.v`: UART receiver module.
  - `baud_gen.v`: Baud rate generator module.
  - `uart_top.v`: Top module that integrates all components.

- **tb/**: Contains the testbench files for simulation.
  - `uart_tx_tb.v`: Testbench for the UART transmitter.
  - `uart_rx_tb.v`: Testbench for the UART receiver.
  - `baud_gen_tb.v`: Testbench for the baud rate generator.
  - `uart_top_tb.v`: Testbench for the top module.

- **sim/**: Contains simulation scripts and files.
  - `wave.do`: Script for waveform generation.

- **constraints/**: Contains constraint files for FPGA implementation.
  - `uart_constraints.xdc`: Constraints for the UART design.

## Usage

To simulate the design, run the testbenches in the `tb` directory using your preferred simulation tool. Ensure that the RTL files in the `rtl` directory are included in the simulation environment.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.