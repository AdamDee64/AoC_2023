package day_8_A

import "core:os"
import "core:fmt"
import "core:time"

Step :: struct{
    step : [3]u8,
    L: [3]u8,
    R: [3]u8
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_8_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    i := 0

    reading_dir := true
    dir : [dynamic]u8

    steps : [dynamic]Step
    node : Step
    data : [3]u8
    data_i := 0

    for i < size {
        v := int(text[i])

        switch v {
            case 10:
            reading_dir = false

            case 65..=90:
            if reading_dir {
                append(&dir, text[i])
            } else {
                data[data_i] = text[i]
                data_i += 1
            }

            case 61:    // =
            node.step = data
            data_i = 0
            case 44:    // ,
            node.L = data
            data_i = 0
            case 41:    // )
            node.R = data
            data_i = 0
            append(&steps, node)
        }
        i += 1
    }

    n_of_steps := 0
    directions := len(dir)
    length := len(steps)

    data_begin : [3]u8 = {65, 65, 65}
    data_end : [3]u8 = {90, 90, 90}
    data = data_begin

    for {
        for i in 0..<length {
            if steps[i].step == data{
                if dir[n_of_steps % directions] == 76 {
                    data = steps[i].L
                } else {
                    data = steps[i].R
                }
                n_of_steps +=1
                continue
            }
        }
        if data == data_end {
            break
        }
    }


    end := time.since(start)
    ms := time.duration_milliseconds(end)
    fmt.print(n_of_steps, directions, length, ms, "milliseconds \n")
}