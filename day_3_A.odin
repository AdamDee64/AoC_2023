package day_3_A

import "core:os"
import "core:fmt"
import "core:time"

get_line_length :: proc(text : ^[]u8) -> int {
    count : int
    for text[count] != 10{
        count += 1
    }
    return count + 1
}

is_ascii_number :: proc(n : u8) -> bool {
    if (n >= 48 && n <= 57) {
        return true
    }
    return false
}

get_number:: proc(text : ^[]u8, i : int) -> int {
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
    return output
}

get_offset_left :: proc(text: ^[]u8, i : int) -> int{
    offset := i
    for {
        if is_ascii_number(text[offset]){
            offset -= 1
            if offset < 0{ // handle possible out of array range
                return 0
            }
        } else {
            return offset + 1
        }
    }
}

check_left :: proc(text: ^[]u8, i : int) -> int {
    offset := i - 1
    if text[offset] == 46 {
        return 0
    } 
    offset = get_offset_left(text, offset)
    return get_number(text, offset)
}

check_right :: proc(text: ^[]u8, i : int) -> int{
    if text[i + 1] == 46 {
        return 0
    } 
    return get_number(text, i + 1)
}

check_above :: proc(text: ^[]u8, i : int, line_length : int) -> (int, int) {
    offset := i - line_length
    if is_ascii_number(text[offset]) {
        offset = get_offset_left(text, offset)
        return get_number(text, offset), 0
    }
    return check_left(text, offset), check_right(text, offset)
}

check_below :: proc(text: ^[]u8, i : int, line_length : int) -> (int, int) {
    offset := i + line_length
    
    if is_ascii_number(text[offset]) {
        offset = get_offset_left(text, offset)
        return get_number(text, offset), 0
    }
    return check_left(text, offset), check_right(text, offset)
}

sum_all :: proc(text: ^[]u8, i : int, line_length : int) -> int {
    left := check_left(text, i)
    right := check_right(text, i)
    a_left, a_right := check_above(text, i, line_length)
    b_left, b_right := check_below(text, i, line_length)

    return left + right + a_left + a_right + b_left + b_right
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_3_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    line_length := get_line_length(&text)

    total := 0

    i := 0

    for i < size {
        v := int(text[i])
        jump : int
        
        switch v {
            case 48..=57:   // number value
            i += 1
            case 10:        // new line
            i += 1
            case 46:        // .
            i += 1
            case:
            total += sum_all(&text, i, line_length)
            i += 1
        }
    }
    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(total, ms, "milliseconds \n")
}