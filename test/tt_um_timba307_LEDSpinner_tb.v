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

module tt_um_timba307_LEDSpinner_tb;

  // inputs
  reg  [7:0] ui_in  = 8'b00000000;
  reg  [7:0] uio_in = 8'b00000000;
  reg        ena    = 1'b1;
  reg        clk    = 1'b0;
  reg        rst_n  = 1'b0;  // active-low

  // outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // dut
  tt_um_timba307_LEDSpinner dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
  );

  // 50 MHz Clock
  /* verilator lint_off STMTDLY */
  always #10 clk = ~clk;
  /* verilator lint_on STMTDLY */

  initial begin
    $dumpfile("tt_um_timba307_LEDSpinner_tb.vcd");
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.ui_in);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.uio_in);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.ena);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.rst_n);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.uo_out);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.uio_out);
    $dumpvars(0, tt_um_timba307_LEDSpinner_tb.uio_oe);
    $dumpvars(1, tt_um_timba307_LEDSpinner_tb.dut);

    // reset deactivated
    #200 rst_n = 1'b1;

    // set speed to invalid pattern to trigger default speed (1khz)
    ui_in[3:0] = 4'b0101;

    // no guesses at first
    uio_in[5:0] = 6'b000000;
    #4_000_000;

    // user wants to stop wheel
    ui_in[7] = 1'b1;
    #5_000_000;

    // start wheel again
    ui_in[7] = 1'b0;
    // activate all guesses simultainously
    uio_in[5:0] = 6'b111111;
    #5_000_000;

    // stop wheel
    ui_in[7] = 1'b1;
    #10_000_000;


    $finish;
    /* verilator lint_on STMTDLY */
  end
endmodule
