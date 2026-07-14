# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_priority_encoder(dut):
    dut._log.info("Starting Priority Encoder Testbench")

    # Set up a clock (even though the design is combinatorial, Tiny Tapeout requires it)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # --- Initialize & Reset ---
    dut._log.info("Applying Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # --- Test Vectors ---
    # format: (input_value_ui_in, expected_output_uo_out, description)
    # Expected output format in binary: 8'b0000_V_YYY (V = Valid flag, YYY = 3-bit binary code)
    test_cases = [
        (0b00000000, 0b00000000, "No inputs active - Invalid flag expected"),
        (0b00000001, 0b00001000, "Bit 0 active -> Output 0, Valid"),
        (0b00000010, 0b00001001, "Bit 1 active -> Output 1, Valid"),
        (0b00000100, 0b00001010, "Bit 2 active -> Output 2, Valid"),
        (0b00001000, 0b00001011, "Bit 3 active -> Output 3, Valid"),
        (0b00010000, 0b00001100, "Bit 4 active -> Output 4, Valid"),
        (0b00100000, 0b00001101, "Bit 5 active -> Output 5, Valid"),
        (0b01000000, 0b00001110, "Bit 6 active -> Output 6, Valid"),
        (0b10000000, 0b00001111, "Bit 7 active -> Output 7, Valid"),
        # Priority checking tests
        (0b10001010, 0b00001111, "Multiple bits active: Bit 7 takes priority"),
        (0b00010100, 0b00001100, "Multiple bits active: Bit 4 takes priority"),
        (0b01111111, 0b00001110, "Multiple bits active: Bit 6 takes priority"),
    ]

    dut._log.info("Running Test Vectors...")
    for ui_in_val, expected_uo_out, desc in test_cases:
        dut.ui_in.value = ui_in_val
        await ClockCycles(dut.clk, 1)  # allow evaluation time
        
        # Read current output
        actual_uo_out = dut.uo_out.value.integer
        
        dut._log.info(f"Test: {desc} | Input: {bin(ui_in_val)} -> Expected: {bin(expected_uo_out)}, Got: {bin(actual_uo_out)}")
        assert actual_uo_out == expected_uo_out, f"Failing Case: {desc}! Expected {bin(expected_uo_out)}, got {bin(actual_uo_out)}"

    dut._log.info("All Priority Encoder test vectors passed successfully!")
