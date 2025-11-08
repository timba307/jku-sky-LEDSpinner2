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

`include "guess_eval.v"

module guess_eval_tb;

  reg  [2:0] pos_i     = 3'd0;
  reg        running_i = 1'b1;  // während Spin: dp=0
  reg  [5:0] guess_i   = 6'b010000;
  wire       dp_o;

  guess_eval dut (
    .pos_i(pos_i),
    .running_i(running_i),
    .guess_i(guess_i),
    .dp_o(dp_o)
  );

  initial begin
    $dumpfile("guess_eval_tb.vcd");
    $dumpvars;

    #50;

    // try all positions while running=1
    repeat (5) begin
      pos_i = pos_i + 1;
      #50;
    end

    // try all positions while wheel is "stopped" (running=0)
    running_i = 1'b0;
    pos_i   = 0;
    repeat (5) begin
      #50 pos_i = pos_i + 1;
    end
    #50;

    $finish;
  end
endmodule
