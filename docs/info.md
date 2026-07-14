<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

<!--- This file is used to generate your project datasheet. Please fill in the information below and delete any unused sections. You can also include images in this folder and reference them in the markdown. Each image must be less than 512 kb in size, and the combined size of all images must be less than 1 MB. -->

## How it works

This project implements a standard **8-to-3 Combinatorial Priority Encoder**. 

It takes an 8-bit input vector (`d[7:0]`) and encodes the index of the highest-priority active input bit into a 3-bit binary output (`y[2:0]`). 
* **Priority Order:** Bit `d[7]` has the highest priority, and bit `d[0]` has the lowest. For example, if both `d[7]` and `d[3]` are high, the design prioritizes `d[7]` and outputs `3'b111` (7).
* **Valid Indicator:** An additional output pin `v` (Valid) goes high (`1'b1`) if at least one input bit is active. If all input bits are low (`8'b00000000`), the valid pin goes low (`1'b0`) to indicate no active request.

## How to test

Because this is a completely combinatorial design, you can test it statically by applying inputs to the `ui_in` pins and observing the outputs on `uo_out`:

1. Set the design enable (`ena`) high.
2. Apply an input pattern to `ui_in[7:0]`. 
3. Observe the encoded 3-bit result on `uo_out[2:0]` (`y`) and the status flag on `uo_out[3]` (`v`).

### Example Test Vectors:
| Inputs (`ui_in[7:0]`) | Encoded Output (`uo_out[2:0]`) | Valid Flag (`uo_out[3]`) | Description |
| :--- | :--- | :--- | :--- |
| `00000000` | `000` | `0` | No inputs active (Invalid) |
| `00000001` | `000` | `1` | Only bit 0 is active |
| `00001010` | `011` | `1` | Bits 3 and 1 are active; Bit 3 takes priority |
| `10000000` | `111` | `1` | Highest bit 7 is active |

## External hardware

No external hardware is strictly required! You can test this project directly on the Tiny Tapeout demo board using the onboard DIP switches for the input lines (`ui_in`) and the onboard 7-segment display or discrete LEDs to read the binary output values on `uo_out`.
