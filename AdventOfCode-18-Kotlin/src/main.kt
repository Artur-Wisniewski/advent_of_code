import java.io.File
import kotlin.math.absoluteValue

fun readInputFile(): List<String> {
    return File("src/input.txt").readLines()
}

data class Instruction(val direction: Direction, val distance: Int)

enum class Direction(val offsetX: Int, val offsetY: Int) {
    UP(0, -1),
    DOWN(0, 1),
    LEFT(-1, 0),
    RIGHT(1, 0);


    companion object {
        fun fromLetter(letter: Char): Direction = when (letter) {
            'U' -> UP
            'D' -> DOWN
            'L' -> LEFT
            'R' -> RIGHT
            else -> throw IllegalArgumentException("Unknown direction $letter")
        }
    }
}

data class Point(val x: Int, val y: Int)

data class PlanConfig(
    val points: List<Point>,
    val boundary: Long,
)

fun getPlanConfig(instructions: List<Instruction>): PlanConfig {
    var currentPosition = Point(0, 0)
    var boundary = 0L
    val points = mutableListOf<Point>()
    points.add(currentPosition)
    for (instruction in instructions) {
        boundary += instruction.distance
        currentPosition = Point(
            currentPosition.x + instruction.direction.offsetX * instruction.distance,
            currentPosition.y + instruction.direction.offsetY * instruction.distance
        )
        points.add(currentPosition)
    }
    return PlanConfig(points, boundary)
}

// https://en.wikipedia.org/wiki/Shoelace_formula
// https://en.wikipedia.org/wiki/Pick%27s_theorem - number of points inside polygon
// Credits: https://www.youtube.com/watch?v=bGWK76_e-LM
fun countShoeLanceFormula(config: PlanConfig): Long {
    var sum = 0L
    val points = config.points
    val b = config.boundary
    for (i in 0 until points.size - 1) {
        val yI = points[i].y
        val xIMinus1 = points[if (0 <= i - 1) i - 1 else points.size - 1].x
        val xIPlus1 = points[i + 1 % points.size].x
        val difference = xIMinus1 - xIPlus1
        val result: Long = yI * difference.toLong()
        sum += result
    }
    val i = (sum / 2).absoluteValue
    val A = i - (b / 2) + 1
    return A + b
}

fun main() {
    val inputLines = readInputFile()
    val instructions = mutableListOf<Instruction>()
    for (line in inputLines) {
        val (direction, distance, _) = line.split(" ")
        instructions.add(Instruction(Direction.fromLetter(direction[0]), distance.toInt()))
    }
    val planConfig = getPlanConfig(instructions)
    println(countShoeLanceFormula(planConfig))

    val part2Instructions = mutableListOf<Instruction>()
    for (line in inputLines) {
        val (_, _, part2Text) = line.split(" ")
        val part2TextTrim = part2Text.substring(1, part2Text.length - 1)
        val directionNumber = part2TextTrim.last().toString().toInt()
        val direction: Direction = when (directionNumber) {
            3 -> Direction.fromLetter('U')
            2 -> Direction.fromLetter('L')
            1 -> Direction.fromLetter('D')
            0 -> Direction.fromLetter('R')
            else -> throw IllegalArgumentException("Unknown direction $directionNumber")
        }
        val distanceHex = part2TextTrim.substring(1, part2TextTrim.length - 1)
        val distance = distanceHex.toInt(16)
        part2Instructions.add(Instruction(direction, distance))
    }
    val planConfig2 = getPlanConfig(part2Instructions)
    println(countShoeLanceFormula(planConfig2))
}
