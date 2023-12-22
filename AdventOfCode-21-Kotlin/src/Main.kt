import java.io.File

fun countSteps(grid: List<List<String>>, startX: Int, startY: Int, maxSteps: Int): Int {
    val answer: MutableSet<Pair<Int, Int>> = mutableSetOf()
    val seen = mutableSetOf(Pair(startY, startX))
    val queue = ArrayDeque<Triple<Int, Int, Int>>()
    queue.add(Triple(startY, startX, maxSteps))

    while (queue.isNotEmpty()) {
        val (y, x, step) = queue.removeFirst()
        if (step % 2 == 0) {
            answer.add(Pair(y, x))
        }
        if (step == 0) {
            continue
        }

        for ((nY, nX) in listOf(
            Pair(y + 1, x),
            Pair(y - 1, x),
            Pair(y, x + 1),
            Pair(y, x - 1)
        )) {
            fun isOutOfBounds(): Boolean = nY < 0 || nY >= grid.size || nX < 0 || nX >= grid[0].size
            fun isRock(): Boolean = grid[nY][nX] == "#"
            fun seenAlready(): Boolean = seen.contains(Pair(nY, nX))

            if (isOutOfBounds() || isRock() || seenAlready()) {
                continue
            }
            seen.add(Pair(nY, nX))
            queue.add(Triple(nY, nX, step - 1))
        }
    }
    return answer.size
}

fun countMassiveGrid(grid: List<List<String>>, startX: Int, startY: Int, steps: Int): Long {
    val bigGridWidth = steps / grid.size - 1L
    val oddCopiedGridsCount = ((bigGridWidth / 2) * 2 + 1) * ((bigGridWidth / 2) * 2 + 1)
    val evenCopiedGridsCount = ((bigGridWidth + 1) / 2 * 2) * ((bigGridWidth + 1) / 2 * 2)
    val oddPointsCount = countSteps(grid, startX, startY, (grid.size * 2 + 1))
    val evenPointsCount = countSteps(grid, startX, startY, (grid.size * 2))
    val cornerTopCase =  countSteps(grid, startX, (grid.size - 1), grid.size - 1)
    val cornerRightCase =  countSteps(grid, 0, startY, grid.size - 1)
    val cornerBottom =  countSteps(grid, startX, 0, grid.size - 1)
    val cornerLeft =  countSteps(grid, grid.size - 1, startY, grid.size - 1)
    val smallTopRight =  countSteps(grid, 0, grid.size - 1, grid.size / 2 - 1)
    val smallTopLeft =  countSteps(grid, grid.size - 1, grid.size - 1, grid.size / 2 - 1)
    val smallBottomRight =  countSteps(grid, 0, 0, grid.size / 2 - 1)
    val smallBottomLeft =  countSteps(grid, grid.size - 1, 0, grid.size / 2 - 1)
    val largeTopRight =  countSteps(grid, 0, grid.size - 1, grid.size * 3 / 2 - 1)
    val largeTopLeft =  countSteps(grid, grid.size - 1, grid.size - 1, grid.size * 3 / 2 - 1)
    val largeBottomRight =  countSteps(grid, 0, 0, grid.size * 3 / 2 - 1)
    val largeBottomLeft =  countSteps(grid, grid.size - 1, 0, grid.size * 3 / 2 - 1)
    return oddCopiedGridsCount * oddPointsCount +
            evenCopiedGridsCount * evenPointsCount +
            cornerTopCase + cornerRightCase + cornerBottom + cornerLeft +
            (bigGridWidth + 1) * (smallTopRight + smallTopLeft + smallBottomRight + smallBottomLeft) +
            bigGridWidth * (largeTopRight + largeTopLeft + largeBottomRight + largeBottomLeft)
}
fun main() {
    val lines = File("src/input.txt").readLines()
    val grid: List<List<String>> = lines.map {
        val list = it.split("")
        list.subList(1, list.size - 1)
    }
    val startX = grid.find { it.contains("S") }!!.indexOf("S")
    val startY = grid.indexOf(grid.find { it.contains("S") })
    println("Part1:")
    println(countSteps(grid, startX, startY, 64))
    println("Part2:")
    println(countMassiveGrid(grid, startX, startY, 26501365))
}