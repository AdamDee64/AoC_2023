package day_15_A

import "core:os"
import "core:fmt"
import "core:time"

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_15_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)

    acc := 0
    total := 0

    for i in 0..<size {

        switch text[i]{
            case 44:
            total += acc
            acc = 0

            case 10:
            continue

            case:
            acc += int(text[i])
            acc *= 17
            acc %= 256

           


        }
    }
    total += acc



    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(total, ms, "milliseconds \n")

}