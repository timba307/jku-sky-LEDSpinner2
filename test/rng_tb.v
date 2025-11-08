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

`include "rng.v"

module rng_tb;

  reg       clk_i  = 1'b0; // 50 MHz
  reg       rst_i  = 1'b1;
  reg       en_i   = 1'b1;
  wire [3:0] lfsr_o;

  rng dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .en_i(en_i),
    .lfsr_o(lfsr_o)
  );

  /* verilator lint_off STMTDLY */
  always #10 clk_i = ~clk_i;
  /* verilator lint_on STMTDLY */

  initial begin
    $dumpfile("rng_tb.vcd");
    $dumpvars;

    #100 rst_i = 1'b0;
    #10_000; // run
    #0   rst_i = 1'b1; // reset test
    #40  rst_i = 1'b0;
    #50_000;
    $finish;


  end
endmodule
