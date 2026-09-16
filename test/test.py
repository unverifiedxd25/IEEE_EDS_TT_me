# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer


async def set_inputs(dut, A, B, OP):
    dut.ui_in.value = (OP << 4) | A
    dut.uio_in.value = B

    await Timer(1, units="ns")


@cocotb.test()
async def test_addition(dut):

    await set_inputs(dut, 5, 3, 0)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 8, f"Expected 8, got {result}"


@cocotb.test()
async def test_subtraction(dut):

    await set_inputs(dut, 5, 3, 1)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 2, f"Expected 2, got {result}"


@cocotb.test()
async def test_and(dut):

    await set_inputs(dut, 5, 3, 2)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 1, f"Expected 1, got {result}"


@cocotb.test()
async def test_or(dut):

    await set_inputs(dut, 5, 3, 3)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 7, f"Expected 7, got {result}"


@cocotb.test()
async def test_xor(dut):

    await set_inputs(dut, 5, 3, 4)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 6, f"Expected 6, got {result}"


@cocotb.test()
async def test_not(dut):

    await set_inputs(dut, 5, 0, 5)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 10, f"Expected 10, got {result}"


@cocotb.test()
async def test_left_shift(dut):

    await set_inputs(dut, 5, 0, 6)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 10, f"Expected 10, got {result}"


@cocotb.test()
async def test_right_shift(dut):

    await set_inputs(dut, 8, 0, 7)

    result = int(dut.uo_out.value) & 0x0F

    assert result == 4, f"Expected 4, got {result}"
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
