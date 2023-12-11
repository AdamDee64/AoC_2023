package day_6_A

import "core:os"
import "core:fmt"
import "core:time"
import "core:math"

is_ascii_number :: proc(n : u8) -> bool {
    if (n >= 48 && n <= 57) {
        return true
    }
    return false
}

get_number :: proc(text : ^[]u8, i : int) -> (int, int) {
    output := int(text[i]) - 48
    c := 1
    for {
        if is_ascii_number(text[i + c]) {
            output *= 10
            output += int(text[i + c] - 48)
            c += 1
        } else {
            break
        }
    }
    return output, c
}


main :: proc() {
    start := time.now()

    input, open_err := os.open("day_6_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    i := 0

    race_time : [dynamic]int
    distance : [dynamic]int

    record_time := true

    for i < size {
        v := int(text[i])
        n : int
        jump : int

        switch v {

            case 48..=57:
            n, jump = get_number(&text, i)
            if record_time {
                append(&race_time, n)
            } else {
                append(&distance, n)
            }
            i += jump

            case 10: 
            record_time = false
            i+= 1

            case:
            i += 1
        }
    }

    output := 1
    for i in 0..<len(race_time) {
        c := 0
        max_distance := 0
        for j in 1..<race_time[i]{
            max_distance = (race_time[i] - j) * j
            if max_distance > distance[i]{
                c += 1
            }
        }
        output *= c
    }

    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(output, ms, "milliseconds \n")
}