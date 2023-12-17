package day_16_A

import "core:os"
import "core:fmt"
import "core:time"

Dir :: enum {
    UP,
    DOWN,
    LEFT,
    RIGHT
}

get_line_length :: proc(text : ^[]u8) -> int {
    count : int
    for text[count] != 10{
        count += 1
    }
    return count 
}

Grid :: struct {
    size : int,
    stride : int,
    content : [dynamic]u8
}

Beam :: struct {
    location : int,
    direction : Dir
}

ActiveBeam :: struct {
    start_point : Beam,
    loc : int,
    dir : Dir
}

move_point :: proc (beam : ^ActiveBeam, stride : int) {
    switch beam.dir {
        case .UP:
        beam.loc -= stride
        case .DOWN:
        beam.loc += stride 
        case .LEFT:
        if beam.loc % stride == 0 {
            beam.loc = -1
        } else {
            beam.loc -= 1
        }
        case .RIGHT:
        if beam.loc % stride == stride - 1 {
            beam.loc = -1
        } else {
            beam.loc += 1
        }
    }
}

split_point :: proc(point : int, dir : Dir, split : int) -> (Dir, Dir, int) {
    if split == 45 {
        if (dir == .UP || dir == .DOWN) {
            return .RIGHT, .LEFT, point
        }
    } else {
        if (dir == .RIGHT || dir == .LEFT) {
            return .DOWN, .UP, point
        }
    }
    return dir, dir, -1
}

mirror :: proc(dir : Dir, mirror : int) -> Dir {
    if mirror == 47 {
        switch dir{ // /
            case .UP:
            return .RIGHT
            case .DOWN:
            return .LEFT
            case .LEFT:
            return .DOWN
            case .RIGHT:
            return .UP
        }
    } else {
        switch dir{ // \
            case .UP:
            return .LEFT
            case .DOWN:
            return .RIGHT
            case .LEFT:
            return .UP
            case .RIGHT:
            return .DOWN
        }
    }
    return dir
}

is_duplicate :: proc(active_beams : ^[dynamic]ActiveBeam, new_beam : Beam) -> bool {
    for i in 0..<len(active_beams) {
        if new_beam == active_beams[i].start_point{
            return true
        }
    }
    return false
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_16_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)
    
    grid : Grid
    grid.stride = get_line_length(&text)

    light_path : [dynamic]u8

    for i in 0..<len(text){
        switch text[i] {
            case 10:
            continue 
            case:
            append(&grid.content, text[i])
            append(&light_path, 0)
        }
    }
    grid.size = len(grid.content)
    beams : [dynamic]ActiveBeam
    start_beam : Beam = {0, .RIGHT}
    active_beam : ActiveBeam = {start_beam, start_beam.location, start_beam.direction}
    append(&beams, active_beam)

    c := 0
    for {
        
        count := len(beams)
        for i in 0..<len(beams){
            
            fmt.print(c, count, "\n")
            c+=1
            light_path[beams[i].loc] = 1 // mark the active beam location

            split_dir : Dir
            split_loc := -1
            switch grid.content[beams[i].loc] {
                case 47:
                beams[i].dir = mirror(beams[i].dir, 47)
                case 92:
                beams[i].dir = mirror(beams[i].dir, 92)
                case 45:
                beams[i].dir, split_dir, split_loc = split_point(beams[i].loc, beams[i].dir, 45)
                case 124:
                beams[i].dir, split_dir, split_loc = split_point(beams[i].loc, beams[i].dir, 124)
            }
            if split_loc >= 0 {
                split : Beam = {split_loc, split_dir}

                if !is_duplicate(&beams, split) {
                    new_active_beam : ActiveBeam = {split, split.location, split.direction}
                    append(&beams, new_active_beam)
                    break
                } 
                
            }
            move_point(&beams[i], grid.stride)
            if (beams[i].loc < 0 || beams[i].loc >= grid.size) {
                ordered_remove(&beams, i)
            }
        }
        if c >= 150000 {
            break
        }

    }




    end := time.since(start)
    ms := time.duration_milliseconds(end)

     c = 0
    for i in 0..<len(light_path) {
        if light_path[i] == 0 {
            fmt.print(".")

        } else {
            fmt.print("#")
            c+=1
        }
        if i % grid.stride == grid.stride-1 {
            fmt.print("\n")
        }
    }


    fmt.print(c, ms, "milliseconds \n")
}