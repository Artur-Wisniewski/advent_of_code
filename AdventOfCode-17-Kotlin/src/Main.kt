import java.io.File
import java.util.*
import kotlin.collections.HashMap
import kotlin.math.min

enum class Direction(val offsetX: Int, val offsetY: Int) {
    LEFT(-1, 0), DOWN(0, 1), RIGHT(1, 0), UP(0, -1);

    val opposite: Direction
        get() = when (this) {
            UP -> DOWN
            DOWN -> UP
            LEFT -> RIGHT
            RIGHT -> LEFT
        }

}

data class Point(val x: Int, val y: Int)

data class Config(val distance: Int, val point: Point, val direction: Direction?, val stepsInDirection: Int)

fun findShortestPath(
    heatMap: List<List<Int>>, minStepsInOneDirection: Int = 0, maximumStepInOneDirection: Int = 3
): Int {
    val width = heatMap[0].size
    val height = heatMap.size
    val queue = PriorityQueue<Config>() { a, b -> a.distance - b.distance }
    val distances = HashMap<Triple<Direction?, Point, Int>, Int>()
    queue.add(Config(distance = 0, Point(x = 0, y = 0), direction = Direction.RIGHT, stepsInDirection = 0))

    while (queue.isNotEmpty()) {
        val currentConfig = queue.remove()
        val key = Triple(currentConfig.direction, currentConfig.point, currentConfig.stepsInDirection)
        if (key in distances && distances[key]!! <= currentConfig.distance) {
            continue
        }
        distances[key] = currentConfig.distance

        for (newDirection in Direction.entries) {
            val newPosition = Point(
                x = currentConfig.point.x + newDirection.offsetX, y = currentConfig.point.y + newDirection.offsetY
            )


            if ((currentConfig.direction != newDirection && currentConfig.stepsInDirection < minStepsInOneDirection) && currentConfig.point != Point(
                    0, 0
                )
            ) {
                continue
            }
            val newStepsInDirection =
                if (newDirection == currentConfig.direction) currentConfig.stepsInDirection + 1 else 1

            if (newDirection == currentConfig.direction?.opposite) {
                continue
            }
            if (newStepsInDirection > maximumStepInOneDirection) {
                continue
            }
            if (newPosition.x < 0 || newPosition.x >= width || newPosition.y < 0 || newPosition.y >= height) {
                continue
            }

            val cost = heatMap[newPosition.y][newPosition.x]
            val newKey = Triple(newDirection, newPosition, newStepsInDirection)
            if (newKey in distances) {
                continue
            }
            queue.add(
                Config(
                    distance = currentConfig.distance + cost,
                    point = newPosition,
                    direction = newDirection,
                    stepsInDirection = newStepsInDirection
                )
            )

        }
    }

    var minValue = Int.MAX_VALUE
    for ((key, value) in distances) {
        val (_, point, steps) = key
        if (point.x == width - 1 && point.y == height - 1 && steps <= maximumStepInOneDirection && steps >= minStepsInOneDirection) {
            minValue = min(minValue, value)
        }
    }
    return minValue
}

fun readInputFile(): List<String> {
    return File("src/input.txt").readLines()
}

fun main() {
    val lines = readInputFile()
    val heatMap = mutableListOf<MutableList<Int>>()
    for (line in lines) {
        val row = line.map { it.toString().toInt() }.toMutableList()
        heatMap.add(row)
    }
    println("Part2 ${findShortestPath(heatMap, maximumStepInOneDirection = 10, minStepsInOneDirection = 4)}")
}