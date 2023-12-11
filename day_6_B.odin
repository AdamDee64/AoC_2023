package day_6_B

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
    // special version of get number, turns all numbers on one line into a single number
    for {
        if is_ascii_number(text[i + c]) {
            output *= 10
            output += int(text[i + c] - 48)
            c += 1
        } else if text[i + c] == 10{
            break
        } else {
            c += 1
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

    race_time : int
    distance : int

    record_time := true

    for i < size {
        v := int(text[i])
        n : int
        jump : int

        switch v {

            case 48..=57:
            n, jump = get_number(&text, i)
            if record_time {
                race_time = n
            } else {
                distance = n
            }
            i += jump

            case 10: 
            record_time = false
            i+= 1

            case:
            i += 1
        }
    }

    held_min : int
    held_max : int

    for i in 1..<race_time {
        if (race_time - i) * i > distance {
            held_min = i
            break
        }
    }
    jump := race_time >> 1
    index := jump
    for {
        held := race_time - index
        if jump > 1{
            if held * index > distance {
                index -= jump
                jump = jump >> 1
            } 
            
        } else {
            jump = 1
            if held * index > distance{
                held_max = held
                break
            }
        }
        index += jump
    }



    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(held_max - held_min + 1, ms, "milliseconds \n")
}