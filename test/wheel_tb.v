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

/*
  Testbench für wheel
  - Generiert Tick-Strobes aus 50 MHz
  - stop_i Sequenzen, rand_i aus rng-Instanz
*/

`timescale 1ns/1ns

`include "wheel.v"
`include "rng.v"

module wheel_tb;

  reg        clk_i   = 1'b0; // 50 MHz
  reg        rst_i   = 1'b1;
  reg        stop_i  = 1'b0;
  wire [3:0] rand_i;
  wire [2:0] pos_o;
  wire       running_o;

  // Tick-Strobe: alle 50 us einmal (20 kHz Takt / 1-Stroke)
  reg [15:0] tick_div = 0;
  reg        tick_i   = 0;


  always @(posedge clk_i) begin
    if (rst_i) begin
      tick_div <= 0;
      tick_i   <= 0;
    end else begin
      if (tick_div == 16'd2499) begin
        tick_div <= 0;
        tick_i   <= 1'b1;   // 1 Takt breit
      end else begin
        tick_div <= tick_div + 1;
        tick_i   <= 1'b0;
      end
    end
  end
  

  // RNG für rand_i (steppt bei jedem Tick)
  
  rng rng_i (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .en_i(tick_i),
    .lfsr_o(rand_i)
  );
  

  wheel dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .tick_i(tick_i),
    .stop_i(stop_i),
    .rand_i(rand_i),
    .pos_o(pos_o),
    .running_o(running_o)
  );

  // 50 MHz
  /* verilator lint_off STMTDLY */
  always #10 clk_i = ~clk_i;
  /* verilator lint_on STMTDLY */



  initial begin
    $dumpfile("wheel_tb.vcd");
    $dumpvars;

    /* verilator lint_off STMTDLY */
    #100  rst_i = 1'b0;

    // Loslaufen lassen
    #2_000_000;      // 2 ms

    // Stop anfordern
    stop_i = 1'b1;
    #3_000_000;      // warten, bis stop erreicht (ein paar Ticks)

    // Wieder starten
    stop_i = 1'b0;
    #2_000_000;

    // Noch mal stoppen
    stop_i = 1'b1;
    #3_000_000;
    
    stop_i = 1'b0;
    #2_000_000;
    
    stop_i=1'b1;
    #3_000_000;
    

    $finish;
    /* verilator lint_on STMTDLY */
  end
endmodule


