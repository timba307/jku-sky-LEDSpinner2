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

`include "seg_driver.v"

module seg_driver_tb;

  reg  [2:0] pos_i = 3'd0;
  wire [6:0] seg_o;

  seg_driver dut (
    .pos_i(pos_i),
    .seg_o(seg_o)
  );

  initial begin
    $dumpfile("seg_driver_tb.vcd");
    $dumpvars;

    // try all positions
    repeat (6) begin
      #50 pos_i = pos_i + 1;
    end


    $finish;
  end
endmodule
