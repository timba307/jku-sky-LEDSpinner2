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

`include "wheel.v"
`include "rng.v"

module wheel_tb;

  reg        clk_i   = 1'b0;
  reg        rst_i   = 1'b1;
  reg        stop_i  = 1'b0;
  wire [3:0] rand_i;
  wire [2:0] pos_o;
  wire       running_o;

  // make ticks to test wheel
  reg [15:0] cnt = 0;
  reg        tick_i   = 0;
  always @(posedge clk_i) begin
    if (rst_i) begin
      cnt <= 0;
      tick_i   <= 0;
    end else begin
      if (cnt == 16'd2499) begin //16'd2499 = 20khz
        // trigger tick and reset counter
        cnt <= 0;
        tick_i   <= 1'b1;
      end else begin
        // count up
        cnt <= cnt + 1;
        tick_i   <= 1'b0;
      end
    end
  end
  
  // rng generator for every tick
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

  /* verilator lint_off STMTDLY */
  always #10 clk_i = ~clk_i;
  /* verilator lint_on STMTDLY */



  initial begin
    $dumpfile("wheel_tb.vcd");
    $dumpvars;

    #100  rst_i = 1'b0;

    // run for 2ms
    #2_000_000;

    // user wants to stop wheel
    stop_i = 1'b1;
    #3_000_000;

    // start again
    stop_i = 1'b0;
    #2_000_000;

    // stop again
    stop_i = 1'b1;
    #3_000_000;
    
    // start again
    stop_i = 1'b0;
    #2_000_000;
    
    //stop again
    stop_i=1'b1;
    #3_000_000;
    

    $finish;
  end
endmodule


