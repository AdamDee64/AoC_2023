package day_15_B

import "core:os"
import "core:fmt"
import "core:time"
import "core:strings"

Lens :: struct {
    label : string,
    focal_length : int
}

Box :: struct {
    lenses : [dynamic]Lens
}

remove_lens :: proc(box : ^Box, lens : Lens) {
    l := len(box.lenses) 
    if l > 0 {
        for i in 0..<l {
            if box.lenses[i].label == lens.label {
                ordered_remove(&box.lenses, i)
                break
            }
        }
    }
    

}

add_lens :: proc(box : ^Box, lens : Lens) {
    l := len(box.lenses) 
    found := false
    if l == 0 {
        append(&box.lenses, lens)
    } else {
        for i in 0..<l {
            if box.lenses[i].label == lens.label {
                box.lenses[i].focal_length = lens.focal_length
                found = true
                break
            }
        }
        if !found {
            append(&box.lenses, lens)
        }
        
    }

}



process_lens :: proc(boxes : ^[256]Box, box : int, lens : Lens){

    if lens.focal_length == 0 {
        remove_lens(&boxes[box], lens)
    } else {
        add_lens(&boxes[box], lens)
    }

    
}




main :: proc() {
    start := time.now()

    input, open_err := os.open("day_15_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)

    acc := 0

    lens : Lens
    label_byte : [dynamic]u8
    label : string

    boxes : [256]Box

    for i in 0..<size {

        switch text[i]{
            case 44: // ,
            box := int(acc)
            acc = 0
            label = strings.string_from_ptr(&label_byte[0], len(label_byte))
            lens.label = strings.clone(label)
            clear(&label_byte)
            process_lens(&boxes, box, lens)
            lens.focal_length = 0

            case 97..=122:
            append(&label_byte, text[i])
            acc += int(text[i])
            acc *= 17
            acc %= 256
            
            case 48..=57:
            lens.focal_length = int(text[i] - 48)   
        }
    }

    box := int(acc)
    lens.label = strings.string_from_ptr(&label_byte[0], len(label_byte))
    process_lens(&boxes, box, lens)
    acc = 0

    for i in 0..<256 {
        l := len(boxes[i].lenses)
        if l > 0 {
            for j in 0..<l {
                acc += (i + 1) * (j + 1) * boxes[i].lenses[j].focal_length
            }
            
        }
    }

    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(acc, ms, "milliseconds \n")

}