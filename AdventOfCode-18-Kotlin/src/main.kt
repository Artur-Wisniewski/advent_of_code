import java.io.File
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

fun readInputFile(): List<String> {
    return File("src/input.txt").readLines()
}

data class Instruction(val direction: Direction, val distance: Int, val color: String)

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

data class PlanConfig(val startX: Int, val endX: Int, val startY: Int, val endY: Int, val width: Int, val height: Int)

fun calculatePlanConfig(instructions: List<Instruction>): PlanConfig {
    var currentPosition = Pair(0, 0)
    var startWidth = 0
    var endWidth = 0
    var startHeight = 0
    var endHeight = 0

    for (instruction in instructions) {
        currentPosition = Pair(
            currentPosition.first + instruction.direction.offsetX * instruction.distance,
            currentPosition.second + instruction.direction.offsetY * instruction.distance
        )
        val direction = instruction.direction
        if (direction == Direction.LEFT || direction == Direction.RIGHT) {
            startWidth = min(startWidth, currentPosition.first)
            endWidth = max(endWidth, currentPosition.first)
        } else {
            startHeight = min(startHeight, currentPosition.second)
            endHeight = max(endHeight, currentPosition.second)
        }
    }
    val width = endWidth - startWidth + 1
    val height = endHeight - startHeight + 1
    return PlanConfig(startWidth, endWidth, startHeight, endHeight, width, height)
}

fun createPlan(instructions: List<Instruction>, planConfig: PlanConfig): MutableList<MutableList<Boolean>> {
    val width = planConfig.width
    val height = planConfig.height
    val startWidth = planConfig.startX
    val startHeight = planConfig.startY

    val plan = mutableListOf<MutableList<Boolean>>()
    for (i in 0 until height) {
        plan.add(mutableListOf())
        for (j in 0 until width) {
            plan[i].add(false)
        }
    }
    var currentPosition = Pair(abs(startWidth), abs(startHeight))
    for (instruction in instructions) {
        val direction = instruction.direction
        val distance = instruction.distance
        for (i in 0 until distance) {
            plan[currentPosition.second][currentPosition.first] = true
            currentPosition =
                Pair(currentPosition.first + direction.offsetX, currentPosition.second + direction.offsetY)
        }
    }
    return plan
}

fun printPlan(plan: List<List<Boolean>>, planConfig: PlanConfig) {
    for ((i, row) in plan.withIndex()) {
        for ((j, cell) in row.withIndex()) {
            if (i == abs(planConfig.startY) && j == abs(planConfig.startX)) {
                print("S")
                continue
            }
            print(if (cell) "X" else ".")
        }
        println()
    }
}

fun countInnerLava(plan: MutableList<MutableList<Boolean>>, firstPoint: Pair<Int, Int>, planConfig: PlanConfig): Int {
    var count = 0
    val queue = ArrayDeque<Pair<Int, Int>>()
    queue.add(firstPoint)
    while (queue.isNotEmpty()) {
        val point = queue.removeFirst()
        if (plan[point.second][point.first]) continue
        plan[point.second][point.first] = true
        count++
        if (point.first + 1 < planConfig.width && !plan[point.second][point.first + 1]) {
            queue.add(Pair(point.first + 1, point.second))
        }
        if (point.first - 1 >= 0 && !plan[point.second][point.first - 1]) {
            queue.add(Pair(point.first - 1, point.second))
        }

        if (point.second + 1 < planConfig.height && !plan[point.second + 1][point.first]) {
            queue.add(Pair(point.first, point.second + 1))
        }

        if (point.second - 1 >= 0 && !plan[point.second - 1][point.first]) {
            queue.add(Pair(point.first, point.second - 1))
        }
    }
    return count
}

fun countOuterLava(instructions: List<Instruction>): Int {
    var count = 0
    for (instruction in instructions) {
        count += instruction.distance
    }
    return count
}

fun main() {
    val inputLines = readInputFile()
    val instructions = mutableListOf<Instruction>()
    for (line in inputLines) {
        val (direction, distance, color) = line.split(" ")
        instructions.add(Instruction(Direction.fromLetter(direction[0]), distance.toInt(), color))
    }
    val planConfig = calculatePlanConfig(instructions)
    val plan = createPlan(instructions, planConfig)
//    printPlan(plan, planConfig)
    print(
        countOuterLava(instructions) + countInnerLava(
            plan = plan,
            firstPoint = (Pair(abs(planConfig.startX) + 1, abs(planConfig.startY) + 1)),
            planConfig = planConfig
        )
    )
}
