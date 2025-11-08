// Copyright 2025 Tim Tremetsberger
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE−2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`timescale 1ns/1ns

`include "prescaler.v"

module prescaler_tb;

  reg        clk_i   = 1'b0;  // 50 MHz
  reg        rst_i   = 1'b1;
  reg  [3:0] speed_i = 4'b0111; // 8 Hz
  wire       tick_o;

  prescaler dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .speed_i(speed_i),
    .tick_o(tick_o)
  );

  // 50 MHz Clock
  /* verilator lint_off STMTDLY */
  always #10 clk_i = ~clk_i;
  /* verilator lint_on STMTDLY */

  initial begin
    $dumpfile("prescaler_tb.vcd");
    $dumpvars(0, prescaler_tb.rst_i, prescaler_tb.speed_i, prescaler_tb.tick_o);
    $dumpvars(0, prescaler_tb.dut.limit);

    #100 rst_i = 1'b0;

    // wait for 2 ticks
    #270_000_000;

    // change to 16Hz 
    speed_i = 4'b1111;
    #200_000_000;
    
    $finish;
  end
endmodule
