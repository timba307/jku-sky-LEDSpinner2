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

`default_nettype none

`include "prescaler.v"
`include "rng.v"
`include "wheel.v"
`include "seg_driver.v"
`include "guess_eval.v"

module tt_um_timba307_LEDSpinner (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [3:0] speed_bits = ui_in[3:0];    // ui[0..3]
    wire       stop_wheel = ui_in[7];      // ui[7]
    wire [5:0] guess_bits = uio_in[5:0];

    wire wheel_tick;
    prescaler prescaler_inst (
        .clk_i(clk),
        .rst_i(~rst_n),
        .speed_i(speed_bits),
        .tick_o(wheel_tick)
    );

    wire [3:0] rng_val;
    rng rng_inst (
        .clk_i(clk),
        .rst_i(~rst_n),
        .en_i(wheel_tick),
        .lfsr_o(rng_val)
    );


    wire [2:0] wheel_pos; // only values 0..5
    wire       wheel_running;
    wheel wheel_inst (
        .clk_i(clk),
        .rst_i(~rst_n),
        .tick_i(wheel_tick),
        .stop_i(stop_wheel),
        .rand_i(rng_val),   // 4-bit random number
        .pos_o(wheel_pos),
        .running_o(wheel_running)
    );

    wire dp_on;
    guess_eval guess_inst (
        .pos_i(wheel_pos),
        .running_i(wheel_running),
        .guess_i(guess_bits),
        .dp_o(dp_on)
    );

    wire [6:0] seg_bits; // seg_top .. seg_middle
    seg_driver segdriver_inst (
        .pos_i(wheel_pos),
        .seg_o(seg_bits)
    );


    assign uo_out[6:0] = seg_bits[6:0];
    assign uo_out[7] = dp_on;


    assign uio_out = 8'b0;
    assign uio_oe  = 0; // all as inputs

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[4], ui_in[5], ui_in[6], uio_in[6], uio_in[7]};

endmodule
