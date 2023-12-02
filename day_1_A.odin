package day_1_A

import "core:os"
import "core:fmt"

main :: proc() {

input, open_err := os.open("day_1_input.txt")
text, read_err := os.read_entire_file_from_handle(input)

size := len(text)

ten := 0
one := 0
total := 0

for i in 0..<size {
    v := int(text[i])
    
    switch v {
        case 48..=57:
        one = v - 48
        if ten == 0 {
            ten = v - 48
        }

        case 10:
        total = total + ten * 10 + one
        ten = 0
        one = 0

        case:
        continue
    }

}

fmt.print(total, "\n")

}